import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/notification_service.dart';
import 'product_service.dart';

class CartService {
  CartService._privateConstructor();
  static final CartService instance = CartService._privateConstructor();

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
    final NotificationService _notificationService = NotificationService();

  String? get _userId => _auth.currentUser?.uid;

  /// -------------------- CART --------------------

  /// Adds a product to the cart with an initial quantity of 1.
  Future<void> addToCart(Product product) async {
    if (_userId == null) return;
    final cartItemData = product.toMap();
    cartItemData['quantity'] = 1; // Set initial quantity

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('cart')
        .doc(product.id.toString())
        .set(cartItemData);
    await _notificationService.showProductAddedNotification(product.title, product.id.toString());
  }

  /// Removes a product from the cart.
  Future<void> removeFromCart(Product product) async {
    if (_userId == null) return;
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('cart')
        .doc(product.id.toString())
        .delete();
  }

  /// Updates the quantity of a specific item in the cart.
  Future<void> updateCartItemQuantity(int productId, int quantity) async {
    if (_userId == null) return;
    if (quantity <= 0) {
      // If quantity is zero or less, remove the item.
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('cart')
          .doc(productId.toString())
          .delete();
    } else {
      // Otherwise, update the quantity.
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('cart')
          .doc(productId.toString())
          .update({'quantity': quantity});
    }
  }

  /// Gets a stream of products in the user's cart.
  Stream<List<Product>> getCartStream() {
    if (_userId == null) return const Stream.empty();
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('cart')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Product.fromMap(doc.data())).toList(),
        );
  }

  /// -------------------- WISHLIST --------------------

  /// Adds a product to the user's wishlist.
  Future<void> addToWishlist(Product product) async {
    if (_userId == null) return;
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('wishlist')
        .doc(product.id.toString())
        .set(product.toMap());
  }

  /// Removes a product from the user's wishlist.
  Future<void> removeFromWishlist(Product product) async {
    if (_userId == null) return;
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('wishlist')
        .doc(product.id.toString())
        .delete();
  }

  /// Gets a stream of products in the user's wishlist.
  Stream<List<Product>> getWishlistStream() {
    if (_userId == null) return const Stream.empty();
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('wishlist')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Product.fromMap(doc.data())).toList(),
        );
  }

  getQuantity(int id) {}
}
