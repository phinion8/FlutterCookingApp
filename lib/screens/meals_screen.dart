import 'package:flutter/material.dart';
import 'package:meals_app/meal_item.dart';
import 'package:meals_app/model/meal.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key, this.title, required this.meals, required this.onToggleFavorite});

  final String? title;
  final List<Meal> meals;
  final void Function(Meal meal) onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (meals.isEmpty) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Oh No....Nothing Here...",
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)),
            const SizedBox(
              height: 16,
            ),
            Text("Try selecting a different category.",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground))
          ],
        ),
      );
    } else {
      content = ListView.builder(
        itemCount: meals.length,
        itemBuilder: (context, index) => MealItem(meal: meals[index], onToggleFavorite: onToggleFavorite,),
      );
    }

    if (title == null) {
      return content;
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(title!),
        ),
        body: Container(
          child: content,
        ),
      );
    }
  }
}
