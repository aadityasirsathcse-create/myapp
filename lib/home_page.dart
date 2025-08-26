import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:myapp/search_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  final List<String> promoImages = const [
    "https://images.unsplash.com/photo-1512290923902-8a9f81dc236c", // fashion
    "https://images.unsplash.com/photo-1503602642458-232111445657", // shoes
    "https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f", // electronics
    "https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f", // gadgets
    "https://images.unsplash.com/photo-1505740420928-5e560c06d30e", // headphones
  ];

  final List<Map<String, dynamic>> products = const [
    {
      "name": "Wireless Headphones",
      "price": 59.99,
      "image":
          "https://images.pexels.com/photos/3394667/pexels-photo-3394667.jpeg",
      "flashSale": true,
      "discount": false,
    },
    {
      "name": "Smart Watch",
      "price": 129.99,
      "image":
          "https://images.pexels.com/photos/277394/pexels-photo-277394.jpeg",
      "flashSale": false,
      "discount": true,
    },
    {
      "name": "Running Shoes",
      "price": 89.99,
      "image": "https://images.pexels.com/photos/19090/pexels-photo.jpg",
      "flashSale": false,
      "discount": false,
    },
    {
      "name": "Leather Backpack",
      "price": 74.99,
      "image":
          "https://images.pexels.com/photos/322207/pexels-photo-322207.jpeg",
      "flashSale": true,
      "discount": false,
    },
    {
      "name": "Casual Sunglasses",
      "price": 25.99,
      "image": "https://images.pexels.com/photos/46710/pexels-photo-46710.jpeg",
      "flashSale": false,
      "discount": true,
    },
    {
      "name": "Gaming Laptop",
      "price": 999.99,
      "image": "https://images.pexels.com/photos/18105/pexels-photo.jpg",
      "flashSale": false,
      "discount": false,
    },
    {
      "name": "Bluetooth Speaker",
      "price": 39.99,
      "image":
          "https://images.pexels.com/photos/374870/pexels-photo-374870.jpeg",
      "flashSale": true,
      "discount": true,
    },
    {
      "name": "DSLR Camera",
      "price": 549.99,
      "image":
          'https://images.pexels.com/photos/404280/pexels-photo-404280.jpeg',
      "flashSale": false,
      "discount": true,
    },
    {
      "name": "Office Chair",
      "price": 199.99,
      "image":
          "https://images.pexels.com/photos/696407/pexels-photo-696407.jpeg",
      "flashSale": true,
      "discount": false,
    },
    {
      "name": "Fitness Dumbbells",
      "price": 45.99,
      "image":
          "https://images.pexels.com/photos/1552249/pexels-photo-1552249.jpeg",
      "flashSale": false,
      "discount": true,
    },
    {
      "name": "Electric Guitar",
      "price": 349.99,
      "image":
          "https://images.pexels.com/photos/164936/pexels-photo-164936.jpeg",
      "flashSale": true,
      "discount": false,
    },
    {
      "name": "Coffee Maker",
      "price": 89.99,
      "image":
          "https://images.pexels.com/photos/585750/pexels-photo-585750.jpeg",
      "flashSale": false,
      "discount": true,
    },
    {
      "name": "Mountain Bike",
      "price": 499.99,
      "image":
          "https://images.pexels.com/photos/276517/pexels-photo-276517.jpeg",
      "flashSale": true,
      "discount": false,
    },
    {
      "name": "Smartphone",
      "price": 699.99,
      "image":
          "https://images.pexels.com/photos/404280/pexels-photo-404280.jpeg",
      "flashSale": false,
      "discount": true,
    },
    {
      "name": "Wireless Keyboard",
      "price": 49.99,
      "image":
          "https://images.pexels.com/photos/205421/pexels-photo-205421.jpeg",
      "flashSale": true,
      "discount": false,
    },
    {
      "name": "Portable Power Bank",
      "price": 29.99,
      "image":
          "https://images.pexels.com/photos/4042800/pexels-photo-4042800.jpeg",
      "flashSale": true,
      "discount": true,
    },
    {
      "name": "4K Smart TV",
      "price": 899.99,
      "image":
          "https://images.pexels.com/photos/5721902/pexels-photo-5721902.jpeg",
      "flashSale": false,
      "discount": true,
    },
    {
      "name": "Noise Cancelling Earbuds",
      "price": 79.99,
      "image":
          "https://images.pexels.com/photos/3394658/pexels-photo-3394658.jpeg",
      "flashSale": true,
      "discount": false,
    },
    {
      "name": "Drone Camera",
      "price": 649.99,
      "image":
          "https://images.pexels.com/photos/442587/pexels-photo-442587.jpeg",
      "flashSale": true,
      "discount": true,
    },
    {
      "name": "Digital Alarm Clock",
      "price": 19.99,
      "image":
          'https://images.pexels.com/photos/3394659/pexels-photo-3394659.jpeg',
      "flashSale": false,
      "discount": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Set a light background color
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0, // Remove AppBar shadow
        leading: Builder(
          // Add a Builder to access the Scaffold context
          builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
              ), // Hamburger menu icon
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer
              },
            );
          },
        ),
        // title: const Align(
        //   alignment: Alignment.centerRight, // Move title to the right
        //   // child: Text(
        //   //   'My Cart',
        //   //   style: TextStyle(
        //   //     color: Colors.black,
        //   //     fontSize: 18, // smaller font size
        //   //     fontWeight: FontWeight.w500, // optional
        //   //   ),
        //   // ),
        // ),
        centerTitle: false,
        actions: [
          Row(
            children: [
              Text(
                'My Cart',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18, // smaller font size
                  fontWeight: FontWeight.w500, // optional
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
                          '8', // Notification badge count
                          style: TextStyle(color: Colors.white, fontSize: 8),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  // TODO: Implement shopping cart functionality
                },
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 85, 101, 251),
              Color.fromARGB(255, 107, 166, 248),
            ],
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
               onTap: () async {
                await FirebaseAuth.instance.signOut();
                context.go('/home');
              },
              ),
            const ListTile(
              leading: Icon(Icons.category),
              title: Text('Categories'),
            ),
            const ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Wishlist'),
            ),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
            ListTile(
              // Add Logout ListTile
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut(); // Sign out the user
                context.go('/'); // Navigate to the onboarding page
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Promotional Carousel
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 180.0,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  viewportFraction: 0.8,
                ),
                items: promoImages.map((url) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  );
                }).toList(),
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
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.75,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(product: product);
                },
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 150,
        height: 150,
        child: RawMaterialButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchPage(products: products),
              ),
            );
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

/// Product Card
class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final bool isFlashSale;
  final bool hasDiscount;

  const ProductCard({
    Key? key,
    required this.product,
    this.isFlashSale = false, // These might still be relevant if your product data has them
    this.hasDiscount = false, // and you want to display badges based on them.
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.go('/productDetail', extra: product);
      },
      child: Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8.0),
                  ),
                  child: Image.network(
                    product['image'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                if (isFlashSale)
                  Positioned(
                    top: 8.0,
                    left: 8.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6.0,
                        vertical: 2.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: const Text(
                        'Flash Sale',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (hasDiscount && !isFlashSale)
                  Positioned(
                    top: 8.0, // Keep this if you want discount badge
                    right: 8.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6.0,
                        vertical: 2.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: const Text(
                        '-10%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                Text( // Use product['name']
                  product['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  "\$${product['price'].toStringAsFixed(2)}", // formatted properly
                  style: TextStyle(fontSize: 12.0, color: Colors.grey[700]), // Assuming 'price' is a num
                ),
              ],
            ),
          ),
        ],
      ),
      )
    );
  }
}
