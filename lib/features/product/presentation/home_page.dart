// UI: Menampilkan daftar produk menggunakan GridView atau ListView
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:go_router/go_router.dart';

import '../domain/product_model.dart'; 
import '../../bookmark/domain/bookmark_model.dart';
import '../../../main.dart'; 

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Product> products = const [
    Product(title: "Laptop ASUS ROG", price: 15000000, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTQKxY7WU1zpfQZ7F-2cyMKNRxLeiqC4ixwxg&s"),
    Product(title: "Logitech Wireless Mouse", price: 250000, image: "https://media.dinomarket.com/docs/imgTD/2016-10/pic_Logitech_M221_black2_071016101002_ll.jpg.jpg"),
    Product(title: "Mechanical Keyboard RGB", price: 850000, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTZH9bVIL4rdPvQy1U4nsXh-eXuJYhNjC08zg&s"),
    Product(title: "Monitor LED 24 Inch", price: 1200000, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQF9P4OrZt44GzG0yzM6cL5JT5RBJiFPTF19w&s"),
    Product(title: "Headset Gaming HyperX", price: 950000, image: "https://row.hyperx.com/cdn/shop/products/hyperx_cloud_alpha_blackred_1_main.jpg?v=1662420668"),
    Product(title: "Webcam Full HD 1080p", price: 450000, image: "https://kkomputer.com/16503-large_default/web-camera-full-hd-1080p-usb-20-biru.jpg"),
    Product(title: "SSD NVMe 1TB", price: 1100000, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTkeb5NRRbwtgXqoaQuyd2yfXr0X4cu4UsiXA&s"),
    Product(title: "RAM DDR4 16GB", price: 750000, image: "https://els.id/wp-content/uploads/2023/09/3b95ce84-2286-4812-842c-076c11f0b233-1.jpg"),
    Product(title: "VGA RTX 4080 Super", price: 18500000, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTHd_WC_XbPG61xPZTYyJq7X1rjD141ZVLvgw&s"),
    Product(title: "Motherboard MSI Z790", price: 4500000, image: "https://storage-asset.msi.com/global/picture/image/feature/mb/Z790/PRO-Z790-P/main-kv.png"),
    Product(title: "CPU Cooler Noctua NH-D15", price: 1600000, image: "https://down-id.img.susercontent.com/file/99fef19fd09488cfd44d964bb04c513b"),
    Product(title: "Gaming Chair Secretlab", price: 5500000, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFLZGhK2ccfqq44VmNs5-FlaqLFGZgLmgG3w&s"),
  ];


  Future<void> saveBookmark(Product product) async {
    final data = Bookmark()
      ..title = product.title
      ..price = product.price
      ..savedAt = DateTime.now(); 

    await isar.writeTxn(() async {
      await isar.bookmarks.put(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2196F3), Color(0xFF3F51B5)],
            ),
          ),
        ),
        title: const Text("UTD Store Yulianti", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () => context.push('/home/crypto'),
            icon: const Icon(Icons.currency_bitcoin, color: Colors.white),
          ),
          IconButton(
            onPressed: () => context.push('/home/bookmark'),
            icon: const Icon(Icons.bookmark, color: Colors.white),
          ),
        ],
      ),
      // MENGGUNAKAN COLUMN + EXPANDED UNTUK MEMASTIKAN SCROLL BERJALAN
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              // Physics ini sangat penting agar scroll terdeteksi di emulator
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.all(12),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final item = products[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        item.image ?? "https://via.placeholder.com/150",
                        width: 55, height: 55, fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Rp ${item.price}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.bookmark_add, color: Colors.blue),
                      onPressed: () => saveBookmark(item),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}