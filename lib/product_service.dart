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

  /// ✅ From REST API JSON (dummyjson.com)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      image: (json['images'] != null && (json['images'] as List).isNotEmpty)
          ? json['images'][0] as String
          : '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      brand: json['brand'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0,
    );
  }

  /// ✅ To Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'image': image,
      'category': category,
      'description': description,
      'brand': brand,
      'rating': rating,
      'discountPercentage': discountPercentage,
    };
  }

  /// ✅ From Firestore Map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0,
      image: map['image'] ?? '',
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      brand: map['brand'] ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      discountPercentage: (map['discountPercentage'] as num?)?.toDouble() ?? 0,
    );
  }
}

class ProductService {
  final String baseUrl = 'https://dummyjson.com/products';

  // Caching is removed to simplify pagination logic.
  // We can add a more sophisticated caching layer later if needed.
  List<String>? _cachedCategories;
  List<String>? _cachedBrands;

  /// Fetches a paginated list of products.
  Future<List<Product>> loadProducts({int limit = 10, int skip = 0}) async {
    final response = await http.get(
      Uri.parse('$baseUrl?limit=$limit&skip=$skip'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> productsJson = data['products'];

      // No more shuffling, as the order is now important for pagination.
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }

  /// Searches for products using the remote API.
  Future<List<Product>> searchProducts({
    required String query,
    String? category, // Category filtering on the client side for this API
  }) async {
    if (query.isEmpty) {
      return [];
    }

    // Use the search endpoint from the API
    final response = await http.get(
      Uri.parse('$baseUrl/search?q=${Uri.encodeComponent(query)}'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> productsJson = data['products'];
      List<Product> products = productsJson
          .map((json) => Product.fromJson(json))
          .toList();

      // The dummyjson API doesn't support filtering search by category,
      // so we do it on the client side if a category is provided.
      if (category != null && category != 'All') {
        products = products.where((product) {
          return product.category.toLowerCase() == category.toLowerCase();
        }).toList();
      }

      return products;
    } else {
      throw Exception('Failed to search products: ${response.statusCode}');
    }
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

  // This method is inefficient as it loads all products first.
  // However, dummyjson API does not provide an endpoint to get all unique brands.
  // For a real application, this should be handled by the backend.
  // We'll leave it as is for now.
  Future<List<String>> fetchBrands({bool forceRefresh = false}) async {
    if (_cachedBrands != null && !forceRefresh) {
      return _cachedBrands!;
    }

    // This is still inefficient, fetching ALL products just to get brands.
    final response = await http.get(Uri.parse('$baseUrl?limit=0'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> productsJson = data['products'];
      final allProducts = productsJson
          .map((json) => Product.fromJson(json))
          .toList();
      final brandsSet = allProducts.map((p) => p.brand).toSet();
      _cachedBrands = ["All", ...brandsSet];
      return _cachedBrands!;
    } else {
      throw Exception('Failed to fetch brands: ${response.statusCode}');
    }
  }
}
