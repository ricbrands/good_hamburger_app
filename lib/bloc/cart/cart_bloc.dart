import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/cart_item.dart';
import '../../models/menu_item.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<ClearCart>(_onClearCart);
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.items);
    final existingItem = items.where(
      (item) => item.menuItem.category == event.item.category,
    ).firstOrNull;

    if (existingItem != null) {
      final categoryName = _getCategoryDisplayName(event.item.category);
      emit(ValidationFailure(
        'You can only add one $categoryName per order.',
        items: items,
      ));
      return;
    }

    items.add(CartItem(menuItem: event.item));
    emit(state.copyWith(items: items));
  }

  String _getCategoryDisplayName(MenuCategory category) {
    switch (category) {
      case MenuCategory.sandwich:
        return 'sandwich';
      case MenuCategory.fries:
        return 'fries';
      case MenuCategory.softDrink:
        return 'soft drink';
    }
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    final items = state.items
        .where((item) => item.menuItem.id != event.itemId)
        .toList();
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
