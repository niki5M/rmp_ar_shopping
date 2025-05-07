// lib/features/cart/cart_provider.dart
import 'package:flutter/material.dart';
import '../home/widgets/product.dart';
import 'cart_item.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get totalAmount => _items.fold(0, (sum, item) => sum + item.totalPrice);

  void addItem(Product product) {
    final existingIndex = _items.indexWhere((item) => item.productId == product.id);

    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(
        id: DateTime.now().toString(),
        productId: product.id,
        title: product.title,
        price: product.price,
        imageUrl: product.imageUrl,
      ));
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}