import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'dart:math';
=======
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8

class ETicketScreen extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final String ticketNumber;
  final String imageAsset;

  const ETicketScreen({
    Key? key,
    required this.title,
    required this.date,
    required this.time,
    required this.ticketNumber,
    required this.imageAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      backgroundColor: const Color(0xFFFDF8F0),
=======
      backgroundColor: const Color(0xFFFDF8F0), // Warna background cream
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'E - Ticket',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontFamily: 'serif',
            fontSize: 20,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ==========================================
<<<<<<< HEAD
                // BAGIAN ATAS: GAMBAR DINAMIS
=======
                // BAGIAN ATAS: GAMBAR
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8
                // ==========================================
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  child: Image.asset(
                    imageAsset,
                    height: 320,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 320,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                      ),
                    ),
                  ),
                ),

                // ==========================================
<<<<<<< HEAD
                // BAGIAN BAWAH: DETAIL TIKET
                // ==========================================
                Stack(
                  children: [
=======
                // BAGIAN BAWAH: DETAIL TIKET & LUBANG TIKET
                // ==========================================
                Stack(
                  children: [
                    // Background Hijau Gelap
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(24, 30, 24, 30),
                      decoration: const BoxDecoration(
<<<<<<< HEAD
                        color: Color(0xFF153D1F),
=======
                        color: Color(0xFF153D1F), // Hijau gelap sesuai gambar
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        children: [
<<<<<<< HEAD
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildInfo(label: 'Tanggal', value: date, isGold: true),
                              _buildInfo(label: 'Waktu', value: time, isGold: true),
                            ],
                          ),
                          const SizedBox(height: 24),
                          
=======
                          // Info Tanggal & Waktu
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildInfo(
                                label: 'Tanggal',
                                value: date,
                                isGold: true,
                              ),
                              _buildInfo(
                                label: 'Waktu',
                                value: time,
                                isGold: true,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Nomor Tiket
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8
                          Text(
                            ticketNumber,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                            ),
                          ),
<<<<<<< HEAD
                          
                          const SizedBox(height: 16),
                          
                          // ==========================================
                          // BARCODE MANUAL
                          // ==========================================
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SizedBox(
                              height: 60,
                              width: double.infinity,
                              child: CustomPaint(
                                painter: _ManualBarcodePainter(ticketNumber),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Tunjukkan barcode ini ke petugas di pintu masuk',
                            style: TextStyle(color: Colors.white70, fontSize: 10, fontStyle: FontStyle.italic),
                          ),
=======
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8
                        ],
                      ),
                    ),

<<<<<<< HEAD
                    // Lubang Tiket
                    Positioned(top: 0, left: -15, child: _buildTicketHole()),
                    Positioned(top: 0, right: -15, child: _buildTicketHole()),

                    // Garis Putus-putus
=======
                    // Lubang Tiket Kiri
                    Positioned(
                      top: 0,
                      left: -15,
                      child: _buildTicketHole(),
                    ),

                    // Lubang Tiket Kanan
                    Positioned(
                      top: 0,
                      right: -15,
                      child: _buildTicketHole(),
                    ),

                    // Garis Putus-putus (Dashed Line)
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8
                    Positioned(
                      top: 0,
                      left: 20,
                      right: 20,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Row(
                            children: List.generate(
                              (constraints.maxWidth / 10).floor(),
                              (index) => Container(
                                width: 6,
                                height: 1,
                                margin: const EdgeInsets.only(right: 4),
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

<<<<<<< HEAD
=======
  // Widget untuk teks info (Tanggal / Waktu)
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8
  Widget _buildInfo({required String label, required String value, bool isGold = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            color: isGold ? const Color(0xFFD4B57E) : Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

<<<<<<< HEAD
=======
  // Widget untuk membuat efek lubang tiket
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8
  Widget _buildTicketHole() {
    return Container(
      width: 30,
      height: 30,
<<<<<<< HEAD
      decoration: const BoxDecoration(
        color: Color(0xFFFDF8F0),
=======
      decoration: BoxDecoration(
        color: const Color(0xFFFDF8F0), // Samakan dengan warna background Scaffold
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8
        shape: BoxShape.circle,
      ),
    );
  }
<<<<<<< HEAD
}

// ==========================================
// PAINTER BARCODE MANUAL (TANPA PACKAGE)
// ==========================================
class _ManualBarcodePainter extends CustomPainter {
  final String data;

  _ManualBarcodePainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;
    // Gunakan seed dari string agar tebal tipis garis konsisten
    final random = Random(data.hashCode);

    double currentX = 0;
    
    while (currentX < size.width) {
      // Ketebalan garis acak antara 1 - 4
      double lineWidth = random.nextDouble() * 3 + 1;
      // Jarak antar garis acak antara 1 - 3
      double gap = random.nextDouble() * 2 + 1;

      // Gambar garis hitam
      canvas.drawRect(
        Rect.fromLTWH(currentX, 0, lineWidth, size.height),
        paint,
      );

      // Geser posisi X
      currentX += lineWidth + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
=======
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8
}