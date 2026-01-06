import 'package:equatable/equatable.dart';
import '../../models/cart_item.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrders extends OrdersEvent {
  const LoadOrders();
}

class PlaceOrder extends OrdersEvent {
  final String customerName;
  final List<CartItem> items;
  final double subtotal;
  final double discount;
  final double total;

  const PlaceOrder({
    required this.customerName,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.total,
  });

  @override
  List<Object?> get props => [customerName, items, subtotal, discount, total];
}

class ClearOrderHistory extends OrdersEvent {
  const ClearOrderHistory();
}
