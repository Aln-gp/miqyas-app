import 'package:flutter/material.dart';

void main() {
  runApp(const NajdApp());
}

class NajdApp extends StatelessWidget {
  const NajdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Najd AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark, // خلفية داكنة فخمة
        primarySwatch: Colors.emerald,
        scaffoldBackgroundColor: const Color(0xff121212),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('منصة نجد AI'),
        centerTitle: true,
        backgroundColor: const Color(0xff1e1e1e),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.blur_on_rounded,
              size: 100,
              color: Colors.emeraldAccent,
            ),
            const SizedBox(height: 24),
            const Text(
              'مرحباً بك في نجد AI',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'المنصة الذكية الآمنة',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                // هنا بنربط شاشة الشات والذكاء الاصطناعي الخطوة الجاية
              },
              icon: const Icon(Icons.chat_bubble_outline),
              label: const Text('ابدأ المحادثة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.emerald,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
