import 'cart_item.dart';

class OrderItem {
  final String? id; // ID của đơn hàng (có thể null nếu chưa có)
  final double amount; // Tổng giá trị của đơn hàng
  final List<CartItem> products; // Danh sách sản phẩm trong đơn hàng
  final DateTime dateTime; // Ngày và giờ đặt hàng

  // Thuộc tính tính tổng số sản phẩm trong đơn hàng
  int get productCount {
    return products.length;
  }

  // Constructor chính
  OrderItem({
    this.id,
    required this.amount,
    required this.products,
    DateTime? dateTime,
  }) : dateTime = dateTime ?? DateTime.now();

  // Phương thức tạo bản sao của đối tượng với khả năng thay đổi các thuộc tính
  OrderItem copyWith({
    String? id,
    double? amount,
    List<CartItem>? products,
    DateTime? dateTime,
  }) {
    return OrderItem(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      products: products ?? this.products,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
