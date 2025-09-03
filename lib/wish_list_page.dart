import 'package:flutter/material.dart';
import 'package:myapp/cart_service.dart';
import 'package:myapp/product_service.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shimmer/shimmer.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Wishlist')),
        body: const Center(child: Text("Please log in to view your wishlist.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Wishlist')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .collection("wishlist")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildWishlistSkeleton();
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Your wishlist is empty."));
          }

          final wishlistItems = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Product(
              id: data['id'] as int,
              title: data['title'] ?? '',
              price: (data['price'] as num).toDouble(),
              image: data['image'] ?? '',
              category: data['category'] ?? '',
              description: data['description'] ?? '',
              brand: data['brand'] ?? '',
              rating: (data['rating'] ?? 0).toDouble(),
              discountPercentage: (data['discountPercentage'] ?? 0).toDouble(),
            );
          }).toList();

          return ListView.builder(
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
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(user.uid)
                          .collection("wishlist")
                          .doc(product.id.toString())
                          .delete();
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildWishlistSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 6, // Display 5 skeleton items
        itemBuilder: (context, index) {
          return ListTile(
            leading: Container(
              width: 50,
              height: 50,
              color: Colors.white,
            ),
            title: Container(
              height: 16,
              color: Colors.white,
            ),
            subtitle: Container(
              margin: const EdgeInsets.only(top: 8.0),
              height: 14,
              width: 80,
              color: Colors.white,
            ),
            trailing: const Icon(Icons.delete, color: Colors.grey),
          );
        },
      ),
    );
  }
}
