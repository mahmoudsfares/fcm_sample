import 'package:flutter/material.dart';

class NotificationDataScreen extends StatelessWidget {

  static const String route = "/notificationData";

  const NotificationDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String message = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(title: const Text('notification data')),
      body: Center(
        child: Text(
          message,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}