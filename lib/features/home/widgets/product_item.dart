// lib/features/home/widgets/product_item.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testik2/features/home/widgets/product.dart';
import '../../cart/cart_provider.dart';
import '../../favorites/favorites_provider.dart';
import 'package:testik2/core/theme/colors.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = Provider.of<FavoritesProvider>(context, listen: false);
    final cart = Provider.of<CartProvider>(context, listen: false);
    final isFavorite = context.select<FavoritesProvider, bool>(
          (provider) => provider.isFavorite(product.id),
    );

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.pushNamed(
          context,
          '/product',
          arguments: product.toMap(),
        );
      },
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${product.price.toStringAsFixed(0)} ₽',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    cart.addItem(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.title} добавлен в корзину'),
                      ),
                    );
                  },
                  child: const Text(
                    'В корзину',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(double.infinity, 35),
                    side: BorderSide(
                      color: Palete.lightPrimaryColor,
                      width: 2,
                    ),
                    backgroundColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black87
                        : Colors.white,
                    foregroundColor: Palete.lightPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.black87,
              ),
              onPressed: () {
                favorites.toggleFavorite(product);
              },
            ),
          ),
        ],
      ),
    );
  }
}