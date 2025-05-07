import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/theme.dart';
import '../cart/cart_provider.dart';
import '../favorites/favorites_provider.dart';
import '../home/widgets/product.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final product = Product.fromMap(routeArgs);
    final cart = Provider.of<CartProvider>(context, listen: false);
    final favorites = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(product.title),
              background: Hero(
                tag: product.id,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  favorites.isFavorite(product.id)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: favorites.isFavorite(product.id)
                      ? Colors.red
                      : Colors.white,
                ),
                onPressed: () {
                  favorites.toggleFavorite(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        favorites.isFavorite(product.id)
                            ? 'Добавлено в избранное'
                            : 'Удалено из избранного',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${product.price.toStringAsFixed(0)} ₽',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Описание',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Элегантный ${product.title} создан для тех, кто ценит качество и стиль. '
                        'Изготовлен из премиальных материалов с вниманием к деталям.',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Характеристики',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._buildFeaturesList(),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: AppTheme.secondaryButtonStyle,
                      onPressed: () {
                        Navigator.pushNamed(context, '/ar_try_on');
                      },
                      child: const Text('Примерить в AR'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: AppTheme.primaryButtonStyle,
                      onPressed: () {
                        cart.addItem(product);
                      },
                      child: const Text('Добавить в корзину'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFeaturesList() {
    return [
      _buildFeatureItem('Материал', 'Хлопок 100%'),
      _buildFeatureItem('Цвет', 'Черный'),
      _buildFeatureItem('Размеры', 'XS-XXL'),
      _buildFeatureItem('Страна', 'Италия'),
      _buildFeatureItem('Сезон', 'Всесезонный'),
    ];
  }

  Widget _buildFeatureItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}