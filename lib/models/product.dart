import 'package:flutter/foundation.dart';

class Product {
  final String? id; // ID của sản phẩm (có thể null nếu chưa có)
  final String title; // Tên của sản phẩm
  final String description; // Mô tả của sản phẩm
  final double price; // Giá của sản phẩm
  final String imageUrl; // URL hình ảnh của sản phẩm
  final ValueNotifier<bool> _isFavorite; // Trạng thái ưa thích của sản phẩm

  // Constructor chính
  Product({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    isFavorite = false,
  }) : _isFavorite = ValueNotifier(isFavorite);

  // Phương thức setter để cập nhật trạng thái ưa thích
  set isFavorite(bool newValue) {
    _isFavorite.value = newValue;
  }

  // Phương thức getter để lấy trạng thái ưa thích
  bool get isFavorite {
    return _isFavorite.value;
  }

  // Phương thức getter để lấy đối tượng Listenable để theo dõi sự thay đổi trạng thái ưa thích
  ValueNotifier<bool> get isFavoriteListenable {
    return _isFavorite;
  }

  // Phương thức tạo bản sao của đối tượng với khả năng thay đổi các thuộc tính
  Product copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? imageUrl,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  // Chuyển đối tượng thành dạng JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  // Tạo đối tượng từ dữ liệu JSON
  static Product fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      imageUrl: json['imageUrl'],
    );
  }
}
