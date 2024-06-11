import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class Barang {
  final String nama;
  final String image;
  final String deskripsi; // Add the deskripsi field
  final String linkProduk;
  final String locationLink;

  Barang({
    required this.nama,
    required this.image,
    required this.deskripsi,
    required this.linkProduk,
    required this.locationLink,
  });
}

class Nyobagridvies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('resto').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            List<Barang> barangList =
                snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return Barang(
                  nama: data['namaMakanan'],
                  image: data['imageUrl'],
                  deskripsi:
                      data['deskripsi'], // Retrieve deskripsi from Firestore
                  linkProduk: data['linkProduk'],
                  locationLink: data['linkMap']);
            }).toList();

            return GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.zero,
              children: barangList
                  .map((barang) => buildCard(context, barang))
                  .toList(),
            );
          },
        ),
      ),
    );
  }
}

Widget buildCard(BuildContext context, Barang barang) {
  return Card(
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 150, maxHeight: 161),
      child: Container(
        padding: EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  decoration:
                      BoxDecoration(color: const Color.fromARGB(0, 0, 0, 0)),
                  width: 150,
                  height: 161,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0.0,
                        left: 0.0,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                            shadowColor:
                                MaterialStateProperty.all(Colors.transparent),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(horizontal: 1),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            _showCustomDialog(context, barang);
                          },
                          child: Container(
                            color: const Color.fromARGB(0, 0, 0, 0),
                            width: 150,
                            height: 124,
                            padding: EdgeInsets.all(2),
                            child: Image.network(
                              barang.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                            shadowColor:
                                MaterialStateProperty.all(Colors.transparent),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(horizontal: 1),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            _showCustomDialog(context, barang);
                          },
                          child: Container(
                            color: Color.fromARGB(0, 255, 255, 255),
                            width: 150,
                            height: 37,
                            padding: EdgeInsets.all(2),
                            child: Text(
                              barang.nama,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

void _showCustomDialog(BuildContext context, Barang barang) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                barang.nama,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  barang.image,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10),
              Text(
                barang.deskripsi, // Use deskripsi from Barang model
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      _openLocationUrl(barang
                          .locationLink); // Menggunakan link lokasi dari objek Barang
                    },
                    style: ElevatedButton.styleFrom(
                      iconColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text('Lokasi Toko'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _launchURL(
                          context,
                          barang
                              .linkProduk); // Menggunakan link dari objek Barang
                    },
                    style: ElevatedButton.styleFrom(
                      iconColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text('Beli'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _launchURL(BuildContext context, String linkProduk) async {
  if (linkProduk.isEmpty) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Container(
            width: 300.0,
            height: 190.0,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(
                          20), // Tambahkan padding 20 di sekitar teks
                      child: Text(
                        'Maaf, produk ini tidak tersedia secara online.',
                        textAlign:
                            TextAlign.start, // Set text alignment to center
                      ),
                    ),
                    SizedBox(height: 20), // Spacer
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 100, // Set lebar 100
                        child: Center(
                          child: Text('OK'),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20.0), // Set corner radius 20
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  } else {
    final Uri _url = Uri.parse(linkProduk);
    if (await canLaunch(_url.toString())) {
      await launch(_url.toString());
    } else {
      throw 'Could not launch $_url';
    }
  }
}

void _openLocationUrl(String url) async {
  final Uri _url = Uri.parse(url);
  if (await canLaunch(_url.toString())) {
    await launch(_url.toString());
  } else {
    throw 'Could not launch $_url';
  }
}

void main() {
  runApp(Nyobagridvies());
}
