import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/auth_screen.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ekyzvgrqmcthugakpvgy.supabase.co',
    anonKey: 'sb_publishable__oM_IvEUvWU2b_gDwHwtVA_GtZ_ZLAb',
  );

  await NotificationService.init(); // TAMBAHAN

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
