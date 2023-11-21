import 'package:flutter/material.dart';
import 'package:myshop/ui/orders/order_manager.dart';
import 'package:provider/provider.dart';

import 'cart_item_card.dart';
import 'cart_manager.dart';

/// Màn hình hiển thị giỏ hàng
class CartScreen extends StatelessWidget {
  /// Đường dẫn đến màn hình giỏ hàng
  static const routeName = '/cart';

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context){
    // Lấy thông tin giỏ hàng từ CartManager
    final cart = context.watch<CartManager>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          // Hiển thị bảng tổng kết giỏ hàng
          buildCartSummary(cart, context),
          const SizedBox(height: 10),
          // Hiển thị danh sách sản phẩm trong giỏ hàng
          Expanded(
            child: buildCartDetails(cart),
          )
        ],
      ),
    );
  }

  /// Widget hiển thị danh sách sản phẩm trong giỏ hàng
  Widget buildCartDetails(CartManager cart){
    return ListView(
      children: cart.productEntries
      .map(
        (entry) => CartItemCard(
          productId: entry.key,
          cardItem: entry.value,
        ),
      )
      .toList(),
    );
  }

  /// Widget hiển thị bảng tổng kết giỏ hàng
  Widget buildCartSummary(CartManager cart, BuildContext context){
    return Card(
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              'Total',
              style: TextStyle(fontSize: 20),
            ),
            const Spacer(),
            // Hiển thị tổng giá trị giỏ hàng
            Chip(
              label: Text(
                '\$${cart.totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Theme.of(context).primaryTextTheme.titleLarge?.color,
                ),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            // Nút đặt hàng
            TextButton(
              onPressed: cart.totalAmount <= 0
              ? null
              : () {
                  // Thực hiện đặt hàng và xóa giỏ hàng
                  context.read<OrdersManager>().addOrder(
                    cart.products,
                    cart.totalAmount,
                  );
                  cart.clearAllItems();
              },
              style: TextButton.styleFrom(
                textStyle: TextStyle(color: Theme.of(context).primaryColor),
              ),
              child: const Text('ORDER NOW'),
            ),
          ],
        ),
      ),
    );
  }
}
