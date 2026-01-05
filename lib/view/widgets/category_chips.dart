import 'package:flutter/material.dart';
import 'package:good_hamburger_app/utils/app_textstyles.dart';

enum FilterCategory { all, sandwiches, extras }

class CategoryChips extends StatefulWidget {
  final FilterCategory selectedCategory;
  final ValueChanged<FilterCategory> onCategorySelected;

  const CategoryChips({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  final categories = [
    (FilterCategory.all, "All"),
    (FilterCategory.sandwiches, "Sandwiches"),
    (FilterCategory.extras, "Extras"),
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: categories.map((category) {
          final (filterCategory, label) = category;
          final isSelected = widget.selectedCategory == filterCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: AnimatedContainer(
              duration: const Duration(microseconds: 300),
              curve: Curves.easeInOut,
              child: ChoiceChip(
                label: Text(
                  label,
                  style: AppTextStyle.withColor(
                    isSelected
                        ? AppTextStyle.withWeight(
                            AppTextStyle.bodySmall, FontWeight.w600)
                        : AppTextStyle.bodySmall,
                    isSelected ? Colors.white : Colors.grey[600]!,
                  ),
                ),
                selected: isSelected,
                onSelected: (bool selected) {
                  if (selected) {
                    widget.onCategorySelected(filterCategory);
                  }
                },
                selectedColor: Theme.of(context).primaryColor,
                backgroundColor: Colors.grey[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: isSelected ? 2 : 0,
                pressElevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                labelPadding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 1,
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                side: BorderSide(
                  color: isSelected ? Colors.transparent : Colors.grey[300]!,
                  width: 1,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}