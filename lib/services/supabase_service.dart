import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // ==========================================
  // FUNGSI UNTUK USER (AUTH & PROFIL)
  // ==========================================

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

  Future<Map<String, dynamic>?> getUserProfile(String email) async {
    final response = await _client
        .from('users')
        .select()
        .eq('email', email)
        .maybeSingle();
    return response;
  }

  // FUNGSI BARU: Update Profil ke Supabase
  Future<void> updateProfile({
    required String email,
    required String nama,
    required String noWa,
  }) async {
    try {
      await _client.from('users').update({
        'nama_lengkap': nama,
        'no_whatsapp': noWa,
      }).eq('email', email);
    } catch (e) {
      throw Exception('Gagal update profil online: $e');
    }
  }

  // FUNGSI BARU: Update Password ke Supabase
  Future<void> updatePassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      await _client.from('users').update({
        'password': newPassword, // Pastikan kolom password ada di tabel users Supabase
      }).eq('email', email);
    } catch (e) {
      throw Exception('Gagal update password online: $e');
    }
  }

  // ==========================================
  // FUNGSI UNTUK PAGELARAN (EVENT)
  // ==========================================
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