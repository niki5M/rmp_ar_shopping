// lib/features/home/models/product.dart
class Product {
  final String id;
  final String title;
  final double price;
  final String imageUrl;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
  });

  // Для преобразования из Map (если нужно)
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      title: map['title'],
      price: map['price'],
      imageUrl: map['imageUrl'],
    );
  }

  // Для преобразования в Map (если нужно)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}