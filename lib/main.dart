import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/auth_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // GANTI URL DAN KEY DI BAWAH INI DENGAN PUNYAMU
  await Supabase.initialize(
    url: 'https://[URL_PROJECT_KAMU].supabase.co',
    anonKey: 'sb_publishable__oM_IvEUvWU2b_gDwHwtVA_GtZ_ZLAb',
  );

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
      home: const AuthScreen(),
    );
  }
}
