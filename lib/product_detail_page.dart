import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/cart_service.dart';
import 'package:myapp/product_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/product_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool _isFavorite = false;
  bool _isInCart = false;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
    _checkIfInCart();
  }

  /// 🔥 Check if product already in wishlist
  Future<void> _checkIfFavorite() async {
    if (user == null) return;
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("wishlist")
        .doc(widget.product.id.toString())
        .get();
    setState(() => _isFavorite = doc.exists);
  }

  /// 🛒 Check if product is in cart
  Future<void> _checkIfInCart() async {
    if (user == null) return;
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("cart")
        .doc(widget.product.id.toString())
        .get();
    setState(() => _isInCart = doc.exists);
  }

  /// ❤️ Toggle favorite
  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    if (_isFavorite) {
      CartService.instance.addToWishlist(widget.product);
    } else {
      CartService.instance.removeFromWishlist(widget.product);
    }
  }

  /// 🛒 Toggle cart state (instant update)
  Future<void> _toggleCart() async {
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please log in to add items to cart.")),
      );
      return;
    }

    final docRef = FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("cart")
        .doc(widget.product.id.toString());

    setState(() {
      _isInCart = !_isInCart; // instant UI update
    });

    if (_isInCart) {
      await docRef.set({
        "id": widget.product.id,
        "title": widget.product.title,
        "price": widget.product.price,
        "image": widget.product.image,
        "category": widget.product.category,
        "description": widget.product.description,
        "brand": widget.product.brand,
        "rating": widget.product.rating,
        "discountPercentage": widget.product.discountPercentage,
        "quantity": 1,
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Added to cart!")));
    } else {
      await docRef.delete();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Removed from cart!")));
    }
  }

  /// ⚡ Buy Now → Ensure in cart then go to cart
  Future<void> _buyNow() async {
    if (!_isInCart) {
      await _toggleCart();
    }
    context.push('/cart');
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 247, 247),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(250, 250, 251, 1),
                  Color.fromARGB(255, 245, 247, 247),
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // 🔙 Back + ❤️ Wishlist button
                // 🔙 Back + ❤️ Wishlist button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 3,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => context.pop(),
                      ),
                      IconButton(
                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorite ? Colors.red : Colors.black,
                        ),
                        onPressed: _toggleFavorite,
                      ),
                    ],
                  ),
                ),

                // 🖼️ Product Image
                // 🖼️ Product Image
                Hero(
                  tag: product.id,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      product.image.isNotEmpty
                          ? product.image
                          : 'https://via.placeholder.com/300',
                      height: 400,
                      width: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // 📦 Product Info
                // 📦 Product Info
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          product.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Price + Discount
                        // Price + Discount
                        Row(
                          children: [
                            Text(
                              "\$${product.price.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 16),
                            if (product.discountPercentage > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "${product.discountPercentage.toStringAsFixed(0)}% OFF",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // ⭐ Rating stars
                        // ⭐ Rating stars
                        Row(
                          children: List.generate(
                            5,
                            (index) => Icon(
                              Icons.star,
                              size: 20,
                              color: index < product.rating.round()
                                  ? Colors.amber
                                  : Colors.grey[300],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // 📖 Description
                        // 📖 Description
                        Text(
                          product.description,
                          style: const TextStyle(fontSize: 16, height: 1.4),
                        ),

                        const Spacer(),

                        // 🛒 Buttons
                        // 🛒 Buttons
                        Row(
                          children: [
                            // Add / Remove Cart
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFFA726),
                                      Color(0xFFFF7043),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () async {
                                      if (_isInCart) {
                                        // Already in cart → Go to cart
                                        context.push('/cart');
                                      } else {
                                        // Optimistic update
                                        setState(() => _isInCart = true);

                                        await CartService.instance.addToCart(
                                          product,
                                        );

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text("Added to cart!"),
                                          ),
                                        );
                                      }
                                    },

                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      child: Center(
                                        child: Text(
                                          _isInCart
                                              ? "View in Cart"
                                              : "Add to Cart",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Buy Now
                            // Buy Now
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF5B74FF),
                                      Color(0xFF2DE6AF),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: _buyNow,
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Buy Now",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
