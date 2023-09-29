part of 'notifications_bloc.dart';

sealed class NotificationsEvent {
  const NotificationsEvent();
}

class NotificationsStatusChanged extends NotificationsEvent {
  final AuthorizationStatus status;

  NotificationsStatusChanged(this.status);
}

class NotificationRecieved extends NotificationsEvent {
  final PushMessage message;

  NotificationRecieved(this.message);
}

class NotificationTaped extends NotificationsEvent {
  final String id;

  NotificationTaped(this.id);
}
