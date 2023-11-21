import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/cart_item.dart';
import '../../models/order_item.dart';

/// Quản lý danh sách các đơn hàng của người dùng
class OrdersManager with ChangeNotifier {
  // Danh sách các đơn hàng
  final List<OrderItem> _orders = [];

  /// Lấy số lượng đơn hàng
  int get orderCount{
    return _orders.length;
  }

  /// Lấy danh sách đơn hàng
  List<OrderItem> get orders {
    return [..._orders];
  }
  
  /// Thêm một đơn hàng mới vào danh sách
  void addOrder(List<CartItem> cartProducts, double total) async {
    _orders.insert(
      0,
      OrderItem(
        id: 'o${DateTime.now().toIso8601String()}',
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now(),
      ),
    );
    // Thông báo cho các người nghe (listeners) biết về sự thay đổi trong danh sách
    notifyListeners();
  }
}
