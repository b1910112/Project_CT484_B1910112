// Import các gói cần thiết từ Flutter và provider
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import 'product_grid_tile.dart';
import 'products_manager.dart';

// ProductsGrid là một StatelessWidget để hiển thị danh sách sản phẩm dưới dạng lưới
class ProductsGrid extends StatelessWidget {
  // Thuộc tính để xác định liệu có hiển thị chỉ sản phẩm yêu thích hay tất cả sản phẩm
  final bool showFavorites;

  // Hàm khởi tạo, nhận vào một tham số showFavorites
  const ProductsGrid(this.showFavorites, {Key? key}) : super(key: key);

  // Hàm xây dựng giao diện người dùng
  @override
  Widget build(BuildContext context) {
    // Sử dụng context.select để lấy danh sách sản phẩm từ ProductsManager
    final products = context.select<ProductsManager, List<Product>>(
      (productsManager) => showFavorites
          ? productsManager.favoriteItems
          : productsManager.items,
    );

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length, // Số lượng phần tử trong danh sách sản phẩm
      itemBuilder: (ctx, i) {
        // Kiểm tra chỉ mục i để đảm bảo nó không vượt quá kích thước danh sách
        if (i < products.length) {
          // Trả về một widget ProductGridTile cho mỗi sản phẩm
          return ProductGridTile(products[i]);
        } else {
          // Xử lý trường hợp chỉ mục không hợp lệ (nếu có)
          return SizedBox(); // Hoặc bạn có thể trả về một widget rỗng
        }
      },
      // Định cấu trúc lưới với số cột là 2 và tỉ lệ chiều dài và chiều rộng
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
