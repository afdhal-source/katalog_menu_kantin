
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Katalog Menu Kantin',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MenuPage(),
    );
  }
}

class Menu {
  final int id;
  final String nama;
  final int harga;
  final String kategori;
  final String deskripsi;

  Menu({
    required this.id,
    required this.nama,
    required this.harga,
    required this.kategori,
    required this.deskripsi,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'],
      nama: json['nama'],
      harga: json['harga'],
      kategori: json['kategori'],
      deskripsi: json['deskripsi'],
    );
  }
}

Future<List<Menu>> bacaMenu() async {
  final String data =
      await rootBundle.loadString('assets/menu.json');

  final List hasil = jsonDecode(data);

  return hasil.map((item) => Menu.fromJson(item)).toList();
}

String rupiah(int harga) {
  return 'Rp${harga.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => '.',
  )}';
}

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Katalog Menu Kantin',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<Menu>>(
        future: bacaMenu(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Data menu gagal dimuat'),
            );
          }

          final daftarMenu = snapshot.data!;

          return ListView.builder(
            itemCount: daftarMenu.length,
            padding: const EdgeInsets.all(10),
            itemBuilder: (context, index) {
              final menu = daftarMenu[index];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(
                    menu.nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text('Kategori: ${menu.kategori}'),
                      Text(
                        rupiah(menu.harga),
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailPage(menu: menu),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Menu menu;

  const DetailPage({
    super.key,
    required this.menu,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Menu'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Icon(
                    Icons.restaurant_menu,
                    size: 80,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  menu.nama,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                Text('ID: ${menu.id}'),
                const SizedBox(height: 10),
                Text('Kategori: ${menu.kategori}'),
                const SizedBox(height: 10),
                Text(
                  'Harga: ${rupiah(menu.harga)}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Deskripsi:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(menu.deskripsi),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
