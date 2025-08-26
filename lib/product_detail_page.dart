import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              context.go('/'); // Navigate back to the home page
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display product image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product['image'] ?? 'https://via.placeholder.com/250', // Fallback placeholder
                height: 250, // Adjust height as needed
                fit: BoxFit.cover,
              )),
            Text(
              product['name'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "\$${product['price']}",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
