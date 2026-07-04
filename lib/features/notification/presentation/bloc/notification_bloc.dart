import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/notification/notification_service.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationService _notificationService;
  StreamSubscription? _messageSubscription;
  StreamSubscription? _clickSubscription;
  StreamSubscription? _tokenSubscription;

  NotificationBloc({required NotificationService notificationService})
    : _notificationService = notificationService,
      super(NotificationInitial()) {
    on<InitializeNotifications>(_onInitializeNotifications);
    on<NotificationReceivedEvent>(_onNotificationReceived);
    on<NotificationClickedEvent>(_onNotificationClicked);
    on<FcmTokenUpdatedEvent>(_onFcmTokenUpdated);
  }

  Future<void> _onInitializeNotifications(
    InitializeNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    try {
      // 1. Initialize service
      await _notificationService.initialize();

      // 2. Request permissions & check authorization
      final hasPermission = await _notificationService.requestPermission();

      // 3. Fetch current FCM token
      final token = await _notificationService.getFcmToken();
      print("🔔 FCM Registration Token: $token");

      // 4. Start listening to streams
      _cancelSubscriptions();
      _messageSubscription = _notificationService.messageStream.listen(
        (message) => add(NotificationReceivedEvent(message)),
      );
      _clickSubscription = _notificationService.clickStream.listen(
        (message) => add(NotificationClickedEvent(message)),
      );
      _tokenSubscription = _notificationService.tokenStream.listen(
        (token) => add(FcmTokenUpdatedEvent(token)),
      );

      emit(NotificationActive(fcmToken: token, hasPermission: hasPermission));
    } catch (e) {
      emit(NotificationFailure(e.toString()));
    }
  }

  void _onNotificationReceived(
    NotificationReceivedEvent event,
    Emitter<NotificationState> emit,
  ) {
    final currentState = state;
    if (currentState is NotificationActive) {
      emit(currentState.copyWith(lastReceivedMessage: event.message));
    }
  }

  void _onNotificationClicked(
    NotificationClickedEvent event,
    Emitter<NotificationState> emit,
  ) {
    final currentState = state;
    if (currentState is NotificationActive) {
      emit(currentState.copyWith(lastClickedMessage: event.message));
    }
  }

  void _onFcmTokenUpdated(
    FcmTokenUpdatedEvent event,
    Emitter<NotificationState> emit,
  ) {
    final currentState = state;
    if (currentState is NotificationActive) {
      emit(currentState.copyWith(fcmToken: event.token));
    }
  }

  void _cancelSubscriptions() {
    _messageSubscription?.cancel();
    _clickSubscription?.cancel();
    _tokenSubscription?.cancel();
  }

  @override
  Future<void> close() {
    _cancelSubscriptions();
    return super.close();
  }
}
