import 'cart_item.dart';

class Order {
  final String id;
  final String customerName;
  final List<CartItem> items;
  final double subtotal;
  final double discount;
  final double total;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.customerName,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerName': customerName,
        'items': items.map((item) => item.toJson()).toList(),
        'subtotal': subtotal,
        'discount': discount,
        'total': total,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'],
        customerName: json['customerName'] ?? '',
        items: (json['items'] as List)
            .map((item) => CartItem.fromJson(item))
            .toList(),
        subtotal: (json['subtotal'] as num).toDouble(),
        discount: (json['discount'] as num).toDouble(),
        total: (json['total'] as num).toDouble(),
        createdAt: DateTime.parse(json['createdAt']),
      );
}
