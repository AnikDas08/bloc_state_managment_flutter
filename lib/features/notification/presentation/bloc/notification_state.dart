import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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

  const NotificationActive({
    this.fcmToken,
    required this.hasPermission,
    this.lastReceivedMessage,
    this.lastClickedMessage,
  });

  NotificationActive copyWith({
    String? fcmToken,
    bool? hasPermission,
    RemoteMessage? lastReceivedMessage,
    RemoteMessage? lastClickedMessage,
  }) {
    return NotificationActive(
      fcmToken: fcmToken ?? this.fcmToken,
      hasPermission: hasPermission ?? this.hasPermission,
      lastReceivedMessage: lastReceivedMessage ?? this.lastReceivedMessage,
      lastClickedMessage: lastClickedMessage ?? this.lastClickedMessage,
    );
  }

  @override
  List<Object?> get props => [
        fcmToken,
        hasPermission,
        lastReceivedMessage,
        lastClickedMessage,
      ];
}

class NotificationFailure extends NotificationState {
  final String errorMessage;

  const NotificationFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
