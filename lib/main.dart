
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StockFacile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('StockFacile'),
        ),
        body: const Center(
          child: Text('Bienvenue dans StockFacile'),
        ),
      ),
    );
  }
}
