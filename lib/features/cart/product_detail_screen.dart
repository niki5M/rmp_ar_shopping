// lib/features/product/product_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testik2/features/home/widgets/product.dart';
import 'package:testik2/core/theme/colors.dart';

import '../favorites/favorites_provider.dart';
import 'cart_provider.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  String _generateRandomDescription(String productName) {
    final descriptions = [
      'Эти $productName изготовлены из высококачественных материалов с использованием передовых технологий. Идеальное сочетание стиля и функциональности.',
      'Стильные и надежные $productName, которые подчеркнут ваш индивидуальный стиль. Отличный выбор для повседневного использования и особых случаев.',
      'Инновационный дизайн $productName сочетает в себе элегантность и современные технологии. Гарантия качества и долговечности.',
      'Эксклюзивные $productName с уникальным дизайном. Каждая деталь тщательно продумана для максимального комфорта и удовлетворения.',
      'Премиальные $productName, созданные для тех, кто ценит качество и стиль. Идеальный аксессуар для завершения вашего образа.',
      'Уникальные $productName с запатентованной технологией. Сочетание традиций и инноваций в каждом элементе.',
      'Эти $productName - результат многолетних исследований и разработок. Наслаждайтесь непревзойденным качеством и комфортом.',
    ];
    return descriptions[DateTime.now().millisecondsSinceEpoch % descriptions.length];
  }

  void _openARView(BuildContext context) { // Убрали параметр product
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ARDemoScreen(), // Теперь без передачи продукта
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Получаем аргументы, переданные при навигации
    final productData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final product = Product.fromMap(productData);

    // Если описание отсутствует, генерируем случайное
    final productDescription = product.description ?? _generateRandomDescription(product.title);

    final favorites = Provider.of<FavoritesProvider>(context, listen: false);
    final cart = Provider.of<CartProvider>(context, listen: false);
    final isFavorite = context.select<FavoritesProvider, bool>(
          (provider) => provider.isFavorite(product.id),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              favorites.toggleFavorite(product);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Изображение товара
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 300,
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      product.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${product.price.toStringAsFixed(0)} ₽',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Palete.lightPrimaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Характеристики
              const Text(
                'Характеристики',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFeatureRow('Бренд', product.brand ?? 'Не указано'),
                  _buildFeatureRow('Материал', product.material ?? 'Не указано'),
                  _buildFeatureRow('Водозащита', product.waterResistant ?? 'Не указано'),
                ],
              ),
              const SizedBox(height: 16),

              // Описание товара
              const Text(
                'Описание',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                productDescription,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 24),

              // Кнопка примерки в AR
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _openARView(context), // Теперь без передачи продукта
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Palete.lightPrimaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, color: Palete.lightPrimaryColor),
                      SizedBox(width: 8),
                      Text(
                        'Примерить в AR',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Palete.lightPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Кнопка добавления в корзину
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    cart.addItem(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.title} добавлен в корзину'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Palete.lightPrimaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Добавить в корзину',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}

class ARDemoScreen extends StatefulWidget {
  // final Product product;

  const ARDemoScreen({super.key});

  @override
  State<ARDemoScreen> createState() => _ARDemoScreenState();
}

class _ARDemoScreenState extends State<ARDemoScreen> {
  bool _isProductPlaced = false;
  bool _showLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate AR loading
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Примерка в AR'),
      ),
      body: Stack(
        children: [
          // Fake camera preview
          Container(
            // decoration: const BoxDecoration(
            //   image: DecorationImage(
            //     image: AssetImage('assets/images/test.jpg'),
            //     fit: BoxFit.cover,
            //   ),
            // ),
            color: Colors.black,
            child: Center(
              child: _showLoading
                  ? const CircularProgressIndicator()
                  : _isProductPlaced
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/png.png',
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Переместите камеру, чтобы увидеть товар в вашем пространстве',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.camera_alt,
                    size: 80,
                    color: Colors.white54,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Наведите камеру на ровную поверхность',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isProductPlaced = true;
                      });
                    },
                    child: const Text('Разместить товар'),
                  ),
                ],
              ),
            ),
          ),
          // AR controls
          if (!_showLoading)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      // Rotate action
                    },
                    child: const Icon(Icons.rotate_left),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      // Scale action
                    },
                    child: const Icon(Icons.zoom_in),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      // Close AR view
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}