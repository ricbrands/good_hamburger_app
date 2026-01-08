import 'dart:convert';
import 'package:flutter/services.dart';

enum MenuCategory { sandwich, fries, softDrink }

class MenuItem {
  final String id;
  final String name;
  final double price;
  final MenuCategory category;
  final String image;

  const MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category.name,
      'image': image,
    };
  }

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      category: MenuCategory.values.firstWhere((e) => e.name == json['category']),
      image: json['image'],
    );
  }
}

class MenuData {
  static List<MenuItem> _sandwiches = [];
  static List<MenuItem> _extras = [];
  static bool _isLoaded = false;

  static List<MenuItem> get sandwiches => _sandwiches;
  static List<MenuItem> get extras => _extras;
  static List<MenuItem> get allItems => [..._sandwiches, ..._extras];
  static bool get isLoaded => _isLoaded;

  static Future<void> loadMenuItems() async {
    if (_isLoaded) return;

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final jsonString = await rootBundle.loadString('assets/menu_items.json');
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;

    _sandwiches = (jsonData['sandwiches'] as List)
        .map((item) => MenuItem.fromJson(item))
        .toList();

    _extras = (jsonData['extras'] as List)
        .map((item) => MenuItem.fromJson(item))
        .toList();

    _isLoaded = true;
  }
}