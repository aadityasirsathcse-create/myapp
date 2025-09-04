
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/add_product_page.dart';
import 'package:myapp/address_page.dart';
import 'package:myapp/cart_page.dart';
import 'package:myapp/check_out_page.dart';
import 'package:myapp/home_page.dart';
import 'package:myapp/notification_service.dart';
import 'package:myapp/onboarding_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/product_service.dart';
import 'package:myapp/search_page.dart';
import 'package:myapp/shipping_payment_page.dart';
import 'package:myapp/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/login_page.dart';
import 'package:myapp/wish_list_page.dart';
import 'firebase_options.dart';
import 'package:myapp/product_detail_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Must be a top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  log("Handling a background message: ${message.messageId}");
  log("Message data: ${message.data}");
  log("Message notification: ${message.notification?.title}");
}

// Create a new instance of FlutterLocalNotificationsPlugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Create a new AndroidNotificationChannel
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.', // description
  importance: Importance.high,
);


Future<void> initNotifications() async {
  final messaging = FirebaseMessaging.instance;
    final notificationService = NotificationService();
  await notificationService.init();
  // Request permission
  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  log('Permission granted: ${settings.authorizationStatus}');

  // Create the channel on the device
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // Initialize the plugin
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
      const InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (payload != null) {
      log('notification payload: $payload');
      // Navigate to product page
      final productService = ProductService();
      final product = await productService.getProductById(payload);
      if (product != null) {
        navigatorKey.currentContext?.go('/productDetail', extra: product);
      }
    }
  });

  // Get the token
  final fcmToken = await messaging.getToken();
  log('FCM Token: $fcmToken'); // This token is used to send notifications to this device

  // Handle background messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Handle foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log('Got a message whilst in the foreground!');
    log('Message data: ${message.data}');

    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      log('Message also contained a notification: ${message.notification}');
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: android.smallIcon,
          ),
        ),
                payload: message.data['productId'],

      );
    }
  });

   // Handle notification tap when app is in background
 FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    log('A new onMessageOpenedApp event was published!');
    final String? productId = message.data['productId'];
    if (productId != null) {
       final productService = ProductService();
      final product = await productService.getProductById(productId);
      if (product != null) {
        navigatorKey.currentContext?.go('/productDetail', extra: product);
      }
    }
  });

  // Handle notification tap when app is terminated
  messaging.getInitialMessage().then((RemoteMessage? message) async {
    if (message != null) {
       log('App was opened from a terminated state by a notification!');
       final String? productId = message.data['productId'];
        if (productId != null) {
          final productService = ProductService();
          final product = await productService.getProductById(productId);
          if (product != null) {
            navigatorKey.currentContext?.go('/productDetail', extra: product);
          }
        }
    }
  });
}


final _router = GoRouter(
    navigatorKey: navigatorKey, 
  routes: [
    GoRoute(path: '/', builder: (context, state) => const OnboardingPage()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/signup', builder: (context, state) => const SignUpPage()),
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    GoRoute(path: '/addproduct', builder: (context, state) => const AddProductPage()),
    GoRoute(
      path: '/productDetail',
      builder: (context, state) =>
          ProductDetailPage(product: state.extra as Product),
    ),
        GoRoute(
        path: '/shippingPayment',
        builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        final shippingAddress = extra['shippingAddress'] as Address;
        final billingAddress = extra['billingAddress'] as Address;
        return ShippingPaymentPage(shippingAddress: shippingAddress, billingAddress: billingAddress,);
        }),
    GoRoute(
      path: '/checkout',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        final product = extra['product'] as Product;
        final quantity = extra['quantity'] as int;
        return CheckoutPage(price: product.price, quantity: quantity, discountPercentage: product.discountPercentage,);
      }
    ),
    GoRoute(path: '/cart', builder: (context, state) => const CartPage()),
    GoRoute(path: '/search', builder: (context, state) => const SearchPage()),
    GoRoute(
      path: '/wishlist',
      builder: (context, state) => const WishlistPage(),
    ),
  ],
  initialLocation: FirebaseAuth.instance.currentUser != null ? '/home' : '/',
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Shopping',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}
