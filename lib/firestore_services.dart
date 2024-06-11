import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreServices {
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<void> addData(
      String namaMakanan,
      String linkProduk,
      String linkMap,
      String deskripsi,
      String jamBuka,
      String jamTutup,
      String selectedWeather,
      File imageFile) async {
    try {
      // Upload gambar ke Firebase Storage
      String imageUrl = await uploadImage(imageFile);

      // Simpan URL gambar ke Firestore
      await _firestore.collection('resto').add({
        'namaMakanan': namaMakanan,
        'linkProduk': linkProduk,
        'linkMap': linkMap,
        'deskripsi': deskripsi,
        'jamBuka': jamBuka,
        'jamTutup': jamTutup,
        'selectedWeather': selectedWeather,
        'imageUrl': imageUrl,
      });
    } catch (error) {
      throw Exception('Failed to add data to Firestore: $error');
    }
  }

  static Future<String> uploadImage(File imageFile) async {
    try {
      // Generate nama unik untuk file
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Referensi path di Firebase Storage
      Reference storageReference = _storage.ref().child('images/$fileName');

      // Upload file
      UploadTask uploadTask = storageReference.putFile(imageFile);

      // Menunggu proses upload selesai
      await uploadTask;

      // Dapatkan URL gambar yang diunggah
      String imageUrl = await storageReference.getDownloadURL();

      return imageUrl;
    } catch (error) {
      throw Exception('Failed to upload image to Firebase Storage: $error');
    }
  }
}
