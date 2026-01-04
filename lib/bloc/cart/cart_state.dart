import 'package:equatable/equatable.dart';
import '../../models/cart_item.dart';
import '../../models/menu_item.dart';

class CartState extends Equatable {
  final List<CartItem> items;

  const CartState({this.items = const []});

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);

  bool get hasComboDiscount {
    final hasSandwich = items.any(
      (item) => item.menuItem.category == MenuCategory.sandwich,
    );
    final hasSoftDrink = items.any(
      (item) => item.menuItem.category == MenuCategory.softDrink,
    );
    return hasSandwich && hasSoftDrink;
  }

  double get discountAmount => hasComboDiscount ? subtotal * 0.20 : 0;

  double get total => subtotal - discountAmount;

  bool get isEmpty => items.isEmpty;

  CartState copyWith({List<CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items];
}

class ValidationFailure extends CartState {
  final String message;

  const ValidationFailure(this.message, {super.items});

  @override
  List<Object?> get props => [message, items];
}
