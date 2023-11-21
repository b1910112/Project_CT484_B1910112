import 'package:flutter/material.dart';

// Widget SplashScreen
class SplashScreen extends StatelessWidget {
  // Hàm khởi tạo
  const SplashScreen({Key? key});

  // Hàm xây dựng giao diện người dùng
  @override
  Widget build(BuildContext context) {
    // Scaffold là một cái khung chứa cơ bản cho ứng dụng Flutter
    return const Scaffold(
      // Body của Scaffold, nơi bạn đặt nội dung chính của màn hình
      body: Center(
        // Widget Center giúp căn giữa phần tử con của nó
        child: Text('Loading...'), // Hiển thị văn bản "Loading..."
      ),
    );
  }
}
