import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../model/filter.dart';

class AppImageProvider extends ChangeNotifier{
  Uint8List? currentImage;
  Filter? currentFilter;


  changeImageFile(File image){
    currentImage = image.readAsBytesSync();
    notifyListeners();
  }

  changeImage(Uint8List image){
    currentImage = image;
    notifyListeners();
  }

  changeFilter(Filter filter) {
    currentFilter = filter;
    notifyListeners();
  }
}