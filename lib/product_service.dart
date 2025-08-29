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

  List<Product>? _cachedProducts;
  List<String>? _cachedCategories;
  List<String>? _cachedBrands;

  Future<List<Product>> loadProducts({bool forceRefresh = false}) async {
    if (_cachedProducts != null && !forceRefresh) {
      return _cachedProducts!;
    }

    final response = await http.get(Uri.parse('$baseUrl?limit=0')); // fetch all
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> productsJson = data['products'];

      _cachedProducts = productsJson
          .map((json) => Product.fromJson(json))
          .toList();

      _cachedProducts!.shuffle(Random());
      return _cachedProducts!;
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }

  Future<List<Product>> searchProducts({
    required String query,
    String? category,
  }) async {
    final products = await loadProducts();
    final lowerQuery = query.toLowerCase();

    return products.where((product) {
      final matchesQuery = product.title.toLowerCase().contains(lowerQuery);
      final matchesCategory = category == null || category == 'All'
          ? true
          : product.category.toLowerCase() == category.toLowerCase();
      return matchesQuery && matchesCategory;
    }).toList();
  }

  Future<List<String>> fetchPromotionImages() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.generate(
      4,
      (_) =>
          "https://picsum.photos/800/600?grayscale&random=${Random().nextInt(100)}",
    );
  }

  Future<List<String>> fetchCategories({bool forceRefresh = false}) async {
    if (_cachedCategories != null && !forceRefresh) {
      return _cachedCategories!;
    }

    final response = await http.get(Uri.parse('$baseUrl/categories'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _cachedCategories = List<String>.from(data);
      return _cachedCategories!;
    } else {
      throw Exception('Failed to load categories: ${response.statusCode}');
    }
  }

  Future<List<String>> fetchBrands({bool forceRefresh = false}) async {
    if (_cachedBrands != null && !forceRefresh) {
      return _cachedBrands!;
    }

    final allProducts = await loadProducts();
    final brandsSet = allProducts.map((p) => p.brand).toSet();
    _cachedBrands = ["All", ...brandsSet];
    return _cachedBrands!;
  }
}
