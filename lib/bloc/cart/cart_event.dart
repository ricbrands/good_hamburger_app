import 'package:equatable/equatable.dart';
import '../../models/menu_item.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddToCart extends CartEvent {
  final MenuItem item;

  const AddToCart(this.item);

  @override
  List<Object?> get props => [item.id];
}

class RemoveFromCart extends CartEvent {
  final String itemId;

  const RemoveFromCart(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class ClearCart extends CartEvent {
  const ClearCart();
}
