import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_hamburger_app/bloc/cart/cart_bloc.dart';
import 'package:good_hamburger_app/bloc/cart/cart_event.dart';
import 'package:good_hamburger_app/bloc/cart/cart_state.dart';
import 'package:good_hamburger_app/models/menu_item.dart';
import 'package:good_hamburger_app/view/widgets/category_chips.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {
        if (state is ValidationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade700,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Good Hamburger'),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: SafeArea(
            child: Column(
              children: [
                const CategoryChips(),
                const SizedBox(height: 24),
                _buildProductsSection(
                  context,
                  items: MenuData.allItems,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductsSection(
    BuildContext context, {
    required List<MenuItem> items,
  }){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [        
        const SizedBox(height: 12),
        ...items.map((item) => _MenuItemCard(item: item)),
      ],
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final MenuItem item;

  const _MenuItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _addToCart(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),                    
                    const SizedBox(height: 8),
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              FilledButton.tonal(
                onPressed: () => _addToCart(context),
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addToCart(BuildContext context) {
    final previousItemCount = context.read<CartBloc>().state.itemCount;
    context.read<CartBloc>().add(AddToCart(item));

    Future.microtask(() {
      if (!context.mounted) return;
      final currentState = context.read<CartBloc>().state;
      if (currentState is! ValidationFailure &&
          currentState.itemCount > previousItemCount) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.name} added to cart'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }
}