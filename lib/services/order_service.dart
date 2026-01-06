import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order.dart';
import '../models/cart_item.dart';

class OrderService {
  static const String _ordersKey = 'orders';

  Future<List<Order>> getOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = prefs.getStringList(_ordersKey) ?? [];
    return ordersJson
        .map((json) => Order.fromJson(jsonDecode(json)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> saveOrder({
    required String customerName,
    required List<CartItem> items,
    required double subtotal,
    required double discount,
    required double total,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = prefs.getStringList(_ordersKey) ?? [];

    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      customerName: customerName,
      items: items,
      subtotal: subtotal,
      discount: discount,
      total: total,
      createdAt: DateTime.now(),
    );

    ordersJson.add(jsonEncode(order.toJson()));
    await prefs.setStringList(_ordersKey, ordersJson);
  }

  Future<void> clearOrders() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_ordersKey);
  }
}
