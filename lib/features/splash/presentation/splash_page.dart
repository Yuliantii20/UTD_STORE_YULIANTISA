// Implementasi delay splash screen sesuai digit terakhir NIM (4 detik)
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  Future<void> _startDelay() async {
    // LOGIKA PERSONAL: X detik berdasarkan digit terakhir NIM (Misal NIM akhir 4)
    // Sesuai aturan: Jika 0 maka 5 detik
    const int nimTerakhir = 4; 
    const int delay = nimTerakhir == 0 ? 5 : nimTerakhir;

    await Future.delayed(const Duration(seconds: delay));
    if (mounted) context.go('/home'); // Menggunakan go_router
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("UTD STORE YULIANTI", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("NIM: 20123059"), // Ganti dengan NIM asli Anda
          ],
        ),
      ),
    );
  }
}