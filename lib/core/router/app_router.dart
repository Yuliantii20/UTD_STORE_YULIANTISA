import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Pastikan path import ini sesuai dengan struktur folder Anda
import '../../features/splash/presentation/splash_page.dart';
import '../../features/product/presentation/home_page.dart';
import '../../features/bookmark/presentation/bookmark_page.dart';
import '../../features/crypto/presentation/crypto_page.dart';

final router = GoRouter(
  // Mengarahkan ke Splash Screen sebagai titik masuk utama
  initialLocation: '/', 
  
  // Menangani error jika user mencoba mengakses route yang salah
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Halaman tidak ditemukan: ${state.error}'),
    ),
  ),

  routes: [
    // 1. Splash Screen - Menjalankan logika delay berdasarkan NIM
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    
    // 2. Home Page - Root untuk fitur utama aplikasi
    GoRoute(
      path: '/home',
      // 'const' dihapus agar tidak bentrok dengan constructor HomePage[cite: 1]
      builder: (context, state) => const HomePage(), 
      routes: [
        // Sub-route Bookmark (Akses: context.push('/home/bookmark'))[cite: 1]
        GoRoute(
          path: 'bookmark',
          builder: (context, state) => const BookmarkPage(),
        ),
        // Sub-route Crypto (Akses: context.push('/home/crypto'))[cite: 1]
        GoRoute(
          path: 'crypto',
          builder: (context, state) => const CryptoPage(),
        ),
      ],
    ),
  ],
);