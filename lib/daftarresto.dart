import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DaftarResto(),
    );
  }
}

class DaftarResto extends StatefulWidget {
  @override
  _DaftarRestoState createState() => _DaftarRestoState();
}

class _DaftarRestoState extends State<DaftarResto> {
  final TextEditingController _namaMakananController = TextEditingController();
  final TextEditingController _linkProdukController = TextEditingController();
  final TextEditingController _linkMapController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _jamBukaController = TextEditingController();
  final TextEditingController _jamTutupController = TextEditingController();
  String? _selectedWeather;
  File? _selectedImage;

  Future<void> _submitData() async {
    CollectionReference foods = FirebaseFirestore.instance.collection('foods');
    await foods.add({
      'nama_makanan': _namaMakananController.text,
      'link_produk': _linkProdukController.text,
      'link_map': _linkMapController.text,
      'deskripsi': _deskripsiController.text,
      'jam_buka': _jamBukaController.text,
      'jam_tutup': _jamTutupController.text,
      'cuaca': _selectedWeather ?? 'Panas',
      'image_url': '',  // Ini nanti akan diisi dengan URL gambar yang diunggah
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Data berhasil disimpan'),
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Gagal menyimpan data: $error'),
      ));
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Define the action when the settings icon is pressed
            },
          ),
          SizedBox(width: 20),
        ],
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Container(
          width: 350,
          height: 750,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                blurRadius: 6,
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DAFTARKAN MAKANAN',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Nama Makanan',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 7),
                  Container(
                    height: 40,
                    child: TextFormField(
                      controller: _namaMakananController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(255, 225, 224, 224),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Link Produk',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 7),
                  Container(
                    height: 40,
                    child: TextFormField(
                      controller: _linkProdukController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(255, 225, 224, 224),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Link Map Lokasi Restoran',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 7),
                  Container(
                    height: 40,
                    child: TextFormField(
                      controller: _linkMapController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(255, 225, 224, 224),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Deskripsi',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 7),
                  Container(
                    height: 40,
                    child: TextFormField(
                      controller: _deskripsiController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(255, 225, 224, 224),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Jam Operasional Toko',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 7),
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 40,
                        child: TextFormField(
                          controller: _jamBukaController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 225, 224, 224),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.remove,
                        size: 24,
                      ),
                      SizedBox(width: 5),
                      Container(
                        width: 80,
                        height: 40,
                        child: TextFormField(
                          controller: _jamTutupController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 225, 224, 224),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Produk ini cocok untuk cuaca:',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 7),
                  Row(
                    children: [
                      Radio<String>(
                        activeColor: Colors.red,
                        value: 'Panas',
                        groupValue: _selectedWeather,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedWeather = value;
                          });
                        },
                      ),
                      Text("Panas"),
                      SizedBox(width: 40),
                      Radio<String>(
                        activeColor: Colors.red,
                        value: 'Dingin',
                        groupValue: _selectedWeather,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedWeather = value;
                          });
                        },
                      ),
                      Text("Dingin"),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Upload Foto Produk',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 7),
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 235, 234, 234),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _selectedImage != null
                            ? Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                              )
                            : Icon(
                                Icons.camera_alt,
                                color: Colors.grey[800],
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitData,
                      child: Text('Simpan Data'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
