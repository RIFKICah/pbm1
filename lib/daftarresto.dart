import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_services.dart'; // Import FirestoreServices
import 'package:jajananku/homepage.dart';

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
    if (_selectedImage != null) {
      try {
        String imageUrl = await FirestoreServices.uploadImage(_selectedImage!);

        // Simpan data ke Firestore
        await FirebaseFirestore.instance.collection('resto').add({
          'namaMakanan': _namaMakananController.text,
          'linkProduk': _linkProdukController.text,
          'linkMap': _linkMapController.text,
          'deskripsi': _deskripsiController.text,
          'jamBuka': _jamBukaController.text,
          'jamTutup': _jamTutupController.text,
          'selectedWeather': _selectedWeather,
          'imageUrl': imageUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Data berhasil disimpan dengan URL gambar: $imageUrl'),
        ));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Homepage()),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Gagal menyimpan data: $error'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Silakan pilih gambar terlebih dahulu'),
      ));
    }
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

  Future<void> _saveDataToTextFile(String imageUrl) async {
    // Construct data string
    String data = '''
      Nama Makanan: ${_namaMakananController.text}
      Link Produk: ${_linkProdukController.text}
      Link Map Lokasi Restoran: ${_linkMapController.text}
      Deskripsi: ${_deskripsiController.text}
      Jam Operasional Toko: ${_jamBukaController.text} - ${_jamTutupController.text}
      Produk ini cocok untuk cuaca: ${_selectedWeather ?? 'Tidak ditentukan'}
      URL Gambar: $imageUrl
    ''';

    try {
      // Save data to text file

      // Clear form fields
      _clearFormFields();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Data berhasil disimpan dalam file teks'),
      ));
    } catch (error) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Gagal menyimpan data dalam file teks: $error'),
      ));
    }
  }

  void _clearFormFields() {
    // Clear all form fields
    _namaMakananController.clear();
    _linkProdukController.clear();
    _linkMapController.clear();
    _deskripsiController.clear();
    _jamBukaController.clear();
    _jamTutupController.clear();
    setState(() {
      _selectedWeather = null;
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Homepage()),
            );
          },
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
                        iconColor: Colors.red,
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
