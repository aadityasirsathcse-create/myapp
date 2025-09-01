import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'product_service.dart';

class CartService {
  CartService._privateConstructor();
  static final CartService instance = CartService._privateConstructor();

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  /// -------------------- CART --------------------

  Future<void> addToCart(Product product) async {
  if (_userId == null) return;
  await _firestore
      .collection('users')
      .doc(_userId)
      .collection('cart')
      .doc(product.id.toString()) // ✅ convert int to String
      .set(product.toMap());
}

Future<void> removeFromCart(Product product) async {
  if (_userId == null) return;
  await _firestore
      .collection('users')
      .doc(_userId)
      .collection('cart')
      .doc(product.id.toString()) // ✅ convert int to String
      .delete();
}


  Stream<List<Product>> getCartStream() {
    if (_userId == null) return const Stream.empty();
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('cart')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Product.fromMap(doc.data())).toList());
  }

  /// -------------------- WISHLIST --------------------

  Future<void> addToWishlist(Product product) async {
    if (_userId == null) return;
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('wishlist')
.doc(product.id.toString())
        .set(product.toMap());
  }

  Future<void> removeFromWishlist(Product product) async {
    if (_userId == null) return;
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('wishlist')
.doc(product.id.toString())
        .delete();
  }

  Stream<List<Product>> getWishlistStream() {
    if (_userId == null) return const Stream.empty();
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('wishlist')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Product.fromMap(doc.data())).toList());
  }
}
