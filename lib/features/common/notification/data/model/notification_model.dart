import 'package:flutter/material.dart';

enum NotificationCategory {
  transaction,
  coupon,
  system,
  security,
}

extension NotificationCategoryX on NotificationCategory {
  String get label {
    switch (this) {
      case NotificationCategory.transaction:
        return 'Transactions';
      case NotificationCategory.coupon:
        return 'Promos';
      case NotificationCategory.system:
        return 'System';
      case NotificationCategory.security:
        return 'Security';
    }
  }

  IconData get icon {
    switch (this) {
      case NotificationCategory.transaction:
        return Icons.receipt_long_rounded;
      case NotificationCategory.coupon:
        return Icons.local_offer_rounded;
      case NotificationCategory.system:
        return Icons.circle_notifications_rounded;
      case NotificationCategory.security:
        return Icons.shield_rounded;
    }
  }

  Color get color {
    switch (this) {
      case NotificationCategory.transaction:
        return const Color(0xFF2196F3);
      case NotificationCategory.coupon:
        return const Color(0xFFFF9800);
      case NotificationCategory.system:
        return const Color(0xFF9C27B0);
      case NotificationCategory.security:
        return const Color(0xFF4CAF50);
    }
  }

  Color get backgroundColor {
    switch (this) {
      case NotificationCategory.transaction:
        return const Color(0xFFE3F2FD);
      case NotificationCategory.coupon:
        return const Color(0xFFFFF3E0);
      case NotificationCategory.system:
        return const Color(0xFFF3E5F5);
      case NotificationCategory.security:
        return const Color(0xE8E8F5E9);
    }
  }
}

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final NotificationCategory category;
  final bool isRead;
  final Map<String, dynamic>? payload;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.category,
    this.isRead = false,
    this.payload,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? timestamp,
    NotificationCategory? category,
    bool? isRead,
    Map<String, dynamic>? payload,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      category: category ?? this.category,
      isRead: isRead ?? this.isRead,
      payload: payload ?? this.payload,
    );
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  static List<NotificationModel> get initialMockNotifications => [
        NotificationModel(
          id: '1',
          title: 'Payment Received from Starbucks',
          body: 'Receipt #RZ-84920 has been processed successfully. Total amount: \$14.50.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
          category: NotificationCategory.transaction,
          isRead: false,
          payload: {'type': 'receipt', 'id': '84920'},
        ),
        NotificationModel(
          id: '2',
          title: 'New Discount Coupon Available!',
          body: 'You unlocked a 20% OFF coupon on your next merchant transaction. Claim it now!',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          category: NotificationCategory.coupon,
          isRead: false,
          payload: {'type': 'coupon', 'code': 'RIZIPT20'},
        ),
        NotificationModel(
          id: '3',
          title: 'Security Alert: New Sign In',
          body: 'Your account was accessed from Chrome on macOS at 10:42 AM. If this wasn\'t you, tap to review.',
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          category: NotificationCategory.security,
          isRead: true,
          payload: {'type': 'security'},
        ),
        NotificationModel(
          id: '4',
          title: 'System Maintenance Notice',
          body: 'RIZIPT services will undergo scheduled maintenance tonight at 2:00 AM UTC for 30 minutes.',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          category: NotificationCategory.system,
          isRead: true,
        ),
        NotificationModel(
          id: '5',
          title: 'Monthly Summary Ready',
          body: 'Your transaction summary for last month is ready to view. Total receipts managed: 42.',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          category: NotificationCategory.transaction,
          isRead: true,
        ),
      ];
}
