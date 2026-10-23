import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'hash_helper.dart'; // IMPORT HASH HELPER

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // ==========================================
  // FUNGSI AUTH (DENGAN HASH)
  // ==========================================
  
  // 1. Fungsi untuk mengecek apakah email sudah terdaftar (Online)
  Future<bool> isEmailRegistered(String email) async {
    try {
      String cleanEmail = email.trim().toLowerCase();
      final response = await _client
          .from('users')
          .select('email')
          .eq('email', cleanEmail)
          .maybeSingle();
      
      return response != null; // True jika email sudah ada
    } catch (e) {
      throw Exception('Gagal memeriksa email: $e');
    }
  }

  // 2. Fungsi untuk mendaftarkan user baru
  Future<void> createUser({
    required String email,
    required String nama,
    required String noWa,
    required String kewarganegaraan,
    required String password,
  }) async {
    try {
      // HASH PASSWORD SEBELUM DISIMPAN
      String hashedPassword = HashHelper.hashPassword(password);

      await _client.from('users').insert({
        'email': email.trim().toLowerCase(),
        'nama_lengkap': nama,
        'no_whatsapp': noWa,
        'kewarganegaraan': kewarganegaraan,
        'password': hashedPassword, // SIMPAN YANG SUDAH DI-HASH
      });
    } catch (e) {
      throw Exception('Gagal menyimpan user: $e');
    }
  }

  // 3. Fungsi untuk cek login (Online)
  Future<bool> cekLoginOnline(String email, String password) async {
    try {
      String cleanEmail = email.trim().toLowerCase();
      // HASH PASSWORD YANG DIKETIK USER
      String hashedPassword = HashHelper.hashPassword(password.trim());

      // Cari user berdasarkan email
      final response = await _client
          .from('users')
          .select()
          .eq('email', cleanEmail)
          .maybeSingle();

      if (response == null) {
        print("LOGIN GAGAL: Email '$cleanEmail' TIDAK DITEMUKAN di database.");
        return false;
      }

      // Cocokkan hash password di database dengan hash dari input user
      String dbPassword = response['password']?.toString() ?? '';
      
      if (dbPassword == hashedPassword) {
        print("LOGIN SUKSES: Password cocok.");
        return true;
      } else {
        print("LOGIN GAGAL: Password tidak cocok.");
        return false;
      }
    } catch (e) {
      throw Exception('Gagal cek login online: $e');
    }
  }

  // ==========================================
  // FUNGSI PROFIL
  // ==========================================
  Future<Map<String, dynamic>?> getUserProfile(String email) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('email', email)
          .maybeSingle();
      return response;
    } catch (e) {
      throw Exception('Gagal mengambil profil: $e');
    }
  }

  Future<void> updateProfile({
    required String email,
    required String nama,
    required String noWa,
  }) async {
    try {
      await _client
          .from('users')
          .update({'nama_lengkap': nama, 'no_whatsapp': noWa})
          .eq('email', email);
    } catch (e) {
      throw Exception('Gagal update profil online: $e');
    }
  }

  Future<void> updatePassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      // HASH PASSWORD BARU SEBELUM DISIMPAN
      String hashedPassword = HashHelper.hashPassword(newPassword);
      
      await _client
          .from('users')
          .update({'password': hashedPassword})
          .eq('email', email);
    } catch (e) {
      throw Exception('Gagal update password online: $e');
    }
  }

  // ==========================================
  // FUNGSI PAGELARAN, TIKET, ULASAN, AI
  // ==========================================
  Future<List<Map<String, dynamic>>> getPagelaran() async {
    try {
      final response = await _client.from('pagelaran').select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Gagal memuat pagelaran: $e');
    }
  }

  Future<void> createTiket({
    required String userEmail,
    required String judulPagelaran,
    required String kodeBooking,
    required int jumlahTiket,
    required int totalHarga,
    required String tanggalKunjungan, 
  }) async {
    try {
      await _client.from('tiket').insert({
        'user_email': userEmail,
        'judul_pagelaran': judulPagelaran, 
        'kode_booking': kodeBooking,
        'jumlah_tiket': jumlahTiket,
        'total_harga': totalHarga,
        'status': 'Aktif',
        'tanggal_kunjungan': tanggalKunjungan, 
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

  Future<void> updateStatusTiket(int idTiket, String statusBaru) async {
    try {
      await _client
          .from('tiket')
          .update({'status': statusBaru})
          .eq('id', idTiket);
    } catch (e) {
      throw Exception('Gagal update status tiket: $e');
    }
  }

  Future<void> createUlasan({
    required String userEmail,
    required String judulPagelaran,
    required int rating,
    required String teksUlasan,
    required List<String> tags,
  }) async {
    try {
      await _client.from('ulasan').insert({
        'user_email': userEmail,
        'judul_pagelaran': judulPagelaran,
        'rating': rating,
        'teks_ulasan': teksUlasan,
        'tags': tags.join(', '),
      });
    } catch (e) {
      throw Exception('Gagal menyimpan ulasan: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getUlasan(String judulPagelaran) async {
    try {
      final response = await _client
          .from('ulasan')
          .select()
          .eq('judul_pagelaran', judulPagelaran)
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Gagal memuat ulasan: $e');
    }
  }

  Future<String> generateRingkasanAI(String judulPagelaran) async {
    try {
      final ulasanData = await getUlasan(judulPagelaran);
      if (ulasanData.isEmpty) return "Belum ada ulasan untuk pagelaran ini.";

      String semuaUlasan = ulasanData.map((u) => "- ${u['teks_ulasan']}").join("\n");

      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: '',
      );

      final prompt = 'Berikan ringkasan singkat (maksimal 3 kalimat) dalam bahasa Indonesia yang ramah dan menarik dari ulasan penonton pagelaran "$judulPagelaran" berikut ini:\n\n$semuaUlasan';

      final response = await model.generateContent([Content.text(prompt)]);

      return response.text ?? "Gagal membuat ringkasan.";
    } catch (e) {
      return "Terjadi kesalahan saat menghubungi AI: $e";
    }
  }
}