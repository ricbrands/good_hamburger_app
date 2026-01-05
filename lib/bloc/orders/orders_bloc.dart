import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/order_repository.dart';
import 'orders_event.dart';
import 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrderRepository _orderRepository;

  OrdersBloc({required OrderRepository orderRepository})
      : _orderRepository = orderRepository,
        super(const OrdersState()) {
    on<LoadOrders>(_onLoadOrders);
    on<PlaceOrder>(_onPlaceOrder);
    on<ClearOrderHistory>(_onClearOrderHistory);
  }

  Future<void> _onLoadOrders(
    LoadOrders event,
    Emitter<OrdersState> emit,
  ) async {
    emit(state.copyWith(status: OrdersStatus.loading, clearError: true));

    final result = await _orderRepository.getOrders();

    result.fold(
      onSuccess: (orders) {
        emit(state.copyWith(
          orders: orders,
          status: OrdersStatus.loaded,
        ));
      },
      onFailure: (error) {
        emit(state.copyWith(
          status: OrdersStatus.error,
          errorMessage: error.message,
          errorCode: error.code,
        ));
      },
    );
  }

  Future<void> _onPlaceOrder(
    PlaceOrder event,
    Emitter<OrdersState> emit,
  ) async {
    emit(state.copyWith(status: OrdersStatus.placing, clearError: true));

    final result = await _orderRepository.saveOrder(
      items: event.items,
      subtotal: event.subtotal,
      discount: event.discount,
      total: event.total,
    );

    await result.fold(
      onSuccess: (order) async {
        // Reload orders to get updated list
        final ordersResult = await _orderRepository.getOrders();
        ordersResult.fold(
          onSuccess: (orders) {
            emit(state.copyWith(
              orders: orders,
              status: OrdersStatus.placed,
            ));
          },
          onFailure: (error) {
            // Order was placed but couldn't reload list
            emit(state.copyWith(
              status: OrdersStatus.placed,
            ));
          },
        );
      },
      onFailure: (error) {
        emit(state.copyWith(
          status: OrdersStatus.error,
          errorMessage: error.message,
          errorCode: error.code,
        ));
      },
    );
  }

  Future<void> _onClearOrderHistory(
    ClearOrderHistory event,
    Emitter<OrdersState> emit,
  ) async {
    emit(state.copyWith(clearError: true));

    final result = await _orderRepository.clearOrders();

    result.fold(
      onSuccess: (_) {
        emit(state.copyWith(
          orders: [],
          status: OrdersStatus.loaded,
        ));
      },
      onFailure: (error) {
        emit(state.copyWith(
          status: OrdersStatus.error,
          errorMessage: error.message,
          errorCode: error.code,
        ));
      },
    );
  }
}
