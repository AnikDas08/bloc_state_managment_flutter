part of 'complete_profile_bloc.dart';

@immutable
abstract class CompleteProfileEvent {}

class CompleteProfileData extends CompleteProfileEvent {
  final String name;
  final String email;
  final String phone;
  final int age;

  CompleteProfileData({
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
  });
}
