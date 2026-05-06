import 'dart:convert'; // Untuk jsonDecode
import 'package:flutter/foundation.dart'; // Untuk compute
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// Fungsi diluar class (Isolate) - Menghitung beban berat berdasarkan NIM
double calculateCryptoTax(int nimSuffix) {
  double total = 0;
  // LOGIKA PERSONAL: Iterasi berat sesuai digit NIM agar UI tidak freeze
  int limit = nimSuffix * 1000000; 
  for (int i = 0; i < limit; i++) {
    total += i;
  }
  return total;
}

class CryptoPage extends StatefulWidget {
  const CryptoPage({super.key});

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  // WebSocket Coincap untuk Bitcoin
  final _channel = WebSocketChannel.connect(
    Uri.parse('wss://ws.coincap.io/prices?assets=bitcoin'),
  );

  bool _isCalculating = false;

  void _runTaxCalculation() async {
    setState(() => _isCalculating = true);
    
    // Gunakan 2 digit NIM terakhir Anda (Contoh: 24)
    const int myNimSuffix = 24; 
    final result = await compute(calculateCryptoTax, myNimSuffix);

    if (!mounted) return;
    setState(() => _isCalculating = false);

    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text("Isolate Success"),
        content: Text("Hasil Kalkulasi Pajak (NIM 20123059): \n$result"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text("OK"))
        ],
      ),
    );
  }

  @override
  void dispose() {
    _channel.sink.close(); // Tutup koneksi saat halaman ditinggalkan
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.orange, Colors.deepOrange]),
          ),
        ),
        title: const Text("Crypto Hub Yulianti", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.currency_bitcoin, size: 100, color: Colors.orange),
              const SizedBox(height: 20),
              const Text("Bitcoin (BTC) Price", style: TextStyle(fontSize: 18, color: Colors.grey)),
              
              // Perbaikan: Parsing data JSON dari WebSocket
              StreamBuilder(
                stream: _channel.stream,
                builder: (context, snapshot) {
                  String price = "Connecting...";
                  if (snapshot.hasData) {
                    try {
                      final data = jsonDecode(snapshot.data.toString());
                      price = "\$ ${double.parse(data['bitcoin']).toStringAsFixed(2)}";
                    } catch (e) {
                      price = "Format Error";
                    }
                  }
                  return Text(
                    price,
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black87),
                  );
                },
              ),
              
              const SizedBox(height: 40),
              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    const Text(
                      "Isolate Computation",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Menghitung beban kalkulasi berat di thread terpisah agar UI tetap responsif.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    _isCalculating 
                      ? const CircularProgressIndicator(color: Colors.orange) 
                      : ElevatedButton.icon(
                          onPressed: _runTaxCalculation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          icon: const Icon(Icons.calculate),
                          label: const Text("Jalankan Isolate NIM"),
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}