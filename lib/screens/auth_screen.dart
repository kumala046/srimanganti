import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true; // Toggle antara Login dan Register
  bool isPasswordVisible = false;

  // Controller untuk form (siap digunakan untuk database & enkripsi nanti)
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController waController = TextEditingController();
  final TextEditingController konfirmasiPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- JUDUL APLIKASI ---
              const SizedBox(height: 40),
              const Text(
                'SRIMANGANTI',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                  color: Color(0xFF1A3C2F),
                  fontFamily: 'Georgia', // Fallback font Serif
                ),
              ),
              const SizedBox(height: 40),

              // --- TOGGLE LOGIN / REGISTER ---
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isLogin = true),
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: isLogin ? const Color(0xFF1A3C2F) : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: isLogin ? Colors.white : Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isLogin = false),
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: !isLogin ? const Color(0xFF1A3C2F) : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Register',
                            style: TextStyle(
                              color: !isLogin ? Colors.white : Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // --- FORM AREA ---
              if (isLogin) _buildLoginForm() else _buildRegisterForm(),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // WIDGET FORM LOGIN
  // ==========================================
  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Email'),
        _buildTextField(
          controller: emailController,
          hint: '',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        _buildLabel('Password'),
        _buildTextField(
          controller: passwordController,
          hint: '',
          isPassword: true,
        ),
        const SizedBox(height: 40),

        // Tombol Biometric & Login
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tombol Biometric (Fingerprint)
            GestureDetector(
              onTap: () {
                // TODO: Implementasi package local_auth untuk sensor sidik jari
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur Biometric akan diimplementasikan')),
                );
              },
              child: Container(
                height: 55,
                width: 55,
                decoration: const BoxDecoration(
                  color: Color(0xFF1A3C2F),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.fingerprint, color: Colors.white, size: 30),
              ),
            ),
            const SizedBox(width: 16),
            // Tombol Login
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implementasi Login Enkripsi + Session (SharedPreferences)
                  // TODO: Terhubung ke API/Database Online
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A3C2F),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text('Login', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
        // Tombol Google dihapus dari sini
      ],
    );
  }

  // ==========================================
  // WIDGET FORM REGISTER (TANPA WNI/WNA & GOOGLE)
  // ==========================================
  Widget _buildRegisterForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Nama Lengkap'),
        _buildTextField(controller: namaController, hint: ''),
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

        // Tombol Register
        Center(
          child: ElevatedButton(
            onPressed: () {
              // TODO: Proses registrasi (Hashing Password, simpan ke SQLite/API)
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A3C2F),
              foregroundColor: Colors.white,
              minimumSize: const Size(200, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text('Register', style: TextStyle(fontSize: 16)),
          ),
        ),
        // Tombol Google dihapus dari sini
      ],
    );
  }

  // ==========================================
  // HELPER WIDGET (Untuk konsistensi UI)
  // ==========================================
  
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A3C2F),
        ),
      ),
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
        fillColor: const Color(0xFFF7F5F0), // Cream
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.black87, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.black87, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFF1A3C2F), width: 2.0),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black54,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              )
            : null,
      ),
    );
  }
}