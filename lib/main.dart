import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/modules/home/home_view.dart'; // আপনার হোম পেজ ইমপোর্ট করুন

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Urban Service',
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

      // ২. ডার্ক থিম (এটি না থাকলে থিম চেঞ্জ হবে না)
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF121212), // ডার্ক ব্যাকগ্রাউন্ড
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // টেক্সট এবং আইকন কালার অটোমেটিক এডজাস্ট হবে
      ),

      // ৩. ডিফল্ট মোড
      themeMode: ThemeMode.light,

      // আপনার হোম বা স্প্ল্যাশ স্ক্রিন
      home: const HomeView(),
    );
  }
}