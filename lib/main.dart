import 'package:flutter/material.dart';

void main() {
  runApp(const ZenGardenApp());
}

class ZenGardenApp extends StatelessWidget {
  const ZenGardenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zen Garden',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'sans',
      ),
      home: const GardenPage(),
    );
  }
}

class GardenPage extends StatelessWidget {
  const GardenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFDABFAE),
              Color(0xFFD9C59B),
            ],
          ),
        ),
        child: const SafeArea(
          child: Center(
            child: Text(
              'Zen Garden',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w300,
                letterSpacing: 2,
                color: Color(0xFF383D39),
              ),
            ),
          ),
        ),
      ),
    );
  }
}