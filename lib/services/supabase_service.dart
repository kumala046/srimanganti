import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  // Mendapatkan instance client Supabase
  final SupabaseClient _client = Supabase.instance.client;

  // ==========================================
  // FUNGSI UNTUK USER (AUTH & PROFIL)
  // ==========================================

  // 1. Simpan User Baru saat Register
  Future<void> createUser({
    required String email,
    required String nama,
    required String noWa,
    required String kewarganegaraan,
  }) async {
    try {
      await _client.from('users').insert({
        'email': email,
        'nama_lengkap': nama,
        'no_whatsapp': noWa,
        'kewarganegaraan': kewarganegaraan,
      });
    } catch (e) {
      throw Exception('Gagal menyimpan user: $e');
    }
  }

  // 2. Ambil Data User berdasarkan Email
  Future<Map<String, dynamic>?> getUserProfile(String email) async {
    final response = await _client
        .from('users')
        .select()
        .eq('email', email)
        .maybeSingle();
    return response;
  }

  // ==========================================
  // FUNGSI UNTUK PAGELARAN (EVENT)
  // ==========================================

  // 3. Ambil Semua Pagelaran
  Future<List<Map<String, dynamic>>> getPagelaran() async {
    try {
      final response = await _client.from('pagelaran').select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Gagal memuat pagelaran: $e');
    }
  }

  // ==========================================
  // FUNGSI UNTUK TIKET
  // ==========================================

  // 4. Simpan Tiket Baru (Disesuaikan dengan checkout_screen)
  Future<void> createTiket({
    required String userEmail,
    required String judulPagelaran,
    required String kodeBooking,
    required int jumlahTiket,
    required int totalHarga,
  }) async {
    try {
      await _client.from('tiket').insert({
        'user_email': userEmail,
        'judul_pagelaran': judulPagelaran,
        'kode_booking': kodeBooking,
        'jumlah_tiket': jumlahTiket,
        'total_harga': totalHarga,
        'status': 'Aktif',
      });
    } catch (e) {
      throw Exception('Gagal menyimpan tiket: $e');
    }
  }

  // 5. Ambil Riwayat Tiket milik User
  Future<List<Map<String, dynamic>>> getHistoryTiket(String email) async {
    try {
      final response = await _client
          .from('tiket')
          .select()
          .eq('user_email', email)
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Gagal memuat riwayat tiket: $e');
    }
  }
}
