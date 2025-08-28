import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class Product {
  final int id;
  final String title;
  final double price;
  final String image;
  final String category;
  final String description;
  final String brand;
  final double rating;
  final double discountPercentage;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.category,
    required this.description,
    required this.brand,
    required this.rating,
    required this.discountPercentage,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      image: (json['images'] != null && (json['images'] as List).isNotEmpty)
          ? json['images'][0] as String
          : '',
      category: json['category'] as String,
      description: json['description'] ?? '',
      brand: json['brand'] ?? '',
      rating: (json['rating'] as num).toDouble(),
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
    );
  }
}

class ProductService {
  final String baseUrl = 'https://dummyjson.com/products';

  /// Load all products
  Future<List<Product>> loadProducts() async {
    final response = await http.get(Uri.parse('$baseUrl?limit=0')); // fetch all

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> productsJson = data['products'];
      final products = productsJson
          .map((json) => Product.fromJson(json))
          .toList();

      // Shuffle for randomness
      products.shuffle(Random());
      return products;
    } else {
      throw Exception(
        'Failed to load products from API: ${response.statusCode}',
      );
    }
  }

  /// Search products
  Future<List<Product>> searchProducts({
    required String query,
    String? category,
  }) async {
    final allProducts = await loadProducts();
    final lowerQuery = query.toLowerCase();

    return allProducts.where((product) {
      final matchesQuery = product.title.toLowerCase().contains(lowerQuery);
      final matchesCategory = category == null || category == 'All'
          ? true
          : product.category.toLowerCase() == category.toLowerCase();
      return matchesQuery && matchesCategory;
    }).toList();
  }

  /// Fetch promotion images
  Future<List<String>> fetchPromotionImages() async {
    await Future.delayed(const Duration(seconds: 1));
    return List.generate(
      4,
      (_) =>
          "https://picsum.photos/800/600?grayscale&random=${Random().nextInt(100)}",
    );
  }

  /// Fetch product categories
  Future<List<String>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return List<String>.from(data);
    } else {
      throw Exception(
        'Failed to load categories from API: ${response.statusCode}',
      );
    }
  }

  /// Fetch brands dynamically
  Future<List<String>> fetchBrands() async {
    final allProducts = await loadProducts();
    final brandsSet = allProducts.map((p) => p.brand).toSet();
    return ["All", ...brandsSet];
  }
}
