// lib/features/favorites/favorites_provider.dart
import 'package:flutter/material.dart';

import '../home/widgets/product.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<Product> _favorites = [];

  List<Product> get favorites => _favorites;
  List<String> get favoriteIds => _favorites.map((p) => p.id).toList();

  bool isFavorite(String id) {
    return _favorites.any((product) => product.id == id);
  }

  void toggleFavorite(Product product) {
    if (isFavorite(product.id)) {
      _favorites.removeWhere((p) => p.id == product.id);
    } else {
      _favorites.add(product);
    }
    notifyListeners();
  }
}