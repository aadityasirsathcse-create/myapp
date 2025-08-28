import 'package:flutter/material.dart';
import 'product_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ProductService _productService = ProductService();
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<String> categories = ["All", "Electronics", "Fashion", "Home", "Toys"];
  String _selectedCategory = "All";

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

  void _filterSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts
            .where((p) =>
                p.name.toLowerCase().contains(query.toLowerCase()) ||
                p.category.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Precompute lists
    final flashSaleProducts =
        _allProducts.where((p) => p.flashSale == true).toList();
    final discountProducts =
        _allProducts.where((p) => p.discount == true).toList();
    final topProducts = discountProducts.isNotEmpty
        ? discountProducts.take(3).toList()
        : _allProducts.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Products"),
      ),
      body: _allProducts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // 🔎 Search Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: _filterSearch,
                      decoration: InputDecoration(
                        hintText: "Search...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),

                // 🏷 Categories
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: categories.map((cat) {
                        final isSelected = cat == _selectedCategory;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: ChoiceChip(
                            label: Text(cat),
                            selected: isSelected,
                            onSelected: (_) {
                              setState(() {
                                _selectedCategory = cat;
                                _filteredProducts = cat == "All"
                                    ? _allProducts
                                    : _allProducts
                                        .where((p) => p.category == cat)
                                        .toList();
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // ⚡ Flash Sale Section
                if (flashSaleProducts.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Text("Flash Sale",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          height: 210,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: flashSaleProducts.length,
                            itemBuilder: (context, index) {
                              return BulkDiscountProductCard(
                                product: flashSaleProducts[index],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                // 🏆 Top Products Section
                if (topProducts.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Text("Top Products",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          height: 210,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: topProducts.length,
                            itemBuilder: (context, index) {
                              return TopProductCard(
                                product: topProducts[index],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                // 🔍 Search Results Section
                SliverPadding(
                  padding: const EdgeInsets.all(12),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = _filteredProducts[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.network(
                                  product.image.isNotEmpty
                                      ? product.image
                                      : 'https://via.placeholder.com/150',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(product.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ),
                              Text("\$${product.price.toStringAsFixed(2)}"),
                            ],
                          ),
                        );
                      },
                      childCount: _filteredProducts.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.75,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

// ===================== Product Card Widgets =====================

class BulkDiscountProductCard extends StatelessWidget {
  final Product product;
  const BulkDiscountProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                product.image.isNotEmpty
                    ? product.image
                    : 'https://via.placeholder.com/150',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            if (product.originalPrice != null)
              Text("\$${product.originalPrice}",
                  style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey)),
            Text("\$${product.price.toStringAsFixed(2)}",
                style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}

class TopProductCard extends StatelessWidget {
  final Product product;
  const TopProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                product.image.isNotEmpty
                    ? product.image
                    : 'https://via.placeholder.com/150',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            Text("\$${product.price.toStringAsFixed(2)}"),
          ],
        ),
      ),
    );
  }
}
