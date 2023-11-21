import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'ui/screens.dart'; // Import các màn hình từ thư mục ui/screens.dart

// Hàm main chạy ứng dụng Flutter
Future<void> main() async {
  await dotenv.load(); // Load biến môi trường từ tệp .env
  runApp(const MyApp()); // Chạy ứng dụng Flutter của bạn bằng widget MyApp
}

// Widget chính của ứng dụng
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MultiProvider là một widget cha để cung cấp nhiều ChangeNotifierProvider
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider cho AuthManager
        ChangeNotifierProvider(
          create: (context) => AuthManager(),
        ),
        // ChangeNotifierProxyProvider cho ProductsManager
        ChangeNotifierProxyProvider<AuthManager, ProductsManager>(
          create: (ctx) => ProductsManager(),
          update: (ctx, authManager, productsManager) {
            productsManager!.authToken = authManager.authToken;
            return productsManager;
          },
        ),
        // ChangeNotifierProvider cho CartManager
        ChangeNotifierProvider(
          create: (ctx) => CartManager(),
        ),
        // ChangeNotifierProvider cho OrdersManager
        ChangeNotifierProvider(
          create: (ctx) => OrdersManager(),
        )
      ],
      child: Consumer<AuthManager>(
        builder: (ctx, authManager, child) {
          // MaterialApp là widget cung cấp khung chính cho ứng dụng
          return MaterialApp(
            title: 'MyShop', // Tiêu đề của ứng dụng
            debugShowCheckedModeBanner: false, // Tắt dấu chấm "Debug" trên màn hình
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white, // Màu nền của scaffold
              appBarTheme: AppBarTheme(
                color: Colors.green, // Màu của app bar
              ),
              fontFamily: 'Lato', // Font chữ mặc định
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.green, // Swatch màu chính
              ).copyWith(
                secondary: Colors.deepOrange, // Màu phụ
              ),
            ),
            home: authManager.isAuth
                ? const ProductsOverviewScreen()
                : FutureBuilder(
                    future: authManager.tryAutoLogin(),
                    builder: (ctx, snapshot) {
                      return snapshot.connectionState ==
                              ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen();
                    },
                  ),
            // Các routes của ứng dụng
            routes: {
              CartScreen.routeName: (ctx) => const CartScreen(),
              OrdersScreen.routeName: (ctx) => const OrdersScreen(),
              UserProductsScreen.routeName: (ctx) =>
                  const UserProductsScreen(),
            },
            // Hàm này được sử dụng để xử lý các routes không được xác định trước
            onGenerateRoute: (settings) {
              if (settings.name == ProductDetailScreen.routeName) {
                final productId = settings.arguments as String;
                return MaterialPageRoute(
                  builder: (ctx) {
                    return ProductDetailScreen(
                      ctx.read<ProductsManager>().findById(productId)!,
                    );
                  },
                );
              }
              if (settings.name == EditProductScreen.routeName) {
                final productId = settings.arguments as String?;
                return MaterialPageRoute(
                  builder: (ctx) {
                    return EditProductScreen(
                      productId != null
                          ? ctx.read<ProductsManager>().findById(productId)
                          : null,
                    );
                  },
                );
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
