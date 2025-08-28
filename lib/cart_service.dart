import 'product_service.dart';

class CartService {
  CartService._privateConstructor();
  static final CartService instance = CartService._privateConstructor();

  final List<Product> _cartItems = [];

  List<Product> get cartItems => _cartItems;

  void addToCart(Product product) {
    _cartItems.add(product);
  }

  void removeFromCart(Product product) {
    _cartItems.remove(product);
  }

  void clearCart() {
    _cartItems.clear();
  }
}
