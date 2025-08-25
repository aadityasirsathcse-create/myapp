import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name'] ?? 'Product Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product['image'] != null)
              Center(
                child: Image.network(
                  product['image'],
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ),
            const SizedBox(height: 20),
            Text(
              product['name'] ?? 'No name available',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Text(
              '\$${product['price']?.toStringAsFixed(2) ?? 'N/A'}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.green[700],
                  ),
            ),
            const SizedBox(height: 20),
            Text(
              product['description'] ?? 'No description available.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            // You can add more product details here as needed
          ],
        ),
      ),
    );
  }
}