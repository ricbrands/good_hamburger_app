import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/cart_item.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<IncrementQuantity>(_onIncrementQuantity);
    on<DecrementQuantity>(_onDecrementQuantity);
    on<ClearCart>(_onClearCart);
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.items);
    final existingIndex = items.indexWhere(
      (item) => item.menuItem.id == event.item.id,
    );

    if (existingIndex >= 0) {
      items[existingIndex] = CartItem(
        menuItem: items[existingIndex].menuItem,
        quantity: items[existingIndex].quantity + 1,
      );
    } else {
      items.add(CartItem(menuItem: event.item));
    }

    emit(state.copyWith(items: items));
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    final items = state.items
        .where((item) => item.menuItem.id != event.itemId)
        .toList();
    emit(state.copyWith(items: items));
  }

  void _onIncrementQuantity(IncrementQuantity event, Emitter<CartState> emit) {
    final items = state.items.map((item) {
      if (item.menuItem.id == event.itemId) {
        return CartItem(
          menuItem: item.menuItem,
          quantity: item.quantity + 1,
        );
      }
      return item;
    }).toList();

    emit(state.copyWith(items: items));
  }

  void _onDecrementQuantity(DecrementQuantity event, Emitter<CartState> emit) {
    final items = <CartItem>[];

    for (final item in state.items) {
      if (item.menuItem.id == event.itemId) {
        if (item.quantity > 1) {
          items.add(CartItem(
            menuItem: item.menuItem,
            quantity: item.quantity - 1,
          ));
        }
        // If quantity is 1, don't add (effectively removes the item)
      } else {
        items.add(item);
      }
    }

    emit(state.copyWith(items: items));
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(const CartState());
  }

  /// Creates a deep copy of cart items for order placement
  List<CartItem> getItemsCopy() {
    return state.items
        .map((item) => CartItem(
              menuItem: item.menuItem,
              quantity: item.quantity,
            ))
        .toList();
  }
}
