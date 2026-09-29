import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../data/model/notification_model.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationActive extends NotificationState {
  final String? fcmToken;
  final bool hasPermission;
  final RemoteMessage? lastReceivedMessage;
  final RemoteMessage? lastClickedMessage;
  final List<NotificationModel> notifications;
  final String activeFilter;

  const NotificationActive({
    this.fcmToken,
    required this.hasPermission,
    this.lastReceivedMessage,
    this.lastClickedMessage,
    this.notifications = const [],
    this.activeFilter = 'All',
  });

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  List<NotificationModel> get filteredNotifications {
    if (activeFilter == 'All') {
      return notifications;
    } else if (activeFilter == 'Unread') {
      return notifications.where((n) => !n.isRead).toList();
    } else {
      return notifications
          .where((n) =>
              n.category.label.toLowerCase() == activeFilter.toLowerCase())
          .toList();
    }
  }

  NotificationActive copyWith({
    String? fcmToken,
    bool? hasPermission,
    RemoteMessage? lastReceivedMessage,
    RemoteMessage? lastClickedMessage,
    List<NotificationModel>? notifications,
    String? activeFilter,
  }) {
    return NotificationActive(
      fcmToken: fcmToken ?? this.fcmToken,
      hasPermission: hasPermission ?? this.hasPermission,
      lastReceivedMessage: lastReceivedMessage ?? this.lastReceivedMessage,
      lastClickedMessage: lastClickedMessage ?? this.lastClickedMessage,
      notifications: notifications ?? this.notifications,
      activeFilter: activeFilter ?? this.activeFilter,
    );
  }

  @override
  List<Object?> get props => [
        fcmToken,
        hasPermission,
        lastReceivedMessage,
        lastClickedMessage,
        notifications,
        activeFilter,
      ];
}

class NotificationFailure extends NotificationState {
  final String errorMessage;

  const NotificationFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
