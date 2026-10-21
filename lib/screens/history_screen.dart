import 'package:flutter/material.dart';
import 'package:tiket_srimanganti/screens/e_ticket_screen.dart';
import '../models/ticket_model.dart';
import 'review_screen.dart';

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

  final List<TicketModel> allTickets = [
    TicketModel(
      location: 'Bangsal Srimanganti',
      status: 'Siap digunakan',
      isCompleted: false,
      title: 'Wayang Kulit Gagrag Ngayogyakarta',
      subtitle: 'Kamis, 24 Okt 2024 · 09.00–11.00 WIB',
      detail: '2 tiket · Kursi A-14, A-15',
      bookingCode: 'KGY-SRM-20241024-089',
      imageAsset: '', // Dikosongkan karena nanti diisi dari Beranda
      iconBgColor: const Color(0xFF0B3D2E),
    ),
    TicketModel(
      location: 'Keraton Ngayogyakarta',
      status: 'Siap digunakan',
      isCompleted: false,
      title: 'Fragmen Wayang Wong',
      subtitle: 'Sabtu, 26 Okt 2024 · 09.00–11.00 WIB',
      detail: '1 tiket',
      bookingCode: 'KGY-SRM-20241026-014',
      imageAsset: '', // Dikosongkan
      iconBgColor: const Color(0xFFB8860B),
    ),
    TicketModel(
      location: 'Keraton Ngayogyakarta',
      status: 'Selesai',
      isCompleted: true,
      title: 'Uyon-uyon & Tarian Klasik',
      subtitle: 'Selasa, 15 Okt 2024 · 10.00 WIB',
      detail: 'Tiket sudah digunakan',
      bookingCode: 'KGY-SRM-20241015-002',
      imageAsset: '', // Dikosongkan
      iconBgColor: const Color(0xFF8D6E63),
    ),
  ];

  List<TicketModel> get filteredTickets {
    return allTickets.where((ticket) {
      bool matchStatus = false;
      if (selectedFilter == 'Semua') matchStatus = true;
      else if (selectedFilter == 'Akan Datang' && !ticket.isCompleted) matchStatus = true;
      else if (selectedFilter == 'Selesai' && ticket.isCompleted) matchStatus = true;
      else if (selectedFilter == 'Dibatalkan') matchStatus = false;

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
                      const Text('Riwayat Tiket', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0B3D2E), fontFamily: 'Georgia')),
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
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]),
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
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE6D5B8))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE6D5B8))),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('Semua'),
                        _buildFilterChip('Akan Datang', badgeCount: '2'),
                        _buildFilterChip('Selesai'),
                        _buildFilterChip('Dibatalkan'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: filteredTickets.isEmpty
                  ? const Center(child: Text('Tiket tidak ditemukan.', style: TextStyle(color: Colors.grey, fontSize: 14)))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      itemCount: filteredTickets.length,
                      itemBuilder: (context, index) => _buildTicketCard(filteredTickets[index]),
                    ),
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
        decoration: BoxDecoration(color: isActive ? const Color(0xFF0B3D2E) : const Color(0xFFE6D5B8), borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Text(label, style: TextStyle(color: isActive ? Colors.white : const Color(0xFF666666), fontWeight: isActive ? FontWeight.bold : FontWeight.normal, fontSize: 12)),
            if (badgeCount != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: isActive ? Colors.white : const Color(0xFF0B3D2E), shape: BoxShape.circle),
                child: Text(badgeCount, style: TextStyle(color: isActive ? const Color(0xFF0B3D2E) : Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildTicketCard(TicketModel ticket) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(ticket.location, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: ticket.isCompleted ? const Color(0xFFEBEBEB) : const Color(0xFFE3F0E5), borderRadius: BorderRadius.circular(12)),
                child: Text(ticket.status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: ticket.isCompleted ? Colors.black54 : const Color(0xFF1E5631))),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // KOTAK GAMBAR DIGANTI JADI WARNA SOLID (TANPA GAMBAR)
              Container(
                height: 60, width: 60,
                decoration: BoxDecoration(color: ticket.iconBgColor, borderRadius: BorderRadius.circular(12)),
                child: const Center(child: Icon(Icons.theater_comedy, color: Colors.white, size: 30)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ticket.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0B3D2E), fontFamily: 'Georgia')),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('KODE BOOKING', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  Text(ticket.bookingCode, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0B3D2E))),
                ],
              ),
              if (!ticket.isCompleted)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ETicketScreen(
                          title: ticket.title,
                          date: 'OCT 21', // Sesuaikan dengan data ticket nanti
                          time: '09:00 - 11:00',
                          ticketNumber: ticket.bookingCode, // Ambil dari kode booking
                          imageAsset: 'assets/fragmen_wayang_wong_sabtu.webp', // Ganti dengan gambar yang sesuai
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B3D2E), 
                    foregroundColor: Colors.white, 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), 
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                  ),
                  child: const Text('Lihat E-Tiket', style: TextStyle(fontSize: 11)),
                )
              else
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewScreen(ticketTitle: ticket.title))),
                      style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF0B3D2E), side: const BorderSide(color: Colors.grey), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                      child: const Text('Ulasan', style: TextStyle(fontSize: 11)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B3D2E), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                      child: const Text('Pesan Lagi', style: TextStyle(fontSize: 11)),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}