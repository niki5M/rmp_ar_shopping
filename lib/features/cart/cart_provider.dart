import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => [..._items];

  int get itemCount => _items.length;

  double get totalAmount {
    return _items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  void addItem(String productId, String title, double price, String imageUrl) {
    final existingIndex = _items.indexWhere((item) => item.id == productId);

    if (existingIndex >= 0) {
      _items[existingIndex] = CartItem(
        id: _items[existingIndex].id,
        title: _items[existingIndex].title,
        price: _items[existingIndex].price,
        quantity: _items[existingIndex].quantity + 1,
        imageUrl: _items[existingIndex].imageUrl,
      );
    } else {
      _items.add(CartItem(
        id: productId,
        title: title,
        price: price,
        quantity: 1,
        imageUrl: imageUrl,
      ));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.id == productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}