enum MenuCategory { sandwich, fries, softDrink }

class MenuItem {
  final String id;
  final String name;
  final double price;
  final MenuCategory category;


  const MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category.name,
    };
  }

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      category: MenuCategory.values.firstWhere((e) => e.name == json['category']),
    );
  }
}

class MenuData {
  static const List<MenuItem> sandwiches = [
    MenuItem(
      id: '123',
      name: 'Burger',
      price: 5.00,
      category: MenuCategory.sandwich,
    ),
    MenuItem(
      id: '456',
      name: 'Egg',
      price: 4.50,
      category: MenuCategory.sandwich,
    ),
    MenuItem(
      id: '789',
      name: 'Bacon',
      price: 7.00,
      category: MenuCategory.sandwich,
    ),
  ];

  static const List<MenuItem> extras = [
    MenuItem(
      id: '111',
      name: 'Fries',
      price: 2.00,
      category: MenuCategory.fries,
    ),
    MenuItem(
      id: '222',
      name: 'Soft Drink',
      price: 2.50,
      category: MenuCategory.softDrink,
    ),
  ];

  static List<MenuItem> get allItems => [...sandwiches, ...extras];
}