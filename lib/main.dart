import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'auth_pages.dart';
import 'upload_page.dart';
import 'weather_screen.dart'; // Import the WeatherScreen
import 'google_calendar_screen.dart'; // Import your Google Calendar screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase initialization error: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wearwise App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthPage(), // Ensure AuthPage exists and is correctly implemented
      routes: {
        '/auth': (context) => const AuthPage(), // Corrected route definition
        '/upload': (context) => const UploadPage(),
        '/weather': (context) => WeatherScreen(),
        '/calendar': (context) => const GoogleCalendarScreen(),
      },
    );
  }
}
