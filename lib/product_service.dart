import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Product {
  final String name;
  final double price;
  final double? originalPrice;
  final String image;
  final bool? flashSale;
  final bool? discount;
  final String category;
  final String? description;

  Product({
    required this.name,
    required this.price,
    this.originalPrice,
    required this.image,
    this.flashSale,
    this.discount,
    required this.category,
    this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      originalPrice: json['originalPrice'] != null
          ? (json['originalPrice']).toDouble()
          : null,
      image: json['image'] ?? '',
      flashSale: json['flashSale'],
      discount: json['discount'],
      category: json['category'] ?? 'Uncategorized',
      description: json['description'],
    );
  }
}

class ProductService {
  Future<List<Product>> loadProducts() async {
    final String response = await rootBundle.loadString('assets/products.json');
    final List<dynamic> data = json.decode(response);

    return data.map((json) => Product.fromJson(json)).toList();
  }
}
