import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crud_flutter/side_menu.dart';
import 'package:crud_flutter/tambah_data.dart';
import 'package:crud_flutter/update_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListData extends StatefulWidget {
  const ListData({super.key});
  @override
// ignore: library_private_types_in_public_api
  _ListDataState createState() => _ListDataState();
}

class _ListDataState extends State<ListData> {
  List<Map<String, String>> dataResep = [];
  String url = 'http://localhost/UTS_Mobile/index.php';
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        dataResep = List<Map<String, String>>.from(data.map((item) {
          return {
            'nama_resep': item['nama_resep'] as String,
            'bahan': item['bahan'] as String,
            'cara_membuat': item['cara_membuat'] as String,
            'id': item['id'] as String,
          };
        }));
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future deleteData(int id) async {
    final response = await http.delete(Uri.parse('$url?id=$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to delete data');
    }
  }

  lihatResep(String id, String nama_resep, String bahan, String cara_membuat) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Resep Masakan'),
            content: Container(
              height: 100.0,
              width: 400.0,
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: <Widget>[
                  Container(
                    child: Text('Id : $id'),
                  ),
                  Container(
                    child: Text('Nama Resep : $nama_resep'),
                  ),
                  Container(
                    child: Text('bahan : $bahan'),
                  ),
                  Container(
                    child: Text('Cara Membuat : $cara_membuat'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Data Resep'),
      ),
      drawer: const SideMenu(),
      body: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => const TambahData()),
                  ));
            },
            child: const Text('Tambah Data Resep'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dataResep.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(dataResep[index]['nama_resep']!),
                  subtitle: Text('bahan: ${dataResep[index]['bahan']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.visibility),
                        onPressed: () {
                          lihatResep(
                              dataResep[index]['id']!,
                              dataResep[index]['nama_resep']!,
                              dataResep[index]['bahan']!,
                              dataResep[index]['cara_membuat']!);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => UpdateData(
                                    id: dataResep[index]['id']!,
                                    nama_resep: dataResep[index]['nama_resep']!,
                                    bahan: dataResep[index]['bahan']!,
                                    cara_membuat: dataResep[index]
                                        ['cara_membuat']!,
                                    url: url)),
                              ));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          deleteData(int.parse(dataResep[index]['id']!))
                              .then((result) {
                            if (result['pesan'] == 'berhasil') {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title:
                                          const Text('Data berhasil di hapus'),
                                      content: const Text('ok'),
                                      actions: [
                                        TextButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const ListData(),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            }
                          });
                        },
                      ),
                    ],
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
