import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/cart_service.dart';
import 'product_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shimmer/shimmer.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final ProductService _productService = ProductService();
  List<Product> suggestedProducts = [];
  bool isLoading = true;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadSuggestedProducts();
  }

  Future<void> _loadSuggestedProducts() async {
    try {
      final products = await _productService.loadProducts();
      setState(() {
        suggestedProducts = products.take(10).toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Failed to load suggested products: $e");
      setState(() => isLoading = false);
    }
  }

  // --- Quantity stepper used in Suggested Products ---
  Widget _buildSuggestedQuantityStepper(Product product, int quantity) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, color: Colors.red),
            onPressed: () async {
              if (user == null) return;
              if (quantity > 1) {
                await CartService.instance.updateCartItemQuantity(
                  product.id,
                  quantity - 1,
                );
              } else {
                // quantity would go to 0 → remove from cart
                await CartService.instance.removeFromCart(product);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Removed from cart")),
                  );
                }
              }
            },
          ),
          GestureDetector(
            onTap: () => context.push('/cart'),
            child: Text(
              quantity.toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.green),
            onPressed: () async {
              if (user == null) return;
              await CartService.instance.updateCartItemQuantity(
                product.id,
                quantity + 1,
              );
            },
          ),
        ],
      ),
    );
  }

  // Add to cart helper for Suggested Products
  Future<void> _addSuggestedToCart(Product product) async {
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please log in to add items to cart.")),
      );
      return;
    }
    await CartService.instance.addToCart(product);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Added to cart!")));
    }
  }

  // Stream of user's cart docs (id → quantity) for Suggested Products
  Stream<Map<String, int>>? _cartQuantityMapStream() {
    if (user == null) return null;
    final col = FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("cart");
    return col.snapshots().map((snap) {
      final map = <String, int>{};
      for (final d in snap.docs) {
        final data = d.data();
        final qty = (data['quantity'] is int)
            ? data['quantity'] as int
            : int.tryParse('${data['quantity']}') ?? 1;
        map[d.id] = qty;
      }
      return map;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, size: 27),
              onPressed: () => context.pop(),
            ),
            const Text(
              'My Cart',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        toolbarHeight: 80,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            children: [
              /// 🔹 Cart Items from Firestore (kept as-is with your CartService)
              StreamBuilder<List<Product>>(
                stream: CartService.instance.getCartStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildCartListSkeleton();
                  }
                  if (snapshot.hasError) {
                    return const Text("Error loading cart items");
                  }

                  final cartItems = snapshot.data ?? [];

                  if (cartItems.isEmpty) {
                    return Column(
                      children: [
                        const SizedBox(height: 25),
                        Image.asset(
                          'assets/images/illustration.png',
                          height: 180,
                          width: 180,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 1),
                        const Text(
                          'Nothing in your cart yet!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Check out some great discounts below!',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                      ],
                    );
                  }

                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final product = cartItems[index];
                      return InkWell(
                        onTap: () {
                          context.push('/productDetail', extra: product);
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                product.image.isNotEmpty
                                    ? product.image
                                    : 'https://via.placeholder.com/150',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              product.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              "\$${product.price.toStringAsFixed(2)}",
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await CartService.instance.removeFromCart(
                                  product,
                                );
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Removed from cart"),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

              const Divider(height: 40),

              /// 🔹 Suggested Products Section (with + / – stepper)
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Suggested Products',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),

              // Listen to the cart collection to know which suggested items are in cart and their quantities
              StreamBuilder<Map<String, int>>(
                stream: _cartQuantityMapStream(),
                builder: (context, cartSnap) {
                  final qtyMap = cartSnap.data ?? const <String, int>{};

                  return SizedBox(
                    height: 236,
                    child: isLoading
                        ? _buildSuggestedProductsSkeleton()
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: suggestedProducts.length,
                            itemBuilder: (context, index) {
                              final product = suggestedProducts[index];
                              final productIdStr = product.id.toString();
                              final inCart = qtyMap.containsKey(productIdStr);
                              final quantity = qtyMap[productIdStr] ?? 0;

                              return InkWell(
                                onTap: () {
                                  context.push(
                                    '/productDetail',
                                    extra: product,
                                  );
                                },
                                child: Container(
                                  width: 160,
                                  margin: const EdgeInsets.only(right: 12.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          product.image.isNotEmpty
                                              ? product.image
                                              : 'https://via.placeholder.com/150',
                                          height: 120,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                        ),
                                        child: Text(
                                          product.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "\$${product.price.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),

                                      // 🔹 If in cart → show stepper; else → Add to Cart button
                                      inCart
                                          ? _buildSuggestedQuantityStepper(
                                              product,
                                              quantity,
                                            )
                                          : InkWell(
                                              onTap: () async {
                                                await _addSuggestedToCart(
                                                  product,
                                                );
                                              },
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                    ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                    ),
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      const LinearGradient(
                                                        colors: [
                                                          Color(0xFFFFA726),
                                                          Color(0xFFFF7043),
                                                        ],
                                                      ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    "Add to Cart",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  );
                },
              ),

              const SizedBox(height: 30),

              /// 🔹 Discover More Button
              ElevatedButton(
                onPressed: () => context.push('/home'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(6.0, 6.0, 6.0, 42.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5B74FF), Color(0xFF2DE6AF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 13,
                    ),
                    width: double.infinity,
                    child: const Text(
                      'Discover more Products',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartListSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 3, // Show 3 skeleton items
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 60,
                  height: 60,
                  color: Colors.white,
                ),
              ),
              title: Container(
                height: 16,
                color: Colors.white,
              ),
              subtitle: Container(
                height: 14,
                width: 80,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSuggestedProductsSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4, // Number of skeleton items
        itemBuilder: (context, index) {
          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: 12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Container(
                    height: 14,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Container(
                    height: 14,
                    width: 60,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
