// Import các gói cần thiết từ Flutter, provider và ProductDetailScreen
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'product_detail_screen.dart';
import 'products_manager.dart';

// SearchScreen là một StatelessWidget để hiển thị màn hình tìm kiếm sản phẩm
class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Thanh ứng dụng với trường tìm kiếm
      appBar: AppBar(
        title: TextField(
          onChanged: (query) {
            // Gọi phương thức tìm kiếm từ ProductsManager và cập nhật UI
            context.read<ProductsManager>().searchProducts(query);
          },
          decoration: InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
          ),
        ),
      ),
      // Phần thân màn hình sử dụng Consumer để lắng nghe thay đổi trong ProductsManager
      body: Consumer<ProductsManager>(
        builder: (context, productsManager, child) {
          // Kiểm tra nếu có kết quả tìm kiếm, hiển thị danh sách sản phẩm
          if (productsManager.searchResults.isNotEmpty) {
            return ListView.builder(
              itemCount: productsManager.searchResults.length,
              itemBuilder: (context, index) {
                final product = productsManager.searchResults[index];
                return ListTile(
                  title: Text(product.title),
                  onTap: () {
                    // Chuyển hướng đến màn hình chi tiết sản phẩm khi nhấp vào sản phẩm
                    Navigator.pushNamed(
                      context,
                      ProductDetailScreen.routeName,
                      arguments: product.id,
                    );
                  },
                  // Hiển thị các thông tin khác về sản phẩm nếu cần
                );
              },
            );
          } else {
            // Hiển thị thông báo khi không có kết quả tìm kiếm
            return Center(
              child: Text('No products found for the search query.'),
            );
          }
        },
      ),
    );
  }
}
