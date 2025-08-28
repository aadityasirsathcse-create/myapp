import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'product_service.dart'; // Your Product + ProductService

enum SearchState { initial, searching, results }

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ProductService _productService = ProductService();
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<String> categories = [
    "All",
    "Electronics",
    "Fashion",
    "Footwear",
    "Accessories",
    "Home & Garden",
    "Sports & Fitness",
    "Beauty",
    "Musical Instruments",
    "Home Appliances",
  ];

  String _selectedCategory = "All";
  SearchState _currentState = SearchState.initial;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await _productService.loadProducts();
    setState(() {
      _allProducts = products;
      _filteredProducts = products;
    });
  }

  void _onSearchTap() {
    setState(() {
      _currentState = SearchState.searching;
    });
  }

  void _onBackTap() {
    if (_currentState == SearchState.searching ||
        _currentState == SearchState.results) {
      setState(() {
        _currentState = SearchState.initial;
        _filteredProducts = _allProducts;
      });
    } else {
      context.pop();
    }
  }

  void _filterSearch(String query) {
    setState(() {
      if (query.isNotEmpty) {
        _currentState = SearchState.results;
        _filteredProducts = _allProducts.where((p) {
          final matchesQuery = p.title.toLowerCase().contains(
            query.toLowerCase(),
          );
          final matchesCategory =
              _selectedCategory == "All" ||
              p.category.toLowerCase() == _selectedCategory.toLowerCase();
          return matchesQuery && matchesCategory;
        }).toList();
      } else {
        // ✅ Show products filtered by category when no query
        _currentState = SearchState.results;
        _filteredProducts = _allProducts.where((p) {
          return _selectedCategory == "All" ||
              p.category.toLowerCase() == _selectedCategory.toLowerCase();
        }).toList();
      }
    });
  }

  void _openCategoryFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          children: categories.map((category) {
            return ListTile(
              title: Text(category),
              trailing: _selectedCategory == category
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
                _filterSearch(""); // ✅ reapply with current filter
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 105,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _onBackTap,
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF5B74FF), Color(0xFF2DE6AF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            onTap: _onSearchTap,
            onChanged: _filterSearch,
            decoration: const InputDecoration(
              hintText: "Search for a Product",
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 12,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: _openCategoryFilter,
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (_allProducts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            switch (_currentState) {
              case SearchState.initial:
                return _buildInitialState();
              case SearchState.searching:
                return _buildSearchingState();
              case SearchState.results:
                return _buildResultsState();
            }
          }
        },
      ),
    );
  }

  Widget _buildInitialState() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: categories.map((cat) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: _selectedCategory == cat,
                    onSelected: (_) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                      _filterSearch("");
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchingState() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Search History",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            children: [
              "Nike React Flykit",
              "Bose Headphones",
              "iPhone XR",
            ].map((chipText) => Chip(label: Text(chipText))).toList(),
          ),
          const SizedBox(height: 16),
          const Text(
            "Trending Searches",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            children: ["FILA Sweater", "Messenger Bags", "Surface Pro"]
                .map(
                  (chipText) => Chip(
                    label: Text(chipText),
                    backgroundColor: Colors.blue.shade100,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsState() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Sort By: Popularity",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: _openCategoryFilter,
                  child: Row(
                    children: [
                      const Icon(Icons.filter_list),
                      const SizedBox(width: 4),
                      Text(
                        _selectedCategory == "All"
                            ? "Filter"
                            : _selectedCategory,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(8),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              final product = _filteredProducts[index];
              return GestureDetector(
                onTap: () {
                  context.push('/productDetail', extra: product);
                },
                child: _buildProductCard(product),
              );
            }, childCount: _filteredProducts.length),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.7,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                product.image.isNotEmpty
                    ? product.image
                    : 'https://via.placeholder.com/150',
                fit: BoxFit.cover,
                width: double.infinity,
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "\$${product.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    ...List.generate(
                      5,
                      (index) => Icon(
                        Icons.star,
                        color: index < 4 ? Colors.amber : Colors.grey[300],
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text("(38)", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
