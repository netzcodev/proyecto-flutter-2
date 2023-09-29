import 'dart:io';
import 'package:cars_app/config/config.dart';
import 'package:cars_app/features/notificactions/domain/entities/push_message.dart';
import 'package:cars_app/features/shared/infraestructure/services/keyvalue_storage_service.dart';
import 'package:cars_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  int pushNumberId = 0;
  final Future<void> Function()? requestLocalNotificationsPermissions;
  final void Function({
    required int id,
    String? title,
    String? body,
    String? data,
  })? showLocalNotification;
  final KeyValueStorageService? keyValueStorage;

  NotificationsBloc({
    this.requestLocalNotificationsPermissions,
    this.showLocalNotification,
    this.keyValueStorage,
  }) : super(const NotificationsState()) {
    on<NotificationsStatusChanged>(_notificationStatusChanged);
    on<NotificationRecieved>(_pushMessageRecieved);

    _initialStatusCheck();
    _onForegroundMessage();
  }

  static Future<void> initializeFCM() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  void _notificationStatusChanged(
      NotificationsStatusChanged event, Emitter<NotificationsState> emit) {
    emit(state.copyWith(status: event.status));
    _getFCMToken();
  }

  void _pushMessageRecieved(
      NotificationRecieved event, Emitter<NotificationsState> emit) {
    emit(
      state.copyWith(
        notifications: [
          event.message,
          ...state.notifications,
        ],
      ),
    );
  }

  void _initialStatusCheck() async {
    final settings = await messaging.getNotificationSettings();
    add(NotificationsStatusChanged(settings.authorizationStatus));
  }

  void handleRemoteMessage(RemoteMessage message) {
    if (message.notification == null) return;

    final notification = PushMessage(
      messageId:
          message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '',
      title: message.notification!.title ?? '',
      body: message.notification!.body ?? '',
      sentDate: message.sentTime ?? DateTime.now(),
      data: message.data,
      imageUrl: Platform.isAndroid
          ? message.notification!.android?.imageUrl ?? ''
          : message.notification!.apple?.imageUrl ?? '',
    );

    if (showLocalNotification != null) {
      showLocalNotification!(
        id: ++pushNumberId,
        body: notification.body,
        data: '${notification.data?['type'] ?? ''},${notification.messageId}',
        title: notification.title,
      );
    }
    add(NotificationRecieved(notification));
  }

  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }

  void _getFCMToken() async {
    if (state.status != AuthorizationStatus.authorized) return;
    final token = await messaging.getToken();
    print(token);

    if (keyValueStorage != null) {
      final key = await keyValueStorage!.getKeyValue<String>('firebaseToken');

      if (key != null) {
        return;
      } else {
        await keyValueStorage!.setKeyValue<String>('firebaseToken', token!);
      }
    }
  }

  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    if (requestLocalNotificationsPermissions != null) {
      await requestLocalNotificationsPermissions!();
    }

    add(NotificationsStatusChanged(settings.authorizationStatus));
  }

  PushMessage? getMessageById(String pushMessageId) {
    final exist = state.notifications
        .any((element) => element.messageId == pushMessageId);

    if (!exist) return null;

    return state.notifications
        .firstWhere((element) => element.messageId == pushMessageId);
  }
}
