// Import các gói cần thiết từ Flutter và Dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import các màn hình và các quản lý khác
import '../auth/auth_manager.dart';
import '../orders/orders_screen.dart';
import '../products/user_products_screen.dart';

// Widget để hiển thị thanh điều hướng của ứng dụng
class AppDrawer extends StatelessWidget {
  // Hàm khởi tạo
  const AppDrawer({Key? key});

  // Hàm xây dựng giao diện người dùng
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          // Phần đầu thanh điều hướng với tiêu đề "Hello friend!"
          AppBar(
            title: Text('Hello friend!'),
            automaticallyImplyLeading: false,
          ),
          const Divider(), // Dòng ngăn cách giữa phần đầu và các tùy chọn

          // Tùy chọn "Shop" để chuyển đến màn hình chính
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(), // Dòng ngăn cách giữa các tùy chọn

          // Tùy chọn "Orders" để chuyển đến màn hình đơn đặt hàng
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          const Divider(), // Dòng ngăn cách giữa các tùy chọn

          // Tùy chọn "Manage Products" để quản lý sản phẩm
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Manage Products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          const Divider(), // Dòng ngăn cách giữa các tùy chọn

          // Tùy chọn "Logout" để đăng xuất người dùng
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              // Đóng thanh điều hướng và chuyển đến trang chủ
              Navigator.of(context)
                ..pop()
                ..pushReplacementNamed('/');
              
              // Gọi phương thức đăng xuất từ AuthManager
              context.read<AuthManager>().logout();
            },
          ),
        ],
      ),
    );
  }
}
