import 'package:flutter/material.dart';
import '../../features/auth/sign_in/presentation/page/signin_screen.dart';
import '../../features/auth/sign_in_cubit/presentation/page/signin_cubit_screen.dart';
import '../../features/auth/sign_up/presentation/page/signup_screen.dart';
import '../../features/auth/sign_up_cubit/presentation/page/signup_cubit_screen.dart';
import '../../features/auth/compl_profile/presentation/page/complete_profile_screen.dart';
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
      // Add other routes here as you implement them
      // case AppRoutes.home:
      //   return MaterialPageRoute(builder: (_) => const HomePage());
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
