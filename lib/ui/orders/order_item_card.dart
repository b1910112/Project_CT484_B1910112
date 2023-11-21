import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/order_item.dart';

/// Widget hiển thị thông tin chi tiết của một đơn hàng
class OrderItemCard extends StatefulWidget {
  /// Đối tượng đơn hàng
  final OrderItem order;

  /// Constructor nhận vào một đối tượng đơn hàng
  const OrderItemCard(this.order, {super.key});

  @override
  State<OrderItemCard> createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<OrderItemCard> {
  // Trạng thái mở rộng hay thu gọn của đơn hàng
  var _expanded = false;

  @override
  Widget build(BuildContext context){
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          // Hiển thị thông tin tóm tắt của đơn hàng
          buildOrderSummary(),
          // Nếu được mở rộng thì hiển thị chi tiết sản phẩm
          if (_expanded) buildOrderDetails()
        ],
      ),
    );
  }

  /// Widget hiển thị chi tiết sản phẩm của đơn hàng
  Widget buildOrderDetails(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      // Chiều cao tối đa cho danh sách sản phẩm, giảm tránh quá cao
      height: min(widget.order.productCount * 20.0 + 10, 100),
      child: ListView(
        children: widget.order.products
        .map(
          (prod) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Tên sản phẩm
              Text(
                prod.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Số lượng và giá của sản phẩm
              Text(
                '${prod.quantity}x \$${prod.price}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              )
            ],
          ),
        )
        .toList(),
      ),
    );
  }

  /// Widget hiển thị thông tin tóm tắt của đơn hàng
  Widget buildOrderSummary(){
    return ListTile(
      // Tổng giá trị đơn hàng
      title: Text('\$${widget.order.amount}'),
      // Ngày và giờ đặt hàng
      subtitle: Text(
        DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
      ),
      // Nút mở rộng/thu gọn
      trailing: IconButton(
        icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
        onPressed: (){
          setState((){
            _expanded = !_expanded;
          });
        },
      ),
    );
  }
}
