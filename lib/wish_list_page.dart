import 'package:flutter/material.dart';
import 'package:myapp/cart_service.dart'; // Assuming CartService is in this file
import 'package:myapp/product_service.dart'; // Assuming Product and ProductService are in this file
import 'package:go_router/go_router.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wishlistItems = CartService.instance.wishlistItems;

    return Scaffold(
      appBar: AppBar(title: const Text('My Wishlist')),
      body: wishlistItems.isEmpty
          ? const Center(child: Text('Your wishlist is empty.'))
          : ListView.builder(
              itemCount: wishlistItems.length,
              itemBuilder: (context, index) {
                final product = wishlistItems[index];
                return InkWell(
                  onTap: () {
                    context.push('/productDetail', extra: product);
                  },
                  child: ListTile(
                    leading: Image.network(
                      product.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(product.title),
                    subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                  ),
                );
              },
            ),
    );
  }
}
