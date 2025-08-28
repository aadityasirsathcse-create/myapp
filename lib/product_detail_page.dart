import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'product_service.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product; // ✅ Use Product model instead of Map

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // Use product.title for AppBar title
        title: Text(product.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              context.go('/home'); // Navigate back to home
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Product image
 ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network( // Use product.image for the image URL
 product.image.isNotEmpty
                    ? product.image
                    : 'https://via.placeholder.com/250', // fallback placeholder
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
 product.title, // Use product.title for product name
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "\$${product.price.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18),
            ),
            // Removed originalPrice as it's not available from the API
            const SizedBox(height: 16), // Added some spacing
            Text(
              product.description,
              style: const TextStyle(fontSize: 16), // Adjusted font size slightly for description
            ),
          ],
        ),
      ),
    );
  }
}
