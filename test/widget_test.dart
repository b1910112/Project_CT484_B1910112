import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myshop/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    try {
      // Xây dựng ứng dụng của chúng ta và kích hoạt một frame.
      await tester.pumpWidget(const MyApp());

      // Xác minh rằng bộ đếm của chúng ta bắt đầu từ 0.
      expect(find.text('0'), findsOneWidget);
      expect(find.text('1'), findsNothing);

      // Nhấn vào biểu tượng '+' và kích hoạt một frame.
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Xác minh rằng bộ đếm của chúng ta đã tăng lên.
      expect(find.text('0'), findsNothing);
      expect(find.text('1'), findsOneWidget);
    } catch (e, stackTrace) {
      print('Ngoại lệ: $e');
      print('Đám Cháy: $stackTrace');
      rethrow; // Ném lại ngoại lệ để đảm bảo bài kiểm tra thất bại
    }
  });
}
