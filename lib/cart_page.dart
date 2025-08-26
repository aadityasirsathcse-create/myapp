import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  // Dummy data for suggested products
  final List<Map<String, dynamic>> suggestedProducts = const [
    {
      'name': 'Stone Planter',
      'price': 16.00,
      'originalPrice': 30.00,
      'image':'https://images.pexels.com/photos/3394659/pexels-photo-3394659.jpeg', // Placeholder
    },
    {
      'name': 'Xiaomi Mi Airdots',
      'price': 30.00,
      'originalPrice': 50.00,
      'image':"https://images.pexels.com/photos/3394658/pexels-photo-3394658.jpeg",
    },
    {
      "name": "Drone Camera",
      'price': 99.00,
      'originalPrice': 180.00,
      'image':"https://images.pexels.com/photos/442587/pexels-photo-442587.jpeg", // Placeholder
    }
    // Add more dummy products as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  automaticallyImplyLeading: false, // disable default back button
  title: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      IconButton(
        icon: const Icon(
          Icons.arrow_back,
          size: 27, // 👈 increase arrow size (default is 24)
        ),
        onPressed: () {
          context.go('/home');
        },
      ),
      const Text(
        'My Cart',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    ],
  ),
  toolbarHeight: 70, // extra space for two rows
),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              // Empty Cart Image Placeholder
              Image.asset(
              'assets/images/illustration.png', // Placeholder image URL
                height: 200,
                width: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 1),
              const Text(
                'Nothing of interest lately?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Check out some great discounts below!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Suggested Products',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              // Suggested Products List Placeholder
              SizedBox(
                height: 200, // Adjust height as needed
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: suggestedProducts.length,
                  itemBuilder: (context, index) {
                    final product = suggestedProducts[index];
                    return Container(
                      width: 150, // Adjust width as needed
                      margin: const EdgeInsets.only(right: 12.0),
                      color: Colors.grey[200], // Placeholder color
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            product['image'],
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                          Text(product['name']),
                          Text('\$${product['price']}'),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              // Discover more products button with styling from login button
              ElevatedButton(
                onPressed: () {
                  context.go('/home');
                },
                style: ElevatedButton.styleFrom(
                 padding: const EdgeInsets.all(6.0), // Set padding to zero
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13), // Match login button gradient border radius
                  ),
                  backgroundColor: Colors.transparent, // Make button transparent
                  shadowColor: Colors.transparent, // Remove shadow
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5B74FF), Color(0xFF2DE6AF)], // Match login button gradient colors
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight, // Match login button gradient alignment
                    ),
                    borderRadius: BorderRadius.circular(13), // Match login button gradient border radius
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 13), // Match login button padding
                   width: double.infinity, // Match login button width
                    child: const Text(
                      'Discover more Products',
                      style: TextStyle(
                        fontSize: 18, // Match login button font size
                        color: Colors.white,
                      ),
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
}