import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
<<<<<<< HEAD
import 'package:shared_preferences/shared_preferences.dart'; // Tambahan

import 'screens/auth_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'services/db_helper.dart';
=======

import 'screens/auth_screen.dart';
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
<<<<<<< HEAD
  
  // GANTI URL DAN KEY DI BAWAH INI DENGAN PUNYAMU
=======
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8
  await Supabase.initialize(
    url: 'https://ekyzvgrqmcthugakpvgy.supabase.co',
    anonKey: 'sb_publishable__oM_IvEUvWU2b_gDwHwtVA_GtZ_ZLAb',
  );

<<<<<<< HEAD
  await NotificationService.init(); 
=======
  await NotificationService.init(); // TAMBAHAN
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Srimanganti App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7F5F0),
        primaryColor: const Color(0xFF1A3C2F),
        fontFamily: 'serif',
<<<<<<< HEAD
      ),
      home: const SplashScreen(), // Mulai dari Splash Screen
    );
  }
}

// ==========================================
// SPLASH SCREEN (CEK SESI & BIOMETRIK)
// ==========================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    // Tunggu sebentar agar splash screen terlihat
    await Future.delayed(const Duration(milliseconds: 500));

    final email = await DBHelper().getSesi();
    final prefs = await SharedPreferences.getInstance();
    bool isBioEnabled = prefs.getBool('biometric_enabled') ?? false;

    if (email != null && email.isNotEmpty) {
      // JIKA SESI ADA DAN BIOMETRIK AKTIF
      if (isBioEnabled) {
        // Arahkan ke AuthScreen dengan status "paksaBiometrik: true"
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AuthScreen(paksaBiometrik: true),
          ),
        );
      } else {
        // JIKA BIOMETRIK TIDAK AKTIF, LANGSUNG KE HOME
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
        );
      }
    } else {
      // JIKA TIDAK ADA SESI, KE HALAMAN LOGIN
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF7F5F0),
      body: Center(
        child: CircularProgressIndicator(color: Color(0xFF1A3C2F)),
=======
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8
      ),
      home: const AuthScreen(),
    );
  }
}