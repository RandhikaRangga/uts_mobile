import 'dart:convert';
import 'package:crud_flutter/list_data.dart';
import 'package:crud_flutter/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateData extends StatefulWidget {
  final String id;
  final String nama_resep;
  final String bahan;
  final String cara_membuat;
  final String url;
  const UpdateData(
      {super.key,
      required this.id,
      required this.nama_resep,
      required this.bahan,
      required this.cara_membuat,
      required this.url});
  @override
  _UpdateData createState() => _UpdateData(url: url);
}

class _UpdateData extends State<UpdateData> {
  String url;
  _UpdateData({required this.url});
  final _nama_resepController = TextEditingController();
  final _bahanController = TextEditingController();
  final _cara_membuatController = TextEditingController();

  Future<void> updateData(
      String nama_resep, String bahan, String cara_membuat, String id) async {
    final response = await http.put(
      Uri.parse(url),
      body: jsonEncode(<String, String>{
        'id': id,
        'nama resep': nama_resep,
        'bahan': bahan,
        'cara membuat': cara_membuat,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ListData(),
        ),
      );
    } else {
      throw Exception('Failed to Update Data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Edit Resep')),
        drawer: const SideMenu(),
        body: ListView(padding: const EdgeInsets.all(16.0), children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: TextField(
              controller: _nama_resepController,
              decoration: InputDecoration(
                  label: Text(widget.nama_resep),
                  hintText: "Nama...",
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
              controller: _bahanController,
              decoration: InputDecoration(
                  label: Text(widget.bahan),
                  hintText: "Bahan...",
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
              controller: _cara_membuatController,
              decoration: InputDecoration(
                  label: Text(widget.bahan),
                  hintText: "Cara Membuat...",
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
                    updateData(
                        _nama_resepController.text,
                        _bahanController.text,
                        _cara_membuatController.text,
                        widget.id);
                  }))
        ]));
  }
}
