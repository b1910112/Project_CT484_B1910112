// Import các gói cần thiết từ Flutter và Dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import các mô hình và các màn hình khác
import '../../models/product.dart';
import '../screens.dart';

// Widget để hiển thị thông tin của một sản phẩm trong danh sách của người dùng
class UserProductListTile extends StatelessWidget {
  // Sản phẩm cần hiển thị thông tin
  final Product product;

  // Hàm khởi tạo nhận vào một sản phẩm
  const UserProductListTile(
    this.product, {
    Key? key,
  }) : super(key: key);

  // Hàm xây dựng giao diện người dùng
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: <Widget>[
            buildEditButton(context), // Button để chuyển đến màn hình chỉnh sửa sản phẩm
            buildDeleteButton(context), // Button để xóa sản phẩm
          ],
        ),
      ),
    );
  }

  // Widget để xây dựng button xóa sản phẩm
  Widget buildDeleteButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () {
        // Gọi phương thức xóa sản phẩm từ ProductsManager
        context.read<ProductsManager>().deleteProduct(product.id!);

        // Hiển thị thông báo Snackbar khi sản phẩm được xóa
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text(
                'Product deleted',
                textAlign: TextAlign.center,
              ),
            ),
          );
      },
      color: Theme.of(context).colorScheme.error,
    );
  }

  // Widget để xây dựng button chỉnh sửa sản phẩm
  Widget buildEditButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () {
        // Chuyển hướng đến màn hình chỉnh sửa sản phẩm khi nhấp vào button
        Navigator.of(context).pushNamed(
          EditProductScreen.routeName,
          arguments: product.id,
        );
      },
      color: Theme.of(context).primaryColor,
    );
  }
}
