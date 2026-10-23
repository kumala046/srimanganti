import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

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
      await _client
          .from('users')
          .update({'password': newPassword})
          .eq('email', email);
    } catch (e) {
      throw Exception('Gagal update password online: $e');
    }
  }

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

      if (ulasanData.isEmpty) {
        return "Belum ada ulasan untuk pagelaran ini.";
      }

      String semuaUlasan = ulasanData
          .map((u) => "- ${u['teks_ulasan']}")
          .join("\n");

      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: 'AQ.Ab8RN6JcgFFem00dYpG88j8RzNnve-UMHzGNzznLYGK7SCizig',
      );

      final prompt =
          'Berikan ringkasan singkat (maksimal 3 kalimat) dalam bahasa Indonesia yang ramah dan menarik dari ulasan penonton pagelaran "$judulPagelaran" berikut ini:\n\n$semuaUlasan';

      final response = await model.generateContent([Content.text(prompt)]);

      return response.text ?? "Gagal membuat ringkasan.";
    } catch (e) {
      return "Terjadi kesalahan saat menghubungi AI: $e";
    }
  }
}
