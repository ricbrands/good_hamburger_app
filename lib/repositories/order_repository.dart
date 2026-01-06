import 'package:good_hamburger_app/core/exceptions.dart/app_exceptions.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

/// Abstract repository interface for order operations
abstract class OrderRepository {  
  Future<Result<List<Order>>> getOrders();

  Future<Result<Order>> saveOrder({
    required String customerName,
    required List<CartItem> items,
    required double subtotal,
    required double discount,
    required double total,
  });

  Future<Result<void>> clearOrders();
}
