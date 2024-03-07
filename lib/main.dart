import 'package:fcm_sample/screens/home_screen.dart';
import 'package:fcm_sample/screens/notification_data_screen.dart';
import 'package:fcm_sample/screens/second_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      routes: {
        SecondScreen.route: (context) => const SecondScreen(),
        NotificationDataScreen.route: (context) => const NotificationDataScreen(),
      },
    );
  }
}
