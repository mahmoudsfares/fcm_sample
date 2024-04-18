import 'dart:async';
import 'package:fcm_sample/notifications/notifications_api.dart';
import 'package:fcm_sample/screens/second_screen.dart';
import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {

  static const String route = "/first";

  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO 20: initialize notifications and head to the next screen
    _initNotifications(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Splash Screen')),
      body: const Center(
        child: Text('Loading..'),
      ),
    );
  }

  Future<void> _initNotifications(BuildContext context) async {
    await NotificationsApi.initNotifications();
    Future.delayed(Durations.extralong4, () => Navigator.pushReplacementNamed(context, SecondScreen.route));
  }
}
