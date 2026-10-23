import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_navigation_screen.dart';
import '../services/db_helper.dart';
import '../services/supabase_service.dart';

class AuthScreen extends StatefulWidget {
  final bool paksaBiometrik;

  const AuthScreen({Key? key, this.paksaBiometrik = false}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool isPasswordVisible = false;
  bool isLoading = false;
  bool _isBiometricEnabled = false; 

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController waController = TextEditingController();
  final TextEditingController konfirmasiPasswordController = TextEditingController();

  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _checkBiometricStatus();
  }

  Future<void> _checkBiometricStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool isEnabled = prefs.getBool('biometric_enabled') ?? false;
    
    if (mounted) {
      setState(() {
        _isBiometricEnabled = isEnabled;
      });
    }

    if (widget.paksaBiometrik && isEnabled) {
      _loginBiometric();
    }
  }

  // ==========================================
  // LOGIN MANUAL
  // ==========================================
  void _prosesLogin() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan Password tidak boleh kosong!'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      bool isUserValid = await SupabaseService().cekLoginOnline(email, password);

      if (isUserValid) {
        String cleanEmail = email.toLowerCase();
        await DBHelper().simpanSesi(cleanEmail);
        
        final db = await DBHelper().database;
        final existingUser = await db.query('users', where: 'email = ?', whereArgs: [cleanEmail]);
        
        if (existingUser.isEmpty) {
          await db.insert('users', {
            'email': cleanEmail,
            'password': password,
            'nama_lengkap': 'User',
            'no_whatsapp': '-',
          });
        }

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email atau Password salah!'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal Login: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // ==========================================
  // LOGIN BIOMETRIK
  // ==========================================
  Future<void> _loginBiometric() async {
    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await auth.isDeviceSupported();

      if (!canAuthenticate) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perangkat ini tidak mendukung fitur biometrik.'), backgroundColor: Colors.red),
        );
        return;
      }

      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Pindai sidik jari atau wajah Anda untuk masuk ke Srimanganti',
        options: const AuthenticationOptions(biometricOnly: true, stickyAuth: true),
      );

      if (didAuthenticate) {
        final email = await DBHelper().getSesi();

        if (email != null && email.isNotEmpty) {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
          );
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sesi tidak ditemukan. Silakan login manual terlebih dahulu.'), backgroundColor: Colors.orange),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal autentikasi: $e'), backgroundColor: Colors.red),
      );
    }
  }

  // ==========================================
  // REGISTER
  // ==========================================
  void _prosesRegister() async {
    String email = emailController.text.trim().toLowerCase();
    String password = passwordController.text.trim();
    String konfirmasi = konfirmasiPasswordController.text.trim();

    if (password != konfirmasi) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konfirmasi password tidak cocok!'), backgroundColor: Colors.red),
      );
      return;
    }

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan Password tidak boleh kosong!'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      bool isAlreadyRegistered = await SupabaseService().isEmailRegistered(email);

      if (isAlreadyRegistered) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email ini sudah terdaftar! Silakan gunakan email lain atau langsung Login.'), 
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
          )
        );
        setState(() => isLoading = false);
        return;
      }

      await SupabaseService().createUser(
        email: email,
        nama: namaController.text,
        noWa: waController.text,
        kewarganegaraan: 'WNI',
        password: password, 
      );

      final db = await DBHelper().database;
      await db.delete('users', where: 'email = ?', whereArgs: [email]);
      
      await db.insert('users', {
        'email': email,
        'password': password,
        'nama_lengkap': namaController.text,
        'no_whatsapp': waController.text,
      });

      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registrasi Berhasil! Silakan Login.'), 
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        )
      );
      
      setState(() {
        isLogin = true;
        passwordController.clear();
        konfirmasiPasswordController.clear();
      });

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal daftar: ${e.toString().replaceAll("Exception: ", "")}'), 
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        )
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                'SRIMANGANTI',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 2.0, color: Color(0xFF1A3C2F), fontFamily: 'Georgia'),
              ),
              const SizedBox(height: 40),

              Container(
                height: 50,
                decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(25)),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isLogin = true),
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(color: isLogin ? const Color(0xFF1A3C2F) : Colors.transparent, borderRadius: BorderRadius.circular(25)),
                          alignment: Alignment.center,
                          child: Text('Login', style: TextStyle(color: isLogin ? Colors.white : Colors.black54, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isLogin = false),
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(color: !isLogin ? const Color(0xFF1A3C2F) : Colors.transparent, borderRadius: BorderRadius.circular(25)),
                          alignment: Alignment.center,
                          child: Text('Register', style: TextStyle(color: !isLogin ? Colors.white : Colors.black54, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              if (isLogin) _buildLoginForm() else _buildRegisterForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Email'),
        _buildTextField(controller: emailController, hint: '', keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 16),
        _buildLabel('Password'),
        _buildTextField(controller: passwordController, hint: '', isPassword: true),
        const SizedBox(height: 40),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isBiometricEnabled) ...[
              GestureDetector(
                onTap: _loginBiometric,
                child: Container(
                  height: 55,
                  width: 55,
                  decoration: const BoxDecoration(color: Color(0xFF1A3C2F), shape: BoxShape.circle),
                  child: const Icon(Icons.fingerprint, color: Colors.white, size: 30),
                ),
              ),
              const SizedBox(width: 16),
            ],
            
            Expanded(
              child: ElevatedButton(
                onPressed: isLoading ? null : _prosesLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A3C2F),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                child: isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Login', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Nama Lengkap'),
        _buildTextField(controller: namaController, hint: ''),
        const SizedBox(height: 16),
        _buildLabel('Email'),
        _buildTextField(controller: emailController, hint: '', keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 16),
        _buildLabel('Nomor WhatsApp'),
        _buildTextField(controller: waController, hint: '', keyboardType: TextInputType.phone),
        const SizedBox(height: 16),
        _buildLabel('Password'),
        _buildTextField(controller: passwordController, hint: '', isPassword: true),
        const SizedBox(height: 16),
        _buildLabel('Konfirmasi Password'),
        _buildTextField(controller: konfirmasiPasswordController, hint: '', isPassword: true),
        const SizedBox(height: 30),

        Center(
          child: ElevatedButton(
            onPressed: isLoading ? null : _prosesRegister,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A3C2F),
              foregroundColor: Colors.white,
              minimumSize: const Size(200, 55),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            ),
            child: isLoading
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Register', style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A3C2F))),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? !isPasswordVisible : false,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF7F5F0),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.black87, width: 1.0)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.black87, width: 1.0)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Color(0xFF1A3C2F), width: 2.0)),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.black54),
                onPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
              )
            : null,
      ),
    );
  }
}