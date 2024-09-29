import 'dart:convert';
import 'package:flutter/material.dart';

class NotificationDataScreen extends StatefulWidget {

  static const String route = "/notificationData";

  const NotificationDataScreen({super.key});

  @override
  State<NotificationDataScreen> createState() => _NotificationDataScreenState();
}

class _NotificationDataScreenState extends State<NotificationDataScreen> {

  late String scorerName;
  late int minute;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    decodePayload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('notification data')),
      body: Center(
        child: Text(
          "Scorer: $scorerName, $minute\"",
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  // TODO 23: format the string payload as required
  Map<String, dynamic> decodePayload(){
    String payload = ModalRoute.of(context)!.settings.arguments as String;
    Map<String, dynamic> payloadMap = jsonDecode(payload);
    Map<String, dynamic> data = jsonDecode(payloadMap['info']);
    scorerName = data['scorerName'];
    minute = data['minute'];
    return data;
  }
}