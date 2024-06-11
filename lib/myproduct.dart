import 'produk.dart';
import 'package:flutter/material.dart';

class Myproduct {
  static List<Produk> allList = [
    Produk(
      id: 1,
      name: 'KopiCakSoleh.jpg',
      image: const AssetImage('assets/KopiCakSoleh.jpg').assetName,
    ),
    Produk(
      id: 1,
      name: 'SeblakMamaIndah.jpg',
      image: const AssetImage('assets/SeblakMamaIndah.jpg').assetName,
    ),
    Produk(
      id: 1,
      name: 'BaksoMercon.jpg',
      image: const AssetImage('assets/BaksoMercon.jpg').assetName,
    ),
    Produk(
      id: 1,
      name: 'Donat.jpg',
      image: const AssetImage('assets/Donat.jpg').assetName,
    ),
  ];
}
