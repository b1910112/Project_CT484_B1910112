import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../shared/app_drawer.dart';
import 'order_item_card.dart';
import 'order_manager.dart';

/// Màn hình hiển thị danh sách các đơn hàng đã đặt
class OrdersScreen extends StatelessWidget {
  /// Đường dẫn của màn hình
  static const routeName = '/orders';

  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context){
    print('building orders');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      // Thêm AppDrawer để hiển thị thanh điều hướng bên trái
      drawer: const AppDrawer(),
      body: Consumer<OrdersManager>(
        // Sử dụng Consumer để lắng nghe thay đổi trong OrdersManager
        builder: (ctx, ordersManager, child) {
          return ListView.builder(
            itemCount: ordersManager.orderCount,
            itemBuilder: (ctx, i) => OrderItemCard(ordersManager.orders[i]),
          );
        },
      ),
    );
  }
}
