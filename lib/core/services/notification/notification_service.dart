import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  // Streams for notifications
  final StreamController<RemoteMessage> _messageStreamController = StreamController<RemoteMessage>.broadcast();
  final StreamController<RemoteMessage> _clickStreamController = StreamController<RemoteMessage>.broadcast();
  final StreamController<String> _tokenStreamController = StreamController<String>.broadcast();

  Stream<RemoteMessage> get messageStream => _messageStreamController.stream;
  Stream<RemoteMessage> get clickStream => _clickStreamController.stream;
  Stream<String> get tokenStream => _tokenStreamController.stream;

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
  );

  /// Initializes firebase messaging and local notifications
  Future<void> initialize() async {
    // 1. Request initial permissions (both iOS and Android 13+)
    await requestPermission();

    // 2. Initialize Flutter Local Notifications for foreground notifications
    await _initLocalNotifications();

    // 3. Setup Firebase event listeners (foreground, click, token refresh)
    _setupFirebaseListeners();

    // 4. Check for initial message (when app opened from terminated state)
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _clickStreamController.add(initialMessage);
    }
  }

  /// Request permissions for Push Notifications
  Future<bool> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Request permissions for Android 13+ (POST_NOTIFICATIONS)
    final androidPlugin = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }

    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  /// Fetch FCM Token
  Future<String?> getFcmToken() async {
    try {
      if (Platform.isIOS) {
        final apnsToken = await _messaging.getAPNSToken();
        if (apnsToken == null) {
          print("⚠️ iOS APNS token is not ready yet. FCM Token cannot be fetched.");
          return null;
        }
      }
      final token = await _messaging.getToken();
      return token;
    } catch (e, stack) {
      print("❌ Error getting FCM Token: $e");
      print(stack);
      return null;
    }
  }

  Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        if (payload != null) {
          try {
            final Map<String, dynamic> data = jsonDecode(payload);
            final message = RemoteMessage(data: data);
            _clickStreamController.add(message);
          } catch (_) {
            _clickStreamController.add(RemoteMessage(data: {'payload': payload}));
          }
        }
      },
    );

    // Create Android channel for heads-up notifications
    final androidPlugin = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(_channel);
    }
  }

  void _setupFirebaseListeners() {
    // 1. Listen to foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _messageStreamController.add(message);
      _showLocalNotification(message);
    });

    // 2. Listen to clicked messages from background state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _clickStreamController.add(message);
    });

    // 3. Listen to token refresh
    _messaging.onTokenRefresh.listen((String token) {
      _tokenStreamController.add(token);
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final androidDetails = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: details,
      payload: jsonEncode(message.data),
    );
  }

  void dispose() {
    _messageStreamController.close();
    _clickStreamController.close();
    _tokenStreamController.close();
  }
}
