// Reaktivitas: Menggunakan fungsi .watch() dari Isar untuk update UI otomatis
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../domain/bookmark_model.dart';
import '../../../../main.dart'; 

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  // Fungsi untuk menghapus bookmark (Opsional, agar aplikasi lebih lengkap)
  Future<void> deleteBookmark(int id) async {
    await isar.writeTxn(() async {
      await isar.bookmarks.delete(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9), // Warna background senada HomePage
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2196F3), Color(0xFF3F51B5)],
            ),
          ),
        ),
        title: const Text(
          "My Bookmarks Yulianti",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: StreamBuilder<List<Bookmark>>(
        // .watch() memastikan UI otomatis refresh saat isar.bookmarks.put() dipanggil di HomePage
        stream: isar.bookmarks.where().watch(fireImmediately: true),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final list = snapshot.data ?? [];
          
          if (list.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 10),
                  Text(
                    "Belum ada produk yang di-bookmark.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              
              // Format Jam & Menit
              final String timeFormatted = 
                  "${item.savedAt.hour.toString().padLeft(2, '0')}:${item.savedAt.minute.toString().padLeft(2, '0')}";

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE3F2FD),
                    child: Icon(Icons.bookmark, color: Color(0xFF1976D2)),
                  ),
                  title: Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Disimpan pukul $timeFormatted",
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Rp ${item.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                        style: const TextStyle(
                          color: Color(0xFF2E7D32), 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      // Tambahkan aksi hapus jika ditekan lama (Long Press)
                      Text("Swipe left to delete", style: TextStyle(fontSize: 8, color: Colors.grey[400])),
                    ],
                  ),
                  onLongPress: () => deleteBookmark(item.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}