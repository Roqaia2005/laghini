import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:la8ini/core/di/service_locator.dart';
import 'package:la8ini/splash_screen/splash_screen.dart';
import 'package:la8ini/auth/presentation/blocs/auth_cubit.dart';
import 'package:la8ini/auth/presentation/pages/login_page.dart';
import 'package:la8ini/auth/presentation/pages/signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) =>AuthCubit(sl()),
        child: SignupPage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
