import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'cubits/TaskScreen_cubit/task_screen_cubit.dart';
import 'screens/AddTaskScreen.dart';
import 'screens/ProfileScreen.dart';

import 'constants/AppColors.dart';
import 'screens/LoginScreen.dart';
import 'screens/SignUpScreen.dart';
import 'screens/TaskScreen.dart';
import 'screens/WelcomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check for refresh token
  final initialRoute = await determineInitialRoute();

  runApp(
    BlocProvider(
      create: (context) => TaskScreenCubit()..fetchTasks(),
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}

Future<String> determineInitialRoute() async {
  final prefs = await SharedPreferences.getInstance();
  final refreshToken = prefs.getString('refresh_token');

  if (refreshToken == null || refreshToken.isEmpty) {
    return '/welcomeScreen';
  } else {
    return '/taskpage';
  }
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({required this.initialRoute, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tasky',
      theme: ThemeData(
        fontFamily: 'DM Sans', // Apply DM Sans globally
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16.0),
          bodyMedium: TextStyle(fontSize: 14.0),
          labelLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),

        useMaterial3: true,
      ),

      initialRoute: initialRoute,
      // initialRoute: '/',
      routes: {
        '/welcomeScreen': (context) => Welcome(),
        '/logInScreen': (context) => LoginScreen(),
        '/signUpScreen': (context) => SignUpScreen(),
        '/taskpage': (context) => TaskScreen(),
        '/profilescreen': (context) => ProfileScreen(),
        '/addtaskscreen': (context) => AddTaskScreen(),
      },
    );
  }
}
