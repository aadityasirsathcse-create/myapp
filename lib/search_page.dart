import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends StatefulWidget {
  final List<Map<String, dynamic>> products;

  const SearchPage({Key? key, required this.products}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredProducts = [];

  // Sample categories (you can extend this)
  final List<Map<String, dynamic>> categories = [
    {'name': 'Beauty', 'color': Color(0xFFFE6EA1), 'icon': Icons.face},
    {'name': 'Gadgets', 'color': Color(0xFFFFD700), 'icon': Icons.lightbulb},
    {'name': 'Games', 'color': Color(0xFF4CAF50), 'icon': Icons.sports_esports},
    {'name': 'Dine', 'color': Color(0xFFF44336), 'icon': Icons.restaurant},
    {
      'name': 'Sports',
      'color': Color(0xFF2196F3),
      'icon': Icons.directions_run,
    },
  ];

  // Sample data for sections
  final List<Map<String, dynamic>> bulkDiscountProducts = [
      {
    'name': 'Samsung Galaxy S10',
    'price': 860.00,
    'originalPrice': 1000.00,
    'image': 'https://images.pexels.com/photos/404280/pexels-photo-404280.jpeg',
    'featured': true,
  },
  {
    'name': 'Stone Plant',
    'price': 16.00,
    'originalPrice': 30.00,
    'image': 'https://images.pexels.com/photos/5699661/pexels-photo-5699661.jpeg',
    'featured': false,
  },
  {
    'name': 'Xiaomi Mi Airdots',
    'price': 30.00,
    'originalPrice': 50.00,
    'image': 'https://images.pexels.com/photos/3394659/pexels-photo-3394659.jpeg',
    'featured': false,
  },
];

final List<Map<String, dynamic>> topProducts = [
  {
    'name': 'Scent Tray',
    'price': 68.00,
    'description':
        'Features an elegant black dish to capture the falling ash that captures the',
    'image': 'https://images.pexels.com/photos/4790082/pexels-photo-4790082.jpeg',
  },
  {
    'name': 'Fidget Spinner',
    'price': 10.00,
    'description': 'A classic stress reliever for all ages.',
    'image': 'https://images.pexels.com/photos/3394659/pexels-photo-3394659.jpeg',
  },
    {
    'name': 'Scent Tray',
    'price': 68.00,
    'description':
        'Features an elegant black dish to capture the falling ash that captures the',
    'image': 'https://images.pexels.com/photos/5699661/pexels-photo-5699661.jpeg',
  },
  ];

  @override
  void initState() {
    super.initState();
    _filteredProducts = widget.products; // show all initially
  }

  void _filterSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = widget.products;
      } else {
        _filteredProducts = widget.products
            .where(
              (product) => product['name'].toString().toLowerCase().contains(
                query.toLowerCase(),
              ),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar:
          true, // Extend body behind the app bar for gradient
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0, // Remove default title spacing
        title: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: _filterSearch,
            decoration: InputDecoration(
              hintText: 'Search for a Product',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  _searchController.clear();
                  _filterSearch('');
                },
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15.0,
                horizontal: 10.0,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // TODO: Implement more options
            },
          ),
          const SizedBox(width: 16.0), // Add some spacing
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 85, 101, 251),Color.fromARGB(255, 107, 166, 248)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          // Add SafeArea to avoid status bar overlap
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categories
                  const SizedBox(height: 16.0), // Add spacing after app bar
                  SizedBox(
                    height: 90, // Increased height to accommodate text and icon
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return CategoryButton(
                          name: categories[index]['name'],
                          color: categories[index]['color'],
                          icon: categories[index]['icon'],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24.0),

                  // Bulk Discounts
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Bulk Discounts!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Implement view all action
                        },
                        child: const Text(
                          'View All',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  SizedBox(
                    height: 210, // Adjust height as needed
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: bulkDiscountProducts.length,
                      itemBuilder: (context, index) {
                        final product = bulkDiscountProducts[index];
                        return BulkDiscountProductCard(product: product);
                      },
                    ),
                  ),

                  const SizedBox(height: 24.0),

                  // Top Products in March
                  const Text(
                    'Top Products in March',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: topProducts.length,
                    itemBuilder: (context, index) {
                      final product = topProducts[index];
                      return TopProductCard(index: index + 1, product: product);
                    },
                  ),

                  // You can add a section for search results here if needed,
                  // or integrate _filteredProducts into the existing sections
                  // based on how you want the search to interact with the design.
                  // For now, the existing search results are not explicitly shown
                  // in a separate section based on the image.
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String name;
  final Color color;
  final IconData icon;

  const CategoryButton({
    Key? key,
    required this.name,
    required this.color,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30, // Slightly larger radius
            backgroundColor: Colors.white, // White background for icon
            child: Icon(
              icon,
              color: color,
              size: 30,
            ), // Icon with category color
          ),
          const SizedBox(height: 8.0), // Increased spacing
          Text(
            name,
            style: const TextStyle(fontSize: 12.0, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class BulkDiscountProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const BulkDiscountProductCard({Key? key, required this.product})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160, // Adjust width as needed
      margin: const EdgeInsets.only(right: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
  child: Image.network(
    product['image'] ??
        'https://via.placeholder.com/150', // Fallback placeholder
    height: 100,
    width: double.infinity,
    fit: BoxFit.cover,
  ),
),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product['featured'] ==
                    true) // Display "Featured" if applicable
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Featured',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  product['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'USD ${product['price'].toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                if (product['originalPrice'] != null)
                  Text(
                    'USD ${product['originalPrice'].toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      decoration: TextDecoration.lineThrough,
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

class TopProductCard extends StatelessWidget {
  final int index;
  final Map<String, dynamic> product;

  const TopProductCard({Key? key, required this.index, required this.product})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  index.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12.0),
            ClipRRect(
  borderRadius: BorderRadius.circular(8),
  child: Image.network(
    product['image'] ??
        'https://via.placeholder.com/150', // Fallback placeholder
    height: 80,
    width: 80,
    fit: BoxFit.cover,
  ),
),

            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product['description'] ??
                        '', // Use empty string if description is null
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'USD ${product['price'].toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
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
