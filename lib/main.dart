import 'package:flutter/material.dart';

import 'garden/garden_page.dart';

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
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: const GardenPage(),
    );
  }
}