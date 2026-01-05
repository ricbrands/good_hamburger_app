import 'package:equatable/equatable.dart';
import '../../models/order.dart';

enum OrdersStatus { initial, loading, loaded, placing, placed, error }

class OrdersState extends Equatable {
  final List<Order> orders;
  final OrdersStatus status;
  final String? errorMessage;
  final String? errorCode;

  const OrdersState({
    this.orders = const [],
    this.status = OrdersStatus.initial,
    this.errorMessage,
    this.errorCode,
  });

  bool get isEmpty => orders.isEmpty;
  bool get hasError => status == OrdersStatus.error;
  bool get isLoading => status == OrdersStatus.loading;
  bool get isPlacing => status == OrdersStatus.placing;

  OrdersState copyWith({
    List<Order>? orders,
    OrdersStatus? status,
    String? errorMessage,
    String? errorCode,
    bool clearError = false,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      errorCode: clearError ? null : (errorCode ?? this.errorCode),
    );
  }

  @override
  List<Object?> get props => [orders, status, errorMessage, errorCode];
}
