import 'package:flutter/material.dart';
import 'package:la8ini/core/di/service_locator.dart';
import 'package:la8ini/splash_screen/splash_screen.dart';
import 'package:la8ini/auth/presentation/pages/login_page.dart';

void main() async {
  await setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home:SplashScreen(), debugShowCheckedModeBanner: false);
  }
}
