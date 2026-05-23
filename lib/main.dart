// ফাইল: lib/main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:willko_user/app/modules/home/home_view.dart';

void main() {
  // 🔥 লোডিং স্পিড সুপার ফাস্ট এবং ইঞ্জিন বাইন্ডিং অপ্টিমাইজ করার জন্য এটি বাধ্যতামূলক
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // 🔥 SEO Friendly Title: হাই-সার্চ ভলিউম কিওয়ার্ড যুক্ত করা হয়েছে যাতে সার্চে সহজে আসে
      title: 'Willko Service - Best Home, Cleaning & Professional Services Partner',
      debugShowCheckedModeBanner: false,

      // ১. লাইট থিম (ডিফল্ট)
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),

      // ২. ডার্ক থিম
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF121212), // ডার্ক ব্যাকগ্রাউন্ড
        appBarTheme: const AppBarTheme(
          backgroundColor: const Color(0xFF1F1F1F),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),

      // ৩. ডিফল্ট মোড
      themeMode: ThemeMode.light,

      // হোম স্ক্রিন
      home: const HomeView(),
    );
  }
}