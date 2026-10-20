import 'package:flutter/material.dart';
import 'minigame_screen.dart';

class BerandaScreen extends StatelessWidget {
  const BerandaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              color: const Color(0xFF0B3D2E),
              child: Row(
                children: [
                  // LOGO BARU
                  Image.asset(
                    'assets/logo.png', 
                    width: 40, 
                    height: 40, 
                    // PERBAIKAN: Icons.image (bukan imag)
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('KERATON NGAYOGYAKARTA', style: TextStyle(color: Color(0xFFE6D5B8), fontSize: 10, letterSpacing: 1)),
                      Text('Beranda', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Serif')),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MinigameScreen())),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF1E5631), Color(0xFF0B3D2E)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.gamepad, color: Color(0xFFE6D5B8), size: 16),
                              SizedBox(width: 8),
                              Text('MINI GAMES BUDAYA', style: TextStyle(color: Color(0xFFE6D5B8), fontSize: 10, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text('Memory Card', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Serif')),
                          const SizedBox(height: 8),
                          const Text('Asah daya ingatmu lewat kecocokan gambar wayang, batik, dan gamelan.', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(color: const Color(0xFFE6D5B8), borderRadius: BorderRadius.circular(20)),
                            child: const Text('Mainkan ▶', style: TextStyle(color: Color(0xFF0B3D2E), fontWeight: FontWeight.bold, fontSize: 12)),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}