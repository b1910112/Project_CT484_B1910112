// Import các gói cần thiết từ Flutter và Dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens.dart';
// Import các màn hình và widget khác
import '../shared/app_drawer.dart';
import 'user_product_list_tile.dart';

// Màn hình để hiển thị danh sách sản phẩm của người dùng
class UserProductsScreen extends StatelessWidget {
  // Tên đường dẫn của màn hình
  static const routeName = '/user-products';

  // Hàm khởi tạo
  const UserProductsScreen({Key? key});

  // Hàm xây dựng giao diện người dùng
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sản phẩm của bạn'),
        actions: <Widget>[
          buildAddButton(context), // Button để chuyển đến màn hình thêm mới sản phẩm
        ],
      ),
      drawer: const AppDrawer(), // Thanh điều hướng AppDrawer
      body: FutureBuilder(
        // Sử dụng FutureBuilder để xử lý việc tải dữ liệu sản phẩm
        future: context.read<ProductsManager>().fetchProducts(true),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Hiển thị indicator khi đang tải dữ liệu
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // Sử dụng RefreshIndicator để thực hiện làm mới danh sách sản phẩm
          return RefreshIndicator(
            onRefresh: () =>
                context.read<ProductsManager>().fetchProducts(true),
            child: buildUserProductListView(), // Hiển thị danh sách sản phẩm
          );
        },
      ),
    );
  }

  // Widget để hiển thị danh sách sản phẩm của người dùng
  Widget buildUserProductListView() {
    return Consumer<ProductsManager>(
      builder: (ctx, productsManager, child) {
        return ListView.builder(
          itemCount: productsManager.itemCount,
          itemBuilder: (ctx, i) => Column(
            children: [
              // Hiển thị mỗi sản phẩm trong danh sách sử dụng UserProductListTile
              UserProductListTile(
                productsManager.items[i],
              ),
              const Divider(), // Thêm đường ngăn cách giữa các sản phẩm
            ],
          ),
        );
      },
    );
  }

  // Widget để xây dựng button thêm mới sản phẩm
  Widget buildAddButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        // Chuyển hướng đến màn hình thêm mới sản phẩm khi nhấp vào button
        Navigator.of(context).pushNamed(
          EditProductScreen.routeName,
        );
      },
    );
  }
}
