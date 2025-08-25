import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Corrected import path
import 'package:myapp/search_page.dart'; // Import the SearchPage

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shopping App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Handle shopping cart
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Categories'),
              onTap: () {
                // Handle categories
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Wishlist'),
              onTap: () {
                // Handle wishlist
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Handle settings
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        // Removed Stack and Positioned for persistent FloatingActionButton
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Promotional Carousel
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 180.0,
                      autoPlay: true, // Corrected autoPlay casing
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves
                          .fastOutSlowIn, // Corrected autoPlayCurve casing
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration: const Duration(
                        milliseconds: 800,
                      ), // Corrected autoPlayAnimationDuration casing
                      viewportFraction: 0.8,
                    ),
                    items: [1, 2, 3, 4, 5].map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(
                              context,
                            ).size.width, // Corrected width calculation
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: Text(
                                // Simplified child
                                'Promotion $i',
                                style: const TextStyle(fontSize: 16.0),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),

                // Product Grid
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 0.75,
                        ),
                    itemCount: 10, // Placeholder item count
                    itemBuilder: (context, index) {
                      // Simulate some flash sales or discounts
                      bool isFlashSale = index % 3 == 0;
                      bool hasDiscount = index % 4 == 0;

                      return ProductCard(
                        productName: 'Product ${index + 1}',
                        productPrice: '\$${(index + 1) * 10}',
                        imageUrl:
                            'https://via.placeholder.com/150', // Placeholder image
                        isFlashSale: isFlashSale,
                        hasDiscount: hasDiscount,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16.0), // Add some spacing at the bottom
              ],
            ),
            // Positioned(
            //   bottom: 16.0,
            //   left: 0,
            //   right: 0,
            //   child: Center(
            //     child: FloatingActionButton(
            //       onPressed: () {
            //         // Handle search button press
            //       },
            //       child: Image.asset('assets/images/Search.png'),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 150,
        height: 150,
        child: RawMaterialButton(
          onPressed: () {
            // Navigate to the SearchPage
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchPage()),
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

class ProductCard extends StatelessWidget {
  final String productName;
  final String productPrice;
  final String imageUrl;
  final bool isFlashSale;
  final bool hasDiscount;

  const ProductCard({
    Key? key,
    required this.productName,
    required this.productPrice,
    required this.imageUrl,
    this.isFlashSale = false,
    this.hasDiscount = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
                    imageUrl,
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
                if (hasDiscount &&
                    !isFlashSale) // Avoid showing both badges in the same corner
                  Positioned(
                    top: 8.0,
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
                        '-10%', // Placeholder discount percentage
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
                Text(
                  productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  productPrice,
                  style: TextStyle(fontSize: 12.0, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
