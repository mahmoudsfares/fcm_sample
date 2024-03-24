import 'package:fcm_sample/notifications/notifications_api.dart';
import 'package:fcm_sample/screens/notification_data_screen.dart';
import 'package:fcm_sample/screens/second_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  void _initNotifications() async {
    await NotificationsApi.initNotifications();
    var initialNotification = await NotificationsApi.localNotificationsPlugin.getNotificationAppLaunchDetails();
    if (initialNotification?.didNotificationLaunchApp == true) {
      Fluttertoast.showToast(msg: 'Notification launched the app');
      // avoid using context across an async gap by ensuring that the context is used after the current frame is rendered
      Future.delayed(
        Duration.zero,
        () => Navigator.pushNamed(context, NotificationDataScreen.route,
            arguments: initialNotification?.notificationResponse?.payload),
      );
    } else {
      NotificationsApi.notificationStream.stream.listen((payload) {
        Fluttertoast.showToast(msg: 'Notification clicked while app is alive');
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
