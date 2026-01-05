import 'dart:convert';
import 'package:good_hamburger_app/core/exceptions.dart/app_exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_item.dart';
import '../models/order.dart';
import 'order_repository.dart';

/// Implementation of OrderRepository using SharedPreferences
class OrderRepositoryImpl implements OrderRepository {
  static const String _ordersKey = 'orders';

  final Future<SharedPreferences> Function() _getPrefs;

  OrderRepositoryImpl({
    Future<SharedPreferences> Function()? getPrefs,
  }) : _getPrefs = getPrefs ?? SharedPreferences.getInstance;

  @override
  Future<Result<List<Order>>> getOrders() async {
    try {
      final prefs = await _getPrefs();
      final ordersJson = prefs.getStringList(_ordersKey) ?? [];

      final orders = ordersJson
          .map((json) => Order.fromJson(jsonDecode(json)))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return Result.success(orders);
    } catch (e) {
      return Result.failure(
        StorageException.readFailed(originalError: e),
      );
    }
  }

  @override
  Future<Result<Order>> saveOrder({
    required List<CartItem> items,
    required double subtotal,
    required double discount,
    required double total,
  }) async {
    if (items.isEmpty) {
      return Result.failure(OrderException.emptyCart());
    }

    try {
      final prefs = await _getPrefs();
      final ordersJson = prefs.getStringList(_ordersKey) ?? [];

      final order = Order(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        items: items,
        subtotal: subtotal,
        discount: discount,
        total: total,
        createdAt: DateTime.now(),
      );

      ordersJson.add(jsonEncode(order.toJson()));

      final success = await prefs.setStringList(_ordersKey, ordersJson);

      if (!success) {
        return Result.failure(
          StorageException.writeFailed(),
        );
      }

      return Result.success(order);
    } catch (e) {
      return Result.failure(
        OrderException.placementFailed(originalError: e),
      );
    }
  }

  @override
  Future<Result<void>> clearOrders() async {
    try {
      final prefs = await _getPrefs();
      final success = await prefs.remove(_ordersKey);

      if (!success) {
        // Key might not exist, which is fine
      }

      return Result.success(null);
    } catch (e) {
      return Result.failure(
        StorageException.deleteFailed(originalError: e),
      );
    }
  }
}
