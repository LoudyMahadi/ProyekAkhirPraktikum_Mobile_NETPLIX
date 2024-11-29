import 'package:flutter/material.dart';
import '../storage/user_storage.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.black,
    appBar: PreferredSize(
      preferredSize: const Size.fromHeight(90), // Tinggi AppBar
      child: ClipPath(
        clipper: CustomAppBarClipper(),
        child: AppBar(
          title: const Text('NETPLIX'),
          foregroundColor: Colors.white,
          centerTitle: true,
          backgroundColor: Colors.red,
          elevation: 0, // Hilangkan shadow
        ),
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tambahkan logo di sini
              Image.asset(
                'assets/login.png',
                height: 280,
                width: 280,
              ),
              const SizedBox(height: 16),
              // Teks header
              Text(
                'Welcome To NETPLIX !',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              // Input Fields
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 32,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Don\'t have an account? Register',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}


  void _login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    String? storedUsername = UserStorage.getUsername();
    String? storedPassword = UserStorage.getPassword();

    if (storedUsername == username && storedPassword == password) {
       ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Login Berhasil!',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green, // Warna hijau untuk sukses
        duration: const Duration(seconds: 2), // Durasi SnackBar
      ),
    );
        Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
    } else {
      // Login gagal, tampilkan pesan kesalahan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username/Password Salah!', 
        style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.red,),
        
      );
    }
  }
}

class CustomAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30); // Mulai garis dari bawah
    path.quadraticBezierTo(
      size.width / 2, size.height, // Lengkungan di tengah
      size.width, size.height - 30, // Akhir lengkungan
    );
    path.lineTo(size.width, 0); // Garis ke atas kanan
    path.close(); // Menutup path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

