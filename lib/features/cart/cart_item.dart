// lib/features/cart/models/cart_item.dart
class CartItem {
  final String id;
  final String productId;
  final String title;
  final double price;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
    };
  }
}