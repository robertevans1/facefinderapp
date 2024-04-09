import 'package:flutter/material.dart';

import 'home/ui/home_page.dart';

void main() {
  runApp(const FaceFinderApp());
}

class FaceFinderApp extends StatelessWidget {
  const FaceFinderApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
