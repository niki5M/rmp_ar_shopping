// // providers/order_history_provider.dart
// import 'package:flutter/material.dart';
// import '../profile/profile_screen.dart';
// import 'order.dart';
//
// class OrderHistoryProvider with ChangeNotifier {
//   final List<Order> _orders = [];
//
//   List<Order> get orders => List.unmodifiable(_orders);
//
//   void addOrder(Order order) {
//     if (order.address.isNotEmpty && order.cardNumber.isNotEmpty) {
//       _orders.insert(0, order); // Добавляем новый заказ в начало списка
//       notifyListeners();
//     }
//   }
//
// }
