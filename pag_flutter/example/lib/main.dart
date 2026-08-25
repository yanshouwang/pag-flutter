import 'dart:async';

import 'package:flutter/material.dart';

import 'package:pag_flutter/pag_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final PAGController controller;

  @override
  void initState() {
    super.initState();
    controller = PAGController.asset(
      'assets/logo.pag',
      scaleMode: .letterBox,
      repeatCount: 0,
      progress: 0.0,
    )..play();

    Timer.periodic(Durations.extralong4, (_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: PAGWidget(controller: controller)),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
