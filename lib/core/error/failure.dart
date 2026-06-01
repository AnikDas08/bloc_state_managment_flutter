import 'package:equatable/equatable.dart';

/// সমস্ত এরর বা ফেইলিউরের মাদার ক্লাস (Base Class)
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// ১. সার্ভার বা এপিআই সংক্রান্ত এরর হ্যান্ডেল করার জন্য (যেমন: 400, 404, 500)
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// ২. ইন্টারনেট কানেকশন না থাকলে বা নেটওয়ার্ক টাইম-আউট হলে
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = "ইন্টারনেট কানেকশন নেই! অনুগ্রহ করে আবার চেষ্টা করুন।"]);
}

/// ৩. লোকাল ডাটাবেজ (যেমন: SharedPreferences, Hive, SQLite) থেকে ডাটা রিড/রাইট করতে সমস্যা হলে
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// ৪. ইউজার যদি ফর্ম ভ্যালিডেশন বা ইনপুট দিতে ভুল করে (Custom UI Validation)
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}