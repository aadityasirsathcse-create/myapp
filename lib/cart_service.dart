import 'product_service.dart';

class CartService {
  CartService._privateConstructor();
  static final CartService instance = CartService._privateConstructor();

  final List<Product> _cartItems = [];
  final List<Product> _wishlistItems = [];

  List<Product> get cartItems => _cartItems;

  void addToCart(Product product) {
    _cartItems.add(product);
  }

  bool isInCart(Product product) {
    return _cartItems.contains(product);
  }

  void removeFromCart(Product product) {
    _cartItems.remove(product);
  }

  void clearCart() {
    _cartItems.clear();
  }

  List<Product> get wishlistItems => _wishlistItems;

  void addToWishlist(Product product) {
    _wishlistItems.add(product);
  }

  void removeFromWishlist(Product product) {
    _wishlistItems.remove(product);
  }
}
