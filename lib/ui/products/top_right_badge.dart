// Import các gói cần thiết từ Flutter
import 'package:flutter/material.dart';

// Widget TopRightBadge để thêm badge ở góc trên bên phải của một widget khác
class TopRightBadge extends StatelessWidget {
  // Hàm khởi tạo nhận vào child (widget cần thêm badge),
  // data (nội dung của badge), và color (màu sắc của badge)
  const TopRightBadge({
    Key? key,
    required this.child,
    required this.data,
    this.color,
  }) : super(key: key);

  // Widget con cần thêm badge
  final Widget child;

  // Dữ liệu của badge
  final Object data;

  // Màu sắc của badge (nếu không được cung cấp, sẽ sử dụng màu chủ đề)
  final Color? color;

  // Hàm xây dựng giao diện người dùng
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child, // Hiển thị widget con
        Positioned(
          right: 8, // Đặt vị trí của badge từ phía bên phải
          top: 8, // Đặt vị trí của badge từ phía trên
          child: Container(
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: color ?? Theme.of(context).colorScheme.secondary,
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              data.toString(), // Hiển thị nội dung của badge
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
