import 'package:flutter/foundation.dart';

import '../../models/cart_item.dart';
import '../../models/product.dart';

/// Quản lý giỏ hàng
class CartManager with ChangeNotifier {
  /// Danh sách sản phẩm trong giỏ hàng, sử dụng [Product.id] làm key
  late Map<String, CartItem> _items = {};

  /// Số lượng sản phẩm trong giỏ hàng
  int get productCount {
    return _items.length;
  }

  /// Danh sách các [CartItem] trong giỏ hàng
  List<CartItem> get products {
    return _items.values.toList();
  }

  /// Danh sách các [MapEntry] của [CartItem] trong giỏ hàng
  Iterable<MapEntry<String, CartItem>> get productEntries {
    return {..._items}.entries;
  }

  /// Tổng giá trị của tất cả sản phẩm trong giỏ hàng
  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  /// Thêm một sản phẩm vào giỏ hàng
  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      // Nếu sản phẩm đã tồn tại trong giỏ hàng, tăng số lượng lên 1
      _items.update(
        product.id!,
        (existingCartItem) => existingCartItem.copyWith(
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      // Nếu sản phẩm chưa có trong giỏ hàng, thêm mới vào
      _items.putIfAbsent(
        product.id!,
        () => CartItem(
          id: 'c${DateTime.now().toIso8601String()}',
          title: product.title,
          price: product.price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  /// Giảm số lượng của một sản phẩm trong giỏ hàng
  void removeItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]?.quantity as num > 1) {
      // Nếu số lượng sản phẩm lớn hơn 1, giảm đi 1
      _items.update(
        productId,
        (existingCartItem) => existingCartItem.copyWith(
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      // Nếu số lượng là 1, xóa sản phẩm khỏi giỏ hàng
      _items.remove(productId);
    }
    notifyListeners();
  }

  /// Xóa một sản phẩm khỏi giỏ hàng
  void clearItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  /// Xóa toàn bộ sản phẩm khỏi giỏ hàng
  void clearAllItems() {
    _items = {};
    notifyListeners();
  }
}
