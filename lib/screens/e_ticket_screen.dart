import 'package:flutter/material.dart';

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
      backgroundColor: const Color(0xFFFDF8F0), // Warna background cream
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
                // BAGIAN ATAS: GAMBAR
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
                // BAGIAN BAWAH: DETAIL TIKET & LUBANG TIKET
                // ==========================================
                Stack(
                  children: [
                    // Background Hijau Gelap
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(24, 30, 24, 30),
                      decoration: const BoxDecoration(
                        color: Color(0xFF153D1F), // Hijau gelap sesuai gambar
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        children: [
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
                          Text(
                            ticketNumber,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                            ),
                          ),
                        ],
                      ),
                    ),

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

  // Widget untuk teks info (Tanggal / Waktu)
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

  // Widget untuk membuat efek lubang tiket
  Widget _buildTicketHole() {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: const Color(0xFFFDF8F0), // Samakan dengan warna background Scaffold
        shape: BoxShape.circle,
      ),
    );
  }
}