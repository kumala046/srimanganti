import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class PaymentScreen extends StatefulWidget {
  final int totalAmount;

  const PaymentScreen({Key? key, required this.totalAmount}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Timer _timer;
  int _secondsRemaining = 15 * 60; // 15 menit dalam detik

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer.cancel();
        // Handle waktu habis di sini
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _formattedTime {
    int minutes = _secondsRemaining ~/ 60;
    int seconds = _secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatRupiah(int amount) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDF8F0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pembayaran',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'serif'),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // --- TOTAL PEMBAYARAN ---
            const Text('Total pembayaran', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(
              _formatRupiah(widget.totalAmount),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1A3C34)),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF6E8C7), // Warna krem agak gelap
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Selesaikan dalam $_formattedTime',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFB8862B)),
              ),
            ),
            const SizedBox(height: 24),

            // --- KOTAK QR CODE ---
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  // Gambar QR Code (Placeholder)
                  // Kamu bisa mengganti Container ini dengan Image.asset('assets/qris_placeholder.png')
                  Container(
                    width: 200,
                    height: 200,
                    color: Colors.white,
                    child: const Icon(Icons.qr_code_2, size: 200, color: Color(0xFF1A3C34)),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Kode contoh - NMID [NOMOR NMID]',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- TOMBOL SIMPAN QR ---
            OutlinedButton.icon(
              onPressed: () {
                // TODO: Implementasi simpan gambar QR (perlu package tambahan)
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fitur simpan QR Code segera hadir')));
              },
              icon: const Icon(Icons.download, color: Color(0xFF1A3C34)),
              label: const Text('Simpan Kode QRIS', style: TextStyle(color: Color(0xFF1A3C34), fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: Color(0xFF1A3C34)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 32),

            // --- CARA MEMBAYAR ---
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Cara membayar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A3C34))),
            ),
            const SizedBox(height: 12),
            _buildInstruction(1, 'Buka aplikasi bank atau e-wallet yang mendukung QRIS.'),
            _buildInstruction(2, 'Pindai kode di atas dan cek nominalnya.'),
            _buildInstruction(3, 'E-tiket dikirim ke WhatsApp dan email setelah pembayaran berhasil.'),

            const SizedBox(height: 40),

            // --- TOMBOL CEK STATUS ---
            ElevatedButton(
              onPressed: () {
                // TODO: Logika cek status pembayaran ke backend
                // Simulasi berhasil:
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Pembayaran Berhasil'),
                    content: const Text('E-Ticket telah dikirim ke WhatsApp dan Email Anda.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        child: const Text('OK'),
                      )
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A3C34),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Cek Status Pembayaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInstruction(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$number. ', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey, height: 1.5)),
          ),
        ],
      ),
    );
  }
}