import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/product_service.dart'; // Product + ProductService

// HomePage is now a StatefulWidget to manage state for infinite scrolling.
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductService _productService = ProductService();
  final List<Product> _products = [];
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  final int _pageSize = 10; // Number of products to fetch per page

  @override
  void initState() {
    super.initState();
    _loadProducts(); // Initial product load

    // Add a listener to the scroll controller to detect when the user reaches the end.
    _scrollController.addListener(() {
      // Check if we are at the bottom of the list and there are more products to load.
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading) {
        _loadProducts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController
        .dispose(); // Dispose the controller to prevent memory leaks
    super.dispose();
  }

  /// Loads products paginated.
  Future<void> _loadProducts() async {
    if (_isLoading || !_hasMore)
      return; // Don't load if already loading or no more products

    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch the next page of products.
      final newProducts = await _productService.loadProducts(
        limit: _pageSize,
        skip: _currentPage * _pageSize,
      );

      setState(() {
        if (newProducts.length < _pageSize) {
          _hasMore = false; // No more products to load
        }
        _products.addAll(newProducts);
        _currentPage++;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        // Optionally, show a snackbar or an error message
      });
      // Log or handle the error appropriately
      print("Error loading products: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      /// ==== AppBar ====
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        centerTitle: false,
        actions: [
          Row(
            children: [
              const Text(
                'My Cart',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                icon: Stack(
                  children: [
                    const Icon(Icons.shopping_cart, color: Colors.black),
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: const Text(
                          '8', // This should be dynamic based on cart state
                          style: TextStyle(color: Colors.white, fontSize: 8),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  context.push('/cart');
                },
              ),
            ],
          ),
        ],
      ),

      /// ==== Drawer ====
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF5B74FF), Color(0xFF2DE6AF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            Builder(
              builder: (context) {
                final user = FirebaseAuth.instance.currentUser;
                return user != null
                    ? ListTile(
                        leading: const Icon(Icons.person, color: Colors.blue),
                        title: Text(user.displayName ?? 'No Name'),
                        subtitle: Text(user.email ?? 'No Email'),
                      )
                    : const ListTile(
                        leading: Icon(Icons.person_off, color: Colors.grey),
                        title: Text('Not logged in'),
                      );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                context.go('/home');
              },
            ),
            const ListTile(
              leading: Icon(Icons.category),
              title: Text('Categories'),
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Wishlist'),
              onTap: () {
                context.push('/wishlist');
              },
            ),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                context.go('/');
              },
            ),
          ],
        ),
      ),

      /// ==== Body ====
      body: SingleChildScrollView(
        controller: _scrollController, // Attach the scroll controller
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Promo Carousel
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: FutureBuilder<List<String>>(
                future: _productService
                    .fetchPromotionImages(), // Fetch images from the service
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    ); // Show a loading indicator
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error loading promo images: ${snapshot.error}',
                      ),
                    ); // Show an error message
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No promo images found.'),
                    ); // Show a message if no images are available
                  } else {
                    final promoImages = snapshot.data!;
                    return CarouselSlider(
                      options: CarouselOptions(
                        height: 180.0,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration: const Duration(
                          milliseconds: 800,
                        ),
                        viewportFraction: 0.8,
                      ),
                      items: promoImages.map((url) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            url,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(Icons.error, color: Colors.red),
                              ); // Show error icon
                            },
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),

            /// Featured Products
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Featured Products',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), // GridView should not scroll independently
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.75,
                ),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return ProductCard(product: product);
                },
              ),
            ),

            // Loading indicator at the bottom
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              ),

            // Message when all products are loaded
            if (!_hasMore)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text("You've reached the end of the list."),
                ),
              ),

            const SizedBox(height: 16.0),
          ],
        ),
      ),

      /// ==== Floating Button (Search) ====
      floatingActionButton: SizedBox(
        width: 150,
        height: 150,
        child: RawMaterialButton(
          onPressed: () {
            context.push('/search');
          },
          elevation: 0,
          fillColor: Colors.transparent,
          shape: const CircleBorder(),
          child: Image.asset(
            "assets/images/Search.png",
            width: 140,
            height: 140,
            fit: BoxFit.contain,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

/// ==== Product Card ====
class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push('/productDetail', extra: product);
      },
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8.0),
                ),
                child: Image.network(
                  product.image.isNotEmpty
                      ? product.image
                      : "https://via.placeholder.com/150",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.error, color: Colors.red)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 14.0, color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
