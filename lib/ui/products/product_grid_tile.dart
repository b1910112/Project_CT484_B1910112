// Import các gói cần thiết từ Flutter, provider, và model Product từ file khác
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../cart/cart_manager.dart';
import '../products/products_manager.dart';
import 'product_detail_screen.dart';

// ProductGridTile là một StatelessWidget để hiển thị một ô hiển thị sản phẩm trong danh sách
class ProductGridTile extends StatelessWidget {
  const ProductGridTile(
    this.product, {
    super.key,
  });
  final Product product;

  // Hàm xây dựng giao diện người dùng cho mỗi ô hiển thị sản phẩm
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: buildGridFooterBar(context),
        child: GestureDetector(
          onTap: () {
            // Khi người dùng nhấn vào hình ảnh, chuyển đến màn hình chi tiết sản phẩm
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  // Hàm xây dựng thanh footer cho mỗi ô hiển thị sản phẩm
  Widget buildGridFooterBar(BuildContext context) {
    return GridTileBar(
      backgroundColor: Colors.black87,
      // Nút ở góc trái để thêm/xóa sản phẩm yêu thích
      leading: ValueListenableBuilder<bool>(
        valueListenable: product.isFavoriteListenable,
        builder: (ctx, isFavorite, child) {
          return IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              // Khi người dùng nhấn nút, thay đổi trạng thái sản phẩm yêu thích
              ctx.read<ProductsManager>().toggleFavoriteStatus(product);
            },
          );
        },
      ),
      // Tiêu đề sản phẩm ở giữa
      title: Text(
        product.title,
        textAlign: TextAlign.center,
      ),
      // Nút ở góc phải để thêm sản phẩm vào giỏ hàng
      trailing: IconButton(
        icon: const Icon(
          Icons.shopping_cart,
        ),
        onPressed: () {
          // Khi người dùng nhấn nút, thêm sản phẩm vào giỏ hàng và hiển thị SnackBar
          final cart = context.read<CartManager>();
          cart.addItem(product);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: const Text(
                  'Item added to cart',
                ),
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    cart.removeItem(product.id!);
                  },
                ),
              ),
            );
        },
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
