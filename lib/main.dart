import 'dart:async';

import 'package:cars_app/config/config.dart';
import 'package:cars_app/features/notificactions/presentation/blocs/notifications/notifications_bloc.dart';
import 'package:cars_app/features/notificactions/presentation/screens/notifications_details_screen.dart';
import 'package:cars_app/features/shared/infraestructure/services/keyvalue_storage_service_impl.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  await Environment.initEnvironment();
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await NotificationsBloc.initializeFCM();
  await LocalNotifications.initializeLocalNotifications();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NotificationsBloc(
            requestLocalNotificationsPermissions:
                LocalNotifications.requestPermissionLocalNotification,
            showLocalNotification: LocalNotifications.showLocalNotification,
            keyValueStorage: KeyValueStorageServiceImpl(),
          ),
        )
      ],
      child: const ProviderScope(
        child: MainApp(),
      ),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
      builder: (context, child) =>
          HandleNotificationInteractions(child: child!),
    );
  }
}

class HandleNotificationInteractions extends ConsumerStatefulWidget {
  final Widget child;

  const HandleNotificationInteractions({
    super.key,
    required this.child,
  });

  @override
  HandleNotificationInteractionsState createState() =>
      HandleNotificationInteractionsState();
}

class HandleNotificationInteractionsState
    extends ConsumerState<HandleNotificationInteractions> {
  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    context.read<NotificationsBloc>().handleRemoteMessage(message);
    final route = ref.read(goRouterProvider);
    final messageId =
        message.messageId?.replaceAll(':', '').replaceAll('%', '');

    route.go('/notifications-details/$messageId');
  }

  void _configureSelectNotificationSubject() {
    LocalNotifications.selectNotificationStream.stream
        .listen((String? payload) async {
      if (payload!.split(',')[0] == 'mileage') {
        ref
            .read(goRouterProvider)
            .go('/notifications-details/${payload.split(',')[1]}');
      } else {
        ref.read(goRouterProvider).go('/calendar');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setupInteractedMessage();
    _configureSelectNotificationSubject();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
