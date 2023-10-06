import 'dart:convert';
import 'dart:io';

import 'package:crud_flutter/list_data.dart';
import 'package:crud_flutter/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TambahData extends StatefulWidget {
  const TambahData({super.key});
  @override
  State<TambahData> createState() => _TambahDataState();
}

class _TambahDataState extends State<TambahData> {
  final nama_resepController = TextEditingController();
  final bahanController = TextEditingController();
  final cara_membuatController = TextEditingController();

  Future postData(String nama_resep, String bahan, String cara_membuat) async {
    String url = 'http://localhost/UTS_Mobile/index.php';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String jsonBody = '{"nama resep": "$nama_resep", "bahan": "$bahan", "cara membuat": "$cara_membuat"}';
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Resep'),
      ),
      drawer: const SideMenu(),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: TextField(
              controller: nama_resepController,
              decoration: InputDecoration(
                  labelText: 'Nama Resep',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: TextField(
              controller: bahanController,
              decoration: InputDecoration(
                  labelText: 'Bahan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: TextField(
              controller: cara_membuatController,
              decoration: InputDecoration(
                  labelText: 'Cara Membuat',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ElevatedButton(
              child: const Text(
                'Simpan',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                String nama_resep = nama_resepController.text;
                String bahan = bahanController.text;
                String cara_membuat = cara_membuatController.text;
                // print(nama);
                postData(nama_resep, bahan, cara_membuat).then((result) {
                  //print(result['pesan']);
                  if (result['pesan'] == 'berhasil') {
                    showDialog(
                        context: context,
                        builder: (context) {
                          //var namauser2 = namauser;
                          return AlertDialog(
                            title: const Text('Data berhasil di tambah'),
                            content: const Text('ok'),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ListData(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        });
                  }
                  setState(() {});
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
