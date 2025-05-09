class Product {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final String? description;
  final String? brand;
  final String? material;
  final String? waterResistant;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.description,
    this.brand,
    this.material,
    this.waterResistant,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'description': description,
      'brand': brand,
      'material': material,
      'waterResistant': waterResistant,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      title: map['title'],
      price: map['price'],
      imageUrl: map['imageUrl'],
      description: map['description'],
      brand: map['brand'],
      material: map['material'],
      waterResistant: map['waterResistant'],
    );
  }
}