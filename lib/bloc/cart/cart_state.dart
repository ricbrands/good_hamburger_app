import 'package:equatable/equatable.dart';
import '../../models/cart_item.dart';
import '../../models/menu_item.dart';

class CartState extends Equatable {
  final List<CartItem> items;

  const CartState({this.items = const []});

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);

  bool get _hasSandwich => items.any(
        (item) => item.menuItem.category == MenuCategory.sandwich,
      );

  bool get _hasFries => items.any(
        (item) => item.menuItem.category == MenuCategory.fries,
      );

  bool get _hasSoftDrink => items.any(
        (item) => item.menuItem.category == MenuCategory.softDrink,
      );

  bool get hasComboDiscount => discountPercentage > 0;

  int get discountPercentage {
    if (_hasSandwich && _hasFries && _hasSoftDrink) {
      return 20;
    } else if (_hasSandwich && _hasSoftDrink) {
      return 15;
    } else if (_hasSandwich && _hasFries) {
      return 10;
    }
    return 0;
  }

  double get discountAmount => subtotal * (discountPercentage / 100);

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
