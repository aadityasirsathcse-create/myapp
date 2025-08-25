import 'package:flutter/material.dart';

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
    {'name': 'Sports', 'color': Color(0xFF2196F3), 'icon': Icons.directions_run},
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
            .where((product) =>
                product['name'].toString().toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

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
            controller: _searchController,
            onChanged: _filterSearch,
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
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              _filterSearch('');
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
                // Categories
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

                // Search Results
                const Text(
                  'Search Results',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12.0),

                _filteredProducts.isEmpty
                    ? const Text("No products found",
                        style: TextStyle(color: Colors.white))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = _filteredProducts[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: const Icon(Icons.shopping_bag),
                              title: Text(product['name']),
                              subtitle: Text("\$${product['price']}"),
                              onTap: () {
                                // Handle product click
                              },
                            ),
                          );
                        },
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

  const CategoryButton(
      {Key? key, required this.name, required this.color, required this.icon})
      : super(key: key);

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
          Text(name,
              style: const TextStyle(fontSize: 12.0, color: Colors.white)),
        ],
      ),
    );
  }
}
