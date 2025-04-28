import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final id = routeArgs['id'];
    final title = routeArgs['title'];
    final price = routeArgs['price'];
    final imageUrl = routeArgs['imageUrl'];

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '\$$price',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                'Description for $title',
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.shopping_cart),
        onPressed: () {
          Provider.of<CartProvider>(context, listen: false).addItem(
            id,
            title,
            price,
            imageUrl,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Added $title to cart!'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }
}