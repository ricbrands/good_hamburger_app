import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../bloc/cart/cart_state.dart';
import '../bloc/orders/orders_bloc.dart';
import '../bloc/orders/orders_event.dart';
import '../bloc/orders/orders_state.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrdersBloc, OrdersState>(
      listener: (context, state) {
        if (state.status == OrdersStatus.placed) {
          context.read<CartBloc>().add(const ClearCart());
          _showSuccessDialog(context);
        } else if (state.status == OrdersStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.errorMessage}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Checkout'),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, cartState) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Name',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Enter your name',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name to place the order';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Order Summary',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          ...cartState.items.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  children: [                                    
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.menuItem.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            'Qty: ${item.quantity}',
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '\$${item.totalPrice.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          const Divider(height: 32),
                          _buildPriceRow(
                            'Subtotal',
                            '\$${cartState.subtotal.toStringAsFixed(2)}',
                          ),
                          if (cartState.hasComboDiscount) ...[
                            const SizedBox(height: 8),
                            _buildPriceRow(
                              'Combo Discount (${cartState.discountPercentage}%)',
                              '-\$${cartState.discountAmount.toStringAsFixed(2)}',
                              isDiscount: true,
                            ),
                          ],
                          const Divider(height: 24),
                          _buildPriceRow(
                            'Total',
                            '\$${cartState.total.toStringAsFixed(2)}',
                            isTotal: true,
                            context: context,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (cartState.hasComboDiscount) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.savings, color: Colors.green.shade700),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'You\'re saving \$${cartState.discountAmount.toStringAsFixed(2)} with the combo deal!',
                              style: TextStyle(
                                color: Colors.green.shade800,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  BlocBuilder<OrdersBloc, OrdersState>(
                    builder: (context, ordersState) {
                      final isPlacing =
                          ordersState.status == OrdersStatus.placing;
                      return SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton(
                          onPressed: isPlacing
                              ? null
                              : () => _placeOrder(context, cartState),
                          child: isPlacing
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Place Order',
                                  style: TextStyle(fontSize: 18),
                                ),
                        ),
                      );
                    },
                  ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String value, {
    bool isDiscount = false,
    bool isTotal = false,
    BuildContext? context,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (isDiscount)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(
                  Icons.local_offer,
                  size: 16,
                  color: Colors.green.shade700,
                ),
              ),
            Text(
              label,
              style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                fontSize: isTotal ? 20 : 14,
                color: isDiscount ? Colors.green.shade700 : null,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            fontSize: isTotal ? 20 : 14,
            color: isDiscount
                ? Colors.green.shade700
                : isTotal
                    ? context?.let(
                        (c) => Theme.of(c).colorScheme.primary,
                      )
                    : null,
          ),
        ),
      ],
    );
  }

  void _placeOrder(BuildContext context, CartState cartState) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final cartBloc = context.read<CartBloc>();
    context.read<OrdersBloc>().add(PlaceOrder(
          customerName: _nameController.text.trim(),
          items: cartBloc.getItemsCopy(),
          subtotal: cartState.subtotal,
          discount: cartState.discountAmount,
          total: cartState.total,
        ));
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, color: Colors.green.shade700),
            ),
            const SizedBox(width: 12),
            const Text('Order Placed!'),
          ],
        ),
        content: const Text(
          'Thank you for your order! Your delicious food will be ready soon.',
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Back to Menu'),
          ),
        ],
      ),
    );
  }
}

extension Let<T> on T {
  R let<R>(R Function(T) block) => block(this);
}
