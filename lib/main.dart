import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/auth_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'services/db_helper.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // URL dan Key Supabase milikmu
  await Supabase.initialize(
    url: 'https://ekyzvgrqmcthugakpvgy.supabase.co',
    anonKey: 'sb_publishable__oM_IvEUvWU2b_gDwHwtVA_GtZ_ZLAb',
  );

  // Inisialisasi Notifikasi Lokal
  await NotificationService.init(); 

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
    await Future.delayed(const Duration(milliseconds: 800));

    final email = await DBHelper().getSesi();
    final prefs = await SharedPreferences.getInstance();
    bool isBioEnabled = prefs.getBool('biometric_enabled') ?? false;

    if (email != null && email.isNotEmpty) {
      // JIKA SESI ADA DAN BIOMETRIK AKTIF
      if (isBioEnabled) {
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
      ),
    );
  }
}