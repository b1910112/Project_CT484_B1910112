class CartItem {
  final String id; // ID định danh cho mục giỏ hàng
  final String title; // Tên của mục trong giỏ hàng
  final int quantity; // Số lượng của mục trong giỏ hàng
  final double price; // Giá của mục

  // Constructor
  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });

  // Phương thức tạo bản sao của đối tượng với khả năng thay đổi các thuộc tính
  CartItem copyWith({
    String? id,
    String? title,
    int? quantity,
    double? price,
  }) {
    return CartItem(
      id: id ?? this.id,
      title: title ?? this.title,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }
}
