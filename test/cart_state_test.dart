import 'package:flutter_test/flutter_test.dart';
import 'package:good_hamburger_app/bloc/cart/cart_state.dart';
import 'package:good_hamburger_app/models/cart_item.dart';
import 'package:good_hamburger_app/models/menu_item.dart';

void main() {
  group('CartState Discount Calculation', () {
    const sandwich = MenuItem(
      id: '1',
      name: 'Burger',
      price: 10.00,
      category: MenuCategory.sandwich,
      image: 'assets/images/burger.jpg',
    );

    const fries = MenuItem(
      id: '2',
      name: 'Fries',
      price: 5.00,
      category: MenuCategory.fries,
      image: 'assets/images/fries.jpg',
    );

    const softDrink = MenuItem(
      id: '3',
      name: 'Soft Drink',
      price: 5.00,
      category: MenuCategory.softDrink,
      image: 'assets/images/soft_drink.jpg',
    );

    group('discountPercentage', () {
      test('returns 0% when cart is empty', () {
        const state = CartState(items: []);

        expect(state.discountPercentage, 0);
        expect(state.hasComboDiscount, false);
      });

      test('returns 0% when only sandwich is in cart', () {
        final state = CartState(items: [
          CartItem(menuItem: sandwich),
        ]);

        expect(state.discountPercentage, 0);
        expect(state.hasComboDiscount, false);
      });

      test('returns 0% when only fries is in cart', () {
        final state = CartState(items: [
          CartItem(menuItem: fries),
        ]);

        expect(state.discountPercentage, 0);
        expect(state.hasComboDiscount, false);
      });

      test('returns 0% when only soft drink is in cart', () {
        final state = CartState(items: [
          CartItem(menuItem: softDrink),
        ]);

        expect(state.discountPercentage, 0);
        expect(state.hasComboDiscount, false);
      });

      test('returns 0% when fries and soft drink are in cart (no sandwich)', () {
        final state = CartState(items: [
          CartItem(menuItem: fries),
          CartItem(menuItem: softDrink),
        ]);

        expect(state.discountPercentage, 0);
        expect(state.hasComboDiscount, false);
      });

      test('returns 10% when sandwich and fries are in cart', () {
        final state = CartState(items: [
          CartItem(menuItem: sandwich),
          CartItem(menuItem: fries),
        ]);

        expect(state.discountPercentage, 10);
        expect(state.hasComboDiscount, true);
      });

      test('returns 15% when sandwich and soft drink are in cart', () {
        final state = CartState(items: [
          CartItem(menuItem: sandwich),
          CartItem(menuItem: softDrink),
        ]);

        expect(state.discountPercentage, 15);
        expect(state.hasComboDiscount, true);
      });

      test('returns 20% when sandwich, fries, and soft drink are in cart', () {
        final state = CartState(items: [
          CartItem(menuItem: sandwich),
          CartItem(menuItem: fries),
          CartItem(menuItem: softDrink),
        ]);

        expect(state.discountPercentage, 20);
        expect(state.hasComboDiscount, true);
      });
    });

    group('discountAmount', () {
      test('calculates 10% discount correctly', () {
        final state = CartState(items: [
          CartItem(menuItem: sandwich),
          CartItem(menuItem: fries),
        ]);

        expect(state.subtotal, 15.00);
        expect(state.discountAmount, 1.50);
      });

      test('calculates 15% discount correctly', () {
        final state = CartState(items: [
          CartItem(menuItem: sandwich),
          CartItem(menuItem: softDrink),
        ]);

        expect(state.subtotal, 15.00);
        expect(state.discountAmount, 2.25);
      });

      test('calculates 20% discount correctly', () {
        final state = CartState(items: [
          CartItem(menuItem: sandwich),
          CartItem(menuItem: fries),
          CartItem(menuItem: softDrink),
        ]);

        expect(state.subtotal, 20.00);
        expect(state.discountAmount, 4.00);
      });

      test('returns 0 discount when no combo', () {
        final state = CartState(items: [
          CartItem(menuItem: sandwich),
        ]);

        expect(state.subtotal, 10.00);
        expect(state.discountAmount, 0.00);
      });
    });

    group('total', () {
      test('calculates total with 10% discount', () {
        final state = CartState(items: [
          CartItem(menuItem: sandwich),
          CartItem(menuItem: fries),
        ]);

        expect(state.total, 13.50);
      });

      test('calculates total with 15% discount', () {
        final state = CartState(items: [
          CartItem(menuItem: sandwich),
          CartItem(menuItem: softDrink),
        ]);

        expect(state.total, 12.75);
      });

      test('calculates total with 20% discount', () {
        final state = CartState(items: [
          CartItem(menuItem: sandwich),
          CartItem(menuItem: fries),
          CartItem(menuItem: softDrink),
        ]);

        expect(state.total, 16.00);
      });

      test('total equals subtotal when no discount', () {
        final state = CartState(items: [
          CartItem(menuItem: sandwich),
        ]);

        expect(state.total, state.subtotal);
        expect(state.total, 10.00);
      });
    });
  });
}
