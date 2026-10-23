import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'payment_screen.dart';
import '../services/supabase_service.dart';
import '../services/db_helper.dart';
import '../services/notification_service.dart';

class CheckoutScreen extends StatefulWidget {
  final String title;
  final int basePrice;
  final String categoryName;

  const CheckoutScreen({
    Key? key,
    required this.title,
    required this.basePrice,
    required this.categoryName,
  }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int selectedDateIndex = 1;
  int ticketCount = 1;
  final int serviceFee = 2000;
  final int maxTickets = 10;

  final List<Map<String, String>> dates = [
    {'day': 'Rabu', 'date': '22 Okt'},
    {'day': 'Rabu', 'date': '23 Okt'},
    {'day': 'Rabu', 'date': '29 Okt'},
    {'day': 'Rabu', 'date': '30 Okt'},
  ];

  int get subtotal => widget.basePrice * ticketCount;
  int get totalBayar => subtotal + serviceFee;

  String _formatRupiah(int amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  void _prosesPemesanan() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final email = await DBHelper().getSesi();
      final kodeBooking = 'KGY-SRM-${DateTime.now().millisecondsSinceEpoch}';
      
      final tglKunjungan = DateTime.now().add(const Duration(days: 7)).toIso8601String().split('T')[0];

      await SupabaseService().createTiket(
        userEmail: email ?? 'guest@srimanganti.com',
        judulPagelaran: widget.title,
        kodeBooking: kodeBooking,
        jumlahTiket: ticketCount,
        totalHarga: totalBayar,
        tanggalKunjungan: tglKunjungan,
      );

      await NotificationService.scheduleNotificationInSeconds(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title: 'Pembayaran Berhasil!',
        body: 'Tiket ${widget.title} kamu sudah aktif. Cek di menu Riwayat ya!',
        seconds: 2, 
      );

      if (!mounted) return;
      Navigator.pop(context); 

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(totalAmount: totalBayar),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal memproses tiket: $e')));
    }
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
          'Konfirmasi Pembayaran',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontFamily: 'serif',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // KARTU INFO PENTAS
            _buildCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 4,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB8862B),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PENTAS SENI KERATON',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A3C34),
                            fontFamily: 'serif',
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 12,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Bangsal Srimanganti, Keraton Yogyakarta',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // PILIH TANGGAL
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'PILIH TANGGAL KUNJUNGAN',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A3C34),
                        ),
                      ),
                      Text(
                        'Okt 2026',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFFB8862B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(dates.length, (index) {
                      bool isSelected = selectedDateIndex == index;
                      return GestureDetector(
                        onTap: () => setState(() => selectedDateIndex = index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF1A3C34)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFEADFCB)),
                          ),
                          child: Column(
                            children: [
                              Text(
                                dates[index]['day']!,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isSelected
                                      ? Colors.white70
                                      : Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                dates[index]['date']!,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF1A3C34),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Icon(Icons.circle, size: 6, color: Color(0xFF1A3C34)),
                      SizedBox(width: 6),
                      Text(
                        'Tersedia jadwal setiap hari Rabu',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // JUMLAH TIKET
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'JUMLAH TIKET',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A3C34),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.categoryName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A3C34),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${_formatRupiah(widget.basePrice)} / tiket',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFEADFCB)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 16),
                              onPressed: ticketCount > 1
                                  ? () => setState(() => ticketCount--)
                                  : null,
                            ),
                            Text(
                              '$ticketCount',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 16),
                              onPressed: ticketCount < maxTickets
                                  ? () => setState(() => ticketCount++)
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Maksimal 10 tiket per transaksi.',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // METODE PEMBAYARAN
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'METODE PEMBAYARAN',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A3C34),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F5F0),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF1A3C34),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: const Text(
                            'QRIS',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A3C34),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'QRIS',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A3C34),
                                ),
                              ),
                              Text(
                                'Bank dan e-wallet apa saja',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFF1A3C34),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // --- (BAGIAN INFO NOTIFIKASI SUDAH DIHAPUS) ---
            
            const SizedBox(height: 12),

            // RINCIAN PEMBAYARAN
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'RINCIAN PEMBAYARAN',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A3C34),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildRincianRow(
                    'Tiket ${widget.categoryName} ($ticketCount x ${_formatRupiah(widget.basePrice)})',
                    _formatRupiah(subtotal),
                  ),
                  const SizedBox(height: 8),
                  _buildRincianRow('Biaya layanan', _formatRupiah(serviceFee)),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1, color: Color(0xFFEADFCB)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Pembayaran',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A3C34),
                        ),
                      ),
                      Text(
                        _formatRupiah(totalBayar),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A3C34),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'TOTAL BAYAR',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _formatRupiah(totalBayar),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A3C34),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _prosesPemesanan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A3C34),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  children: [
                    Text(
                      'Konfirmasi & Bayar',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0E8D8)),
      ),
      child: child,
    );
  }

  Widget _buildRincianRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A3C34),
          ),
        ),
      ],
    );
  }
}