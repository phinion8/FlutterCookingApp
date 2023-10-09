import 'package:flutter/material.dart';
import 'package:meals_app/category_grid_item.dart';
import 'package:meals_app/dummy_data.dart';
import 'package:meals_app/model/category.dart';
import 'package:meals_app/model/meal.dart';
import 'package:meals_app/screens/meals_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key, required this.onToggleFavorite, required this.availableMeals});

  final void Function(Meal meal) onToggleFavorite;

  final List<Meal> availableMeals;

  void _selectCategory(BuildContext context, Category selectedCategory) {
    final selectedCatgoryList = availableMeals
        .where((meals) => meals.categories.contains(selectedCategory.id))
        .toList();

    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => MealsScreen(
              title: selectedCategory.title,
              meals: selectedCatgoryList,
              onToggleFavorite: onToggleFavorite,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 20.0),
      children: [
        for (final category in availableCategories)
          CategoryGridItem(
            category: category,
            onSelectedCategory: () {
              _selectCategory(context, category);
            },
          )
      ],
    );
  }
}
