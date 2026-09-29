import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class InitializeNotifications extends NotificationEvent {
  const InitializeNotifications();
}

class NotificationReceivedEvent extends NotificationEvent {
  final RemoteMessage message;

  const NotificationReceivedEvent(this.message);

  @override
  List<Object?> get props => [message];
}

class NotificationClickedEvent extends NotificationEvent {
  final RemoteMessage message;

  const NotificationClickedEvent(this.message);

  @override
  List<Object?> get props => [message];
}

class FcmTokenUpdatedEvent extends NotificationEvent {
  final String token;

  const FcmTokenUpdatedEvent(this.token);

  @override
  List<Object?> get props => [token];
}

class MarkNotificationAsRead extends NotificationEvent {
  final String id;

  const MarkNotificationAsRead(this.id);

  @override
  List<Object?> get props => [id];
}

class MarkAllNotificationsAsRead extends NotificationEvent {
  const MarkAllNotificationsAsRead();
}

class DeleteNotification extends NotificationEvent {
  final String id;

  const DeleteNotification(this.id);

  @override
  List<Object?> get props => [id];
}

class ClearAllNotifications extends NotificationEvent {
  const ClearAllNotifications();
}

class FilterNotifications extends NotificationEvent {
  final String categoryFilter;

  const FilterNotifications(this.categoryFilter);

  @override
  List<Object?> get props => [categoryFilter];
}
