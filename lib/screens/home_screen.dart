import 'dart:convert';
import 'package:fcm_sample/notifications/notifications_api.dart';
import 'package:fcm_sample/screens/notification_data_screen.dart';
import 'package:fcm_sample/screens/second_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final RemoteMessage? message;

  const HomeScreen(this.message, {super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationsApi.setContext(context);
      if (widget.message != null) {
        Future.delayed(Duration.zero, () async {
          Navigator.pushNamed(context, NotificationDataScreen.route, arguments: jsonEncode(widget.message!.data));
        });
      }
    });
    _initNotifications();
  }

  void _initNotifications() async {
    await NotificationsApi.initNotifications();
    var initialNotification = await NotificationsApi.localNotificationsPlugin.getNotificationAppLaunchDetails();
    if (initialNotification?.didNotificationLaunchApp == true) {
      // avoid using context across an async gap by ensuring that the context is used after the current frame is rendered
      Future.delayed(
        Duration.zero,
        () => Navigator.pushNamed(
          context,
          NotificationDataScreen.route,
          arguments: initialNotification?.notificationResponse?.payload,
        ),
      );
    } else {
      Stream<RemoteMessage> stream = FirebaseMessaging.onMessageOpenedApp;
      stream.listen((RemoteMessage message) async {
        Map<String, dynamic> payload = message.data;
        String text = payload['text'];
        Navigator.pushNamed(context, NotificationDataScreen.route, arguments: text);
      });
      NotificationsApi.notificationStream.stream.listen((payload) {
        Navigator.pushNamed(context, NotificationDataScreen.route, arguments: payload);
      });
      // TODO: uncomment this to test with this screen as a splash screen
      // Future.delayed(Durations.extralong4, () => Navigator.pushNamed(context, SecondScreen.route));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('home')),
      body: Center(
        // TODO: uncomment this to test with this screen as a splash screen
        // child: Text('Loading..'),
        // TODO: uncomment this to test with this screen as a normal screen
        child: ElevatedButton(
          child: const Text('Go to second screen'),
          onPressed: () => Navigator.pushNamed(context, SecondScreen.route),
        ),
      ),
    );
  }
}
