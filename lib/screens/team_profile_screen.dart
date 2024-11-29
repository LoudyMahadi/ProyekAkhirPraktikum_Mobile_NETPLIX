import 'package:flutter/material.dart';
import 'package:themoviedbapp/screens/login_screen.dart';

class TeamProfileScreen extends StatelessWidget {
  const TeamProfileScreen({Key? key}) : super(key: key);

  // Fungsi logout
  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  // Menampilkan dialog profil fullscreen
  void _showProfilePopup(
      BuildContext context, String name, String nim, String kelas, String imagePath) {
    showDialog(
      context: context,
      barrierDismissible: true, // Klik di luar popup untuk menutup
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10), // Menghilangkan padding dialog
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Foto profil yang bisa dipencet
                GestureDetector(
                  onTap: () {
                    _showImageFullscreen(context, imagePath); // Panggil fungsi untuk fullscreen
                  },
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage(imagePath),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Nama : $name',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'NIM : $nim',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Kelas : $kelas',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),
                // Tombol Tutup
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                  ),
                  child: const Text(
                    'Tutup',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Menampilkan gambar fullscreen
  void _showImageFullscreen(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: EdgeInsets.zero, // Fullscreen tanpa padding
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop(); // Tutup dialog saat gambar ditekan
            },
            child: Container(
              color: Colors.black,
              child: Center(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain, // Gambar tidak terpotong
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Meet the Team!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Aplikasi ini dibuat dengan sepenuh hati oleh dua programmer dibawah, dengan cita rasa dadakan yang sangat khas dan dengan bumbu seadanya, aplikasi "NETPLIX" ini lahir seperti yang kita bisa lihat sekarang, Terimakasih',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 30),

            // Card untuk Anggota Tim 1
            GestureDetector(
              onTap: () {
                _showProfilePopup(context, "Satrio Adi Saputro", "124220073", "SI-D",
                    'assets/satrio.png');
              },
              child: _buildTeamCard("Satrio Adi Saputro", "124220073", "SI-D", 'assets/satrio.png'),
            ),
            const SizedBox(height: 20),

            // Card untuk Anggota Tim 2
            GestureDetector(
              onTap: () {
                _showProfilePopup(context, "Loudy Surya C.M", "124220122", "SI-D",
                    'assets/loudy.jpg');
              },
              child: _buildTeamCard("Loudy Surya C.M", "124220122", "SI-D", 'assets/loudy.jpg'),
            ),
            const SizedBox(height: 30),

            // Tombol Logout
            ElevatedButton(
              onPressed: () {
                _logout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamCard(String name, String nim, String kelas, String imagePath) {
    return Card(
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(imagePath),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Nama : $name',
              style: const TextStyle(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'NIM : $nim',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Kelas : $kelas',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
