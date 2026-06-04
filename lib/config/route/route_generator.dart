import 'package:flutter/material.dart';
import '../../features/auth/presentation/compl_profile/screen/complete_profile_screen.dart';
import '../../features/auth/presentation/sign_in/screen/signin_screen.dart';
import '../../features/auth/presentation/sign_in_cubit/screen/signin_cubit_screen.dart';
import '../../features/auth/presentation/sign_up/screen/signup_screen.dart';
import '../../features/auth/presentation/sign_up_cubit/screen/signup_cubit_screen.dart';
import '../../features/home/presentation/screen/home_screen.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.signIn:
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      case AppRoutes.signInCubit:
        return MaterialPageRoute(builder: (_) => const SignInCubitScreen());
      case AppRoutes.signUp:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case AppRoutes.signUpCubit:
        return MaterialPageRoute(builder: (_) => const SignUpCubitScreen());
      case AppRoutes.completeProfile:
        return MaterialPageRoute(builder: (_) => const CompleteProfileScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Page not found')),
      );
    });
  }
}
