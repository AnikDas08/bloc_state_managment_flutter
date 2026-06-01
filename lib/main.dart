import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'config/route/app_routes.dart';
import 'config/route/route_generator.dart';
import 'core/di/service_locator.dart' as di;

void main() async {
  // Ensure Flutter bindings are initialized before DI
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Dependency Injection
  await di.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Clean BLoC',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          initialRoute: AppRoutes.signInCubit,
          onGenerateRoute: RouteGenerator.generateRoute,
        );
      },
    );
  }
}
