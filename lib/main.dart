import 'package:fcm_sample/notifications/notifications_api.dart';
import 'package:fcm_sample/screens/home_screen.dart';
import 'package:fcm_sample/screens/notification_data_screen.dart';
import 'package:fcm_sample/screens/second_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // TODO 17: ensure widgets binding initialization
  WidgetsFlutterBinding.ensureInitialized();
  // TODO 18: initialize firebase and check for initial message in case the app was opened by tapping a notification while terminated
  await Firebase.initializeApp();
  final RemoteMessage? message = await NotificationsApi.initialMessage;
  // TODO 19: pass the message to the first screen to use the payload to navigate and show data
  runApp(MyApp(message));
}

class MyApp extends StatelessWidget {

  final RemoteMessage? message;
  const MyApp(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(message),
      routes: {
        SecondScreen.route: (context) => const SecondScreen(),
        NotificationDataScreen.route: (context) => const NotificationDataScreen(),
      },
    );
  }
}
