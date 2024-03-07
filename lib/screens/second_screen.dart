import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {

  static const String route = "/second";

  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('second')),
      body: const Center(child: Text('this is the second screen'),),
    );
  }
}
