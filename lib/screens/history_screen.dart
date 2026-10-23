import 'package:flutter/material.dart';
import 'package:tiket_srimanganti/screens/e_ticket_screen.dart';
<<<<<<< HEAD
import 'package:intl/intl.dart';
import 'dart:async'; 

=======
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8
import '../models/ticket_model.dart';
import 'review_screen.dart';
import '../services/db_helper.dart';
import '../services/supabase_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String selectedFilter = 'Semua';
  String searchQuery = '';
  bool isSearchActive = false;
  final TextEditingController searchController = TextEditingController();

  List<TicketModel> allTickets = [];
  bool isLoading = true;
<<<<<<< HEAD
  String? errorMessage;
=======
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8

  @override
  void initState() {
    super.initState();
    _loadTiketDariDatabase();
  }

  Future<void> _loadTiketDariDatabase() async {
<<<<<<< HEAD
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    
    try {
      final email = await DBHelper().getSesi();
      if (email != null && email.isNotEmpty) {
        // Tambahkan batas waktu untuk LOAD DATA juga
        final data = await SupabaseService().getHistoryTiket(email)
            .timeout(const Duration(seconds: 8));
        
        setState(() {
          allTickets = data.map((item) {
            String tglFormatted = '-';
            if (item['tanggal_kunjungan'] != null) {
              try {
                DateTime parsedDate = DateTime.parse(item['tanggal_kunjungan'].toString());
                tglFormatted = DateFormat('dd MMM yyyy', 'id_ID').format(parsedDate);
              } catch (e) {
                tglFormatted = item['tanggal_kunjungan'].toString();
              }
            }
            int tiketId = 0;
            if (item['id'] != null) {
              tiketId = item['id'] is int ? item['id'] : (int.tryParse(item['id'].toString()) ?? 0);
            }

            return TicketModel(
              id: tiketId,
              location: 'Bangsal Srimanganti',
              status: item['status']?.toString() ?? 'Aktif',
              isCompleted: item['status'] == 'Selesai',
              title: item['judul_pagelaran']?.toString() ?? 'Pagelaran Keraton',
              subtitle: 'Kunjungan: $tglFormatted',
              detail: '${item['jumlah_tiket'] ?? 1} tiket',
              bookingCode: item['kode_booking']?.toString() ?? '-',
=======
    setState(() => isLoading = true);
    try {
      final email = await DBHelper().getSesi();
      if (email != null && email.isNotEmpty) {
        final data = await SupabaseService().getHistoryTiket(email);
        setState(() {
          allTickets = data.map((item) {
            return TicketModel(
              id: item['id'], // ID dari database
              location: 'Bangsal Srimanganti',
              status: item['status'] ?? 'Aktif',
              isCompleted: item['status'] == 'Selesai',
              title: item['judul_pagelaran'] ?? 'Pagelaran Keraton',
              subtitle: 'Dibeli: ${item['created_at'].toString().substring(0, 10)}',
              detail: '${item['jumlah_tiket']} tiket',
              bookingCode: item['kode_booking'] ?? '-',
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8
              imageAsset: '',
              iconBgColor: const Color(0xFF0B3D2E),
            );
          }).toList();
          isLoading = false;
        });
      } else {
<<<<<<< HEAD
        setState(() {
          isLoading = false;
          errorMessage = "Sesi login tidak ditemukan.";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Gagal memuat data. Cek koneksi internet.";
      });
    }
  }

  // ==========================================
  // FUNGSI BATALKAN TIKET (DIPERBAIKI TOTAL)
  // ==========================================
=======
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error load tiket: $e');
      setState(() => isLoading = false);
    }
  }

  // FUNGSI BATALKAN TIKET
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8
  Future<void> _batalkanTiket(TicketModel ticket) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Batalkan Tiket?', style: TextStyle(fontFamily: 'Georgia', fontWeight: FontWeight.bold)),
<<<<<<< HEAD
          content: const Text('Apakah Anda yakin ingin membatalkan tiket ini?'),
=======
          content: const Text('Apakah Anda yakin ingin membatalkan tiket ini? Dana refund akan diproses maksimal 1x24 jam.'),
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tidak', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
<<<<<<< HEAD
                Navigator.pop(context); // Tutup Dialog Konfirmasi
                
                // Tampilkan Loading
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(child: CircularProgressIndicator(color: Color(0xFF0B3D2E))),
                );

                try {
                  // PAKSA BERHENTI NUNGGU SETELAH 3 DETIK
                  await SupabaseService().updateStatusTiket(ticket.id, 'Dibatalkan')
                      .timeout(const Duration(seconds: 3));

                  // JIKA BERHASIL DALAM 3 DETIK:
                  if (!mounted) return;
                  Navigator.pop(context); // Tutup Loading
                  
                  _loadTiketDariDatabase(); // Refresh data dari server
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tiket berhasil dibatalkan.'),
                      backgroundColor: Color(0xFF0B3D2E),
                    ),
                  );
                } on TimeoutException {
                  // JIKA LEBIH DARI 3 DETIK (KONEKSI LAMBAT/MATI):
                  if (!mounted) return;
                  Navigator.pop(context); // Tutup Loading
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Gagal: Server tidak merespons (Timeout). Periksa internet emulator Anda.'),
                      backgroundColor: Colors.orange,
                      duration: Duration(seconds: 4),
                    ),
                  );
                } catch (e) {
                  // JIKA ERROR LAIN:
                  if (!mounted) return;
                  Navigator.pop(context); // Tutup Loading
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal membatalkan: ${e.toString().replaceAll("Exception: ", "")}'),
                      backgroundColor: Colors.red,
                    ),
=======
                Navigator.pop(context); // Tutup dialog
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(child: CircularProgressIndicator()),
                );
                try {
                  await SupabaseService().updateStatusTiket(ticket.id, 'Dibatalkan');
                  if (!mounted) return;
                  Navigator.pop(context);
                  _loadTiketDariDatabase();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tiket berhasil dibatalkan. Refund diproses 1x24 jam.'),
                      backgroundColor: Color(0xFF0B3D2E),
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal membatalkan tiket: $e')),
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC0392B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Ya, Batalkan'),
            ),
          ],
        );
      },
    );
  }

  List<TicketModel> get filteredTickets {
    return allTickets.where((ticket) {
      bool matchStatus = false;
      if (selectedFilter == 'Semua') {
        matchStatus = true;
<<<<<<< HEAD
      } else if (selectedFilter == 'Akan Datang' && !ticket.isCompleted && ticket.status != 'Dibatalkan') {
=======
      } else if (selectedFilter == 'Akan Datang' && !ticket.isCompleted) {
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8
        matchStatus = true;
      } else if (selectedFilter == 'Selesai' && ticket.isCompleted) {
        matchStatus = true;
      } else if (selectedFilter == 'Dibatalkan' && ticket.status == 'Dibatalkan') {
        matchStatus = true;
      }
      bool matchSearch = ticket.title.toLowerCase().contains(searchQuery.toLowerCase());
      return matchStatus && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tiket Saya',
<<<<<<< HEAD
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0B3D2E), fontFamily: 'Georgia'),
=======
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B3D2E),
                          fontFamily: 'Georgia',
                        ),
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isSearchActive = !isSearchActive;
                            if (!isSearchActive) {
                              searchQuery = '';
                              searchController.clear();
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
<<<<<<< HEAD
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]),
=======
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                            ],
                          ),
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8
                          child: const Icon(Icons.search, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                  if (isSearchActive) ...[
                    const SizedBox(height: 16),
                    TextField(
                      controller: searchController,
                      onChanged: (value) => setState(() => searchQuery = value),
                      decoration: InputDecoration(
                        hintText: 'Cari nama pentas...',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
<<<<<<< HEAD
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE6D5B8))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE6D5B8))),
=======
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE6D5B8)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE6D5B8)),
                        ),
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('Semua'),
                        _buildFilterChip(
                          'Akan Datang',
                          badgeCount: allTickets.where((t) => !t.isCompleted && t.status != 'Dibatalkan').length.toString(),
                        ),
                        _buildFilterChip('Selesai'),
                        _buildFilterChip('Dibatalkan'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
<<<<<<< HEAD
              child: RefreshIndicator(
                onRefresh: _loadTiketDariDatabase,
                color: const Color(0xFF0B3D2E),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFF0B3D2E)))
                    : errorMessage != null
                        ? ListView(children: [const SizedBox(height: 100), Center(child: Padding(padding: const EdgeInsets.all(24.0), child: Text(errorMessage!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red, fontSize: 14))))])
                        : filteredTickets.isEmpty
                            ? ListView(children: const [SizedBox(height: 100), Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.confirmation_number_outlined, size: 50, color: Colors.grey), SizedBox(height: 10), Text('Belum ada tiket.', style: TextStyle(color: Colors.grey, fontSize: 14))]))])
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                itemCount: filteredTickets.length,
                                itemBuilder: (context, index) => _buildTicketCard(filteredTickets[index]),
                              ),
              ),
=======
              child: isLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF0B3D2E)))
                  : filteredTickets.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.confirmation_number_outlined, size: 50, color: Colors.grey),
                              SizedBox(height: 10),
                              Text('Belum ada tiket.', style: TextStyle(color: Colors.grey, fontSize: 14)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          itemCount: filteredTickets.length,
                          itemBuilder: (context, index) => _buildTicketCard(filteredTickets[index]),
                        ),
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, {String? badgeCount}) {
    bool isActive = selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = label),
      child: Container(
        margin: const EdgeInsets.only(right: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF0B3D2E) : const Color(0xFFE6D5B8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
<<<<<<< HEAD
            Text(label, style: TextStyle(color: isActive ? Colors.white : const Color(0xFF666666), fontWeight: isActive ? FontWeight.bold : FontWeight.normal, fontSize: 12)),
=======
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : const Color(0xFF666666),
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8
            if (badgeCount != null && badgeCount != '0') ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.all(4),
<<<<<<< HEAD
                decoration: BoxDecoration(color: isActive ? Colors.white : const Color(0xFF0B3D2E), shape: BoxShape.circle),
                child: Text(badgeCount, style: TextStyle(color: isActive ? const Color(0xFF0B3D2E) : Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
=======
                decoration: BoxDecoration(
                  color: isActive ? Colors.white : const Color(0xFF0B3D2E),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  badgeCount,
                  style: TextStyle(
                    color: isActive ? const Color(0xFF0B3D2E) : Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTicketCard(TicketModel ticket) {
    bool isCancelled = ticket.status == 'Dibatalkan';
<<<<<<< HEAD
=======

>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isCancelled ? const Color(0xFFF5F5F5) : Colors.white,
        borderRadius: BorderRadius.circular(16),
<<<<<<< HEAD
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
=======
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
<<<<<<< HEAD
              Row(children: [const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey), const SizedBox(width: 4), Text(ticket.location, style: const TextStyle(fontSize: 12, color: Colors.grey))]),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: isCancelled ? const Color(0xFFFADBD8) : ticket.isCompleted ? const Color(0xFFEBEBEB) : const Color(0xFFE3F0E5), borderRadius: BorderRadius.circular(12)),
                child: Text(ticket.status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isCancelled ? const Color(0xFFC0392B) : ticket.isCompleted ? Colors.black54 : const Color(0xFF1E5631))),
=======
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(ticket.location, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isCancelled
                      ? const Color(0xFFFADBD8)
                      : ticket.isCompleted
                          ? const Color(0xFFEBEBEB)
                          : const Color(0xFFE3F0E5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  ticket.status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isCancelled
                        ? const Color(0xFFC0392B)
                        : ticket.isCompleted
                            ? Colors.black54
                            : const Color(0xFF1E5631),
                  ),
                ),
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
<<<<<<< HEAD
              Container(height: 60, width: 60, decoration: BoxDecoration(color: isCancelled ? Colors.grey : ticket.iconBgColor, borderRadius: BorderRadius.circular(12)), child: const Center(child: Icon(Icons.theater_comedy, color: Colors.white, size: 30))),
=======
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: isCancelled ? Colors.grey : ticket.iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: Icon(Icons.theater_comedy, color: Colors.white, size: 30)),
              ),
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
<<<<<<< HEAD
                    Text(ticket.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isCancelled ? Colors.grey : const Color(0xFF0B3D2E), fontFamily: 'Georgia')),
=======
                    Text(
                      ticket.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isCancelled ? Colors.grey : const Color(0xFF0B3D2E),
                        fontFamily: 'Georgia',
                      ),
                    ),
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8
                    const SizedBox(height: 4),
                    Text(ticket.subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF666666))),
                    const SizedBox(height: 4),
                    Text(ticket.detail, style: const TextStyle(fontSize: 12, color: Colors.black87)),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24, color: Color(0xFFF0F0F0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
<<<<<<< HEAD
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('KODE BOOKING', style: TextStyle(fontSize: 10, color: Colors.grey)), Text(ticket.bookingCode, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0B3D2E)))]),
            ],
          ),
          const SizedBox(height: 12),
          if (!isCancelled) ...[
            if (!ticket.isCompleted) 
              Row(
                mainAxisAlignment: MainAxisAlignment.end, 
                children: [
                  OutlinedButton(
                    onPressed: () => _batalkanTiket(ticket),
                    style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFC0392B), side: const BorderSide(color: Color(0xFFC0392B)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                    child: const Text('Batalkan', style: TextStyle(fontSize: 11)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      String gambarPath = 'assets/uyon_uyon_selasa.webp';
                      if (ticket.title.contains('Wayang Golek')) gambarPath = 'assets/wayang_golek_rabu.webp';
                      else if (ticket.title.contains('Wayang Kulit')) gambarPath = 'assets/wayang_kulit_kamis.webp';
                      else if (ticket.title.contains('Macapat')) gambarPath = 'assets/macapat_jumat.webp';
                      else if (ticket.title.contains('Fragmen Wayang Wong')) gambarPath = 'assets/fragmen_wayang_wong_sabtu.webp';
                      else if (ticket.title.contains('Gladhen Beksan')) gambarPath = 'assets/gladhen_beksan_minggu.webp';

                      Navigator.push(context, MaterialPageRoute(builder: (context) => ETicketScreen(title: ticket.title, date: ticket.subtitle.replaceAll('Kunjungan: ', ''), time: '09:00 - 11:00', ticketNumber: ticket.bookingCode, imageAsset: gambarPath)));
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B3D2E), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                    child: const Text('Lihat E-Tiket', style: TextStyle(fontSize: 11)),
                  ),
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewScreen(ticketTitle: ticket.title))),
                    style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF0B3D2E), side: const BorderSide(color: Colors.grey), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                    child: const Text('Ulasan', style: TextStyle(fontSize: 11)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B3D2E), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)), child: const Text('Pesan Lagi', style: TextStyle(fontSize: 11))),
                ],
              ),
          ] else ...[
            const Align(alignment: Alignment.centerRight, child: Text('Tiket telah dibatalkan', style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic))),
          ],
=======
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('KODE BOOKING', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  Text(ticket.bookingCode, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0B3D2E))),
                ],
              ),
              if (!isCancelled) ...[
                if (!ticket.isCompleted) 
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () => _batalkanTiket(ticket),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFC0392B),
                          side: const BorderSide(color: Color(0xFFC0392B)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        child: const Text('Batalkan', style: TextStyle(fontSize: 11)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ETicketScreen(
                                title: ticket.title,
                                date: 'OCT 21',
                                time: '09:00 - 11:00',
                                ticketNumber: ticket.bookingCode,
                                imageAsset: 'assets/fragmen_wayang_wong_sabtu.webp',
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0B3D2E),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: const Text('Lihat E-Tiket', style: TextStyle(fontSize: 11)),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ReviewScreen(ticketTitle: ticket.title)),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF0B3D2E),
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        child: const Text('Ulasan', style: TextStyle(fontSize: 11)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0B3D2E),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        child: const Text('Pesan Lagi', style: TextStyle(fontSize: 11)),
                      ),
                    ],
                  ),
              ] else ...[
                const Text('Tiket telah dibatalkan', style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic)),
              ],
            ],
          ),
>>>>>>> 22b384a5e38f34c0e0fbb8817f58daf742fe5fe8
        ],
      ),
    );
  }
}