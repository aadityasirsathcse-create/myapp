import 'dart:convert';
import 'package:http/http.dart' as http;

class Product {
  final int id;
  final String title;
  final double price;
  final String image;
  final String category;
  final String description;
  // The FakeStoreAPI also includes a 'rating' field, but we're not using it in this model for now.

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.category,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(), // API returns num, convert to double
      image: json['image'] as String,
      category: json['category'] as String,
      description: json['description'],
    );
  }
}

class ProductService {
  Future<List<Product>> loadProducts() async {
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products from API: ${response.statusCode}');
    }
  }
}
