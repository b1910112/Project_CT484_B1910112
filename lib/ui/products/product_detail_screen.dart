// Import các gói cần thiết từ Flutter và model Product từ file khác
import 'package:flutter/material.dart';

import '../../models/product.dart';

// ProductDetailScreen là một StatelessWidget để hiển thị chi tiết sản phẩm
class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  // Hàm khởi tạo nhận một đối tượng Product
  const ProductDetailScreen(
    this.product, {
    super.key,
  });

  // Thuộc tính chứa thông tin về sản phẩm
  final Product product;

  // Hàm xây dựng giao diện người dùng
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Thanh ứng dụng với tiêu đề là tên sản phẩm
      appBar: AppBar(
        title: Text(product.title),
      ),
      // Nội dung của màn hình là một cột các thành phần hiển thị thông tin chi tiết sản phẩm
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Hình ảnh sản phẩm
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            // Giá sản phẩm
            Text(
              '\$${product.price}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // Mô tả sản phẩm
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                product.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
