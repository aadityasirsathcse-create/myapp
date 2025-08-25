import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  // Sample data for categories (replace with your actual data)
  final List<Map<String, dynamic>> categories = [
    {'name': 'Beauty', 'color': const Color(0xFFFE6EA1), 'icon': Icons.face},
    {'name': 'Gadgets', 'color': const Color(0xFFFFD700), 'icon': Icons.lightbulb},
    {'name': 'Games', 'color': const Color(0xFF4CAF50), 'icon': Icons.sports_esports},
    {'name': 'Dine', 'color': const Color(0xFFF44336), 'icon': Icons.restaurant},
    {'name': 'Sports', 'color': const Color(0xFF2196F3), 'icon': Icons.directions_run},
    // Add more categories as needed
  ];

  SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search for a Product',
              prefixIcon: const Icon(Icons.search),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Handle more options
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A1B9A), Color(0xFFE1BEE7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16.0), // Space below AppBar
                SizedBox(
                  height: 80,
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
                        // Handle View All
                      },
                      child: const Text(
                        'View All',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                // Placeholder for Bulk Discounts
                Container(
                  height: 200, // Adjust height as needed
                  color: Colors.grey[300],
                  child: const Center(child: Text('Bulk Discounts Grid/List')),
                ),
                const SizedBox(height: 24.0),
                const Text(
                  'Top Products in March',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16.0),
                // Placeholder for Top Products in March
                Container(
                  height: 300, // Adjust height as needed
                  color: Colors.grey[300],
                  child: const Center(child: Text('Top Products List')),
                ),
              ],
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

  const CategoryButton({Key? key, required this.name, required this.color, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 4.0),
          Text(name, style: const TextStyle(fontSize: 12.0, color: Colors.white)),
        ],
      ),
    );
  }
}