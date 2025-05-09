// models/order.dart
import '../cart/cart_item.dart';

class Order {
  final String id;
  final DateTime date;
  final String status;
  final List<OrderItem> items;
  final double totalPrice;
  final String cardNumber;
  final String address;

  Order({
    required this.id,
    required this.date,
    required this.status,
    required this.items,
    required this.totalPrice,
    required this.cardNumber,
    required this.address,
  });
}
class OrderItem {
  final String title;
  final int quantity;

  OrderItem({
    required this.title,
    required this.quantity,
  });
}


