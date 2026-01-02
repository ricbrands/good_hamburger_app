import 'package:flutter/material.dart';
import 'package:good_hamburger_app/utils/app_textstyles.dart';

class CategoryChips extends StatefulWidget {
  const CategoryChips({super.key});

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  int selectedIndex = 0;
  final categories = [
    "All",
    "Sandwiches",
    "Extras"
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(
          categories.length,
          (index) => Padding(
            padding: EdgeInsets.only(right: 12),
            child: AnimatedContainer(duration: const Duration(microseconds: 300),
            curve: Curves.easeInOut,
            child: ChoiceChip(
              label: Text(
                categories[index],
                style: AppTextStyle.withColor(
                  selectedIndex == index
                  ? AppTextStyle.withWeight(AppTextStyle.bodySmall, FontWeight.w600)
                  : AppTextStyle.bodySmall,
                  selectedIndex == index ?
                  Colors.white : Colors.grey[600]!,
                ),
              ), 
              selected: selectedIndex == index,
              onSelected: (bool selected) {
                setState(() {
                  selectedIndex = selected ? index : selectedIndex;
                });
              },
              selectedColor: Theme.of(context).primaryColor,
              backgroundColor: Colors.grey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: selectedIndex == index ? 2 : 0,
              pressElevation: 0,
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8
              ),
              labelPadding: EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 1,
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              side: BorderSide(
                color: selectedIndex == index ? Colors.transparent : Colors.grey[300]!,
                width: 1,
              ),
            ),
          ),
        ),
      ),
    ),);
  }
}