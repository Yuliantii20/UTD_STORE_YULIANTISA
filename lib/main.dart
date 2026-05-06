// Project ETS - Yulianti
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

// Import router dan model yang benar
import 'core/router/app_router.dart';
import 'features/bookmark/domain/bookmark_model.dart';

// Global instance agar bisa diakses di seluruh layer presentation
late Isar isar;

void main() async {
  // Wajib untuk plugin native seperti path_provider agar tidak error saat start
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final dir = await getApplicationDocumentsDirectory();

    // Inisialisasi Isar dengan schema Bookmark
    isar = await Isar.open(
      [BookmarkSchema],
      directory: dir.path,
    );

    runApp(const MyApp());
  } catch (e) {
    // Menambahkan penanganan error sederhana agar aplikasi tidak stuck hitam jika database gagal
    debugPrint("Gagal menginisialisasi Isar: $e");
    runApp(
      MaterialApp(
        home: Scaffold(body: Center(child: Text("Fatal Error: Database cannot open"))),
      ),
    );
  }
}
// Arsitektur: Clean Architecture dengan GoRouter & GetIt
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'UTD Store Yulianti', // Menambahkan judul aplikasi
      debugShowCheckedModeBanner: false,
      // Menambahkan tema Material 3 agar UI otomatis terlihat lebih modern
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue, 
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      // Menggunakan routerConfig dari app_router.dart Anda
      routerConfig: router, 
    );
  }
}