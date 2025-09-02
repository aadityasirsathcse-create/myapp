import 'dart:math';
import 'package:flutter/material.dart';
import 'package:myapp/product_service.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _imageController = TextEditingController();
  final _discountPercentageController = TextEditingController();
  final _brandController = TextEditingController();
  final _ratingController = TextEditingController();

  final ProductService _productService = ProductService();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _imageController.dispose();
    _discountPercentageController.dispose();
    _brandController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  /// Generate a random product ID (temporary until API/database handles IDs)
  int _generateRandomId() {
    return Random().nextInt(1000000); // generates an ID between 0 and 999999
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      final newProduct = Product(
        id: _generateRandomId(),
        title: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        category: _categoryController.text.trim(),
        image: _imageController.text.trim(),
        discountPercentage: double.parse(_discountPercentageController.text.trim()),
        brand: _brandController.text.trim(),
        rating: double.parse(_ratingController.text.trim()),
      );

      try {
        await _productService.addProduct(newProduct);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Product added successfully')),
        );

        _formKey.currentState!.reset();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Failed to add product: $e')),
        );
      } finally {
        if (mounted) setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter a product name' : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Product Description'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter a product description' : null,
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter a price';
                    if (double.tryParse(value) == null) return 'Please enter a valid number';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter a category' : null,
                ),
                TextFormField(
                  controller: _imageController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter an image URL';
                    if (!Uri.parse(value).isAbsolute) return 'Please enter a valid URL';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _discountPercentageController,
                  decoration: const InputDecoration(labelText: 'Discount Percentage'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter a discount percentage';
                    final discount = double.tryParse(value);
                    if (discount == null) return 'Please enter a valid number';
                    if (discount < 0 || discount > 100) return 'Discount must be between 0 and 100';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _brandController,
                  decoration: const InputDecoration(labelText: 'Brand'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter a brand' : null,
                ),
                TextFormField(
                  controller: _ratingController,
                  decoration: const InputDecoration(labelText: 'Rating'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter a rating';
                    final rating = double.tryParse(value);
                    if (rating == null) return 'Please enter a valid number';
                    if (rating < 0 || rating > 5) return 'Rating must be between 0 and 5';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Add Product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
