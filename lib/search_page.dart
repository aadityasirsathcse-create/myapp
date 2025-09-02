import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'product_service.dart';
import 'package:shimmer/shimmer.dart';

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
  List<String> categories = ["All"];
  List<String> brands = ["All"];

  String _selectedCategory = "All";
  String _selectedBrand = "All";
  double _minPrice = 0;
  double _maxPrice = 1000;
  double _minRating = 0;
  double _minDiscount = 0;

  SearchState _currentState = SearchState.initial;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await loadAllProducts();
    await _loadFilters();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadFilters() async {
    final fetchedCategories = await _productService.fetchCategories();
    final fetchedBrands = await _productService.fetchBrands();
    setState(() {
      categories = ["All", ...fetchedCategories];
      brands = ["All", ...fetchedBrands];
    });
  }

  Future<void> loadAllProducts() async {
    final products = await _productService.loadAllProducts();
    setState(() {
      _allProducts = products;
      _filteredProducts = products;
    });
  }

  void _applyFilters({String query = ""}) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      _currentState = SearchState.results;
      _filteredProducts = _allProducts.where((p) {
        final matchesQuery =
            query.isEmpty || p.title.toLowerCase().contains(lowerQuery);
        final matchesCategory = _selectedCategory == "All" ||
            p.category.toLowerCase() == _selectedCategory.toLowerCase();
        final matchesBrand = _selectedBrand == "All" ||
            p.brand.toLowerCase() == _selectedBrand.toLowerCase();
        final matchesPrice = p.price >= _minPrice && p.price <= _maxPrice;
        final matchesRating = p.rating >= _minRating;
        final matchesDiscount = p.discountPercentage >= _minDiscount;
        return matchesQuery &&
            matchesCategory &&
            matchesBrand &&
            matchesPrice &&
            matchesRating &&
            matchesDiscount;
      }).toList();
    });
  }

  void _onSearchChanged(String query) {
    _applyFilters(query: query);
  }

  void _openFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        "Filters",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        items: categories
                            .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)),
                            )
                            .toList(),
                        onChanged: (val) {
                          setModalState(() => _selectedCategory = val ?? "All");
                        },
                        decoration: const InputDecoration(
                          labelText: "Category",
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedBrand,
                        items: brands
                            .map(
                              (b) => DropdownMenuItem(value: b, child: Text(b)),
                            )
                            .toList(),
                        onChanged: (val) {
                          setModalState(() => _selectedBrand = val ?? "All");
                        },
                        decoration: const InputDecoration(labelText: "Brand"),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Price Range (\$${_minPrice.toInt()} - \$${_maxPrice.toInt()})",
                      ),
                      RangeSlider(
                        min: 0,
                        max: 5000,
                        divisions: 100,
                        values: RangeValues(_minPrice, _maxPrice),
                        onChanged: (range) {
                          setModalState(() {
                            _minPrice = range.start;
                            _maxPrice = range.end;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Text("Minimum Rating (${_minRating.toStringAsFixed(1)})"),
                      Slider(
                        min: 0,
                        max: 5,
                        divisions: 10,
                        value: _minRating,
                        onChanged: (val) =>
                            setModalState(() => _minRating = val),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Minimum Discount (${_minDiscount.toStringAsFixed(0)}%)",
                      ),
                      Slider(
                        min: 0,
                        max: 100,
                        divisions: 20,
                        value: _minDiscount,
                        onChanged: (val) =>
                            setModalState(() => _minDiscount = val),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          _applyFilters();
                          Navigator.pop(context);
                        },
                        child: const Text("Apply Filters"),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
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

  void _onSearchTap() {
    setState(() {
      _currentState = SearchState.searching;
    });
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
            onChanged: _onSearchChanged,
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
            onPressed: _openFilterModal,
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (_isLoading) {
            return _buildProductGridSkeleton();
          }
          switch (_currentState) {
            case SearchState.initial:
              return _buildInitialState();
            case SearchState.searching:
              return _buildSearchingState();
            case SearchState.results:
              return _buildResultsState();
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
                      _applyFilters();
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(8),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              final product = _filteredProducts[index];
              return GestureDetector(
                onTap: () => context.push('/productDetail', extra: product),
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
    return _filteredProducts.isEmpty
        ? const Center(child: Text('No products found'))
        : CustomScrollView(
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
                        onTap: _openFilterModal,
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
                      onTap: () => context.push('/productDetail', extra: product),
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
                        color: index < product.rating.round()
                            ? Colors.amber
                            : Colors.grey[300],
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "(${product.rating.toStringAsFixed(1)})",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGridSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.7,
        ),
        itemCount: 8,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 14.0,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4.0),
                      Container(
                        width: 50.0,
                        height: 14.0,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4.0),
                      Container(
                        width: 80.0,
                        height: 12.0,
                        color: Colors.white,
                      ),
                    ],
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
