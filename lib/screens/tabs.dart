import 'package:flutter/material.dart';
import 'package:meals_app/dummy_data.dart';
import 'package:meals_app/main_drawer.dart';
import 'package:meals_app/model/meal.dart';
import 'package:meals_app/screens/catergory_screen.dart';
import 'package:meals_app/screens/filters.dart';
import 'package:meals_app/screens/meals_screen.dart';

const kFilterInitialValues = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false
};

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreen();
  }
}

class _TabsScreen extends State<TabsScreen> {
  int selectedPageIndex = 0;

  final List<Meal> faviouriteMeal = [];

  Map<Filter, bool> _selectedFilter = kFilterInitialValues;

  void _toggleMealsFaviouriteStatus(Meal meal) {
    final isExisting = faviouriteMeal.contains(meal);
    if (isExisting) {
      setState(() {
        faviouriteMeal.remove(meal);
        _showInfoMessage("Meal is no longer a favorite meal.");
      });
    } else {
      setState(() {
        faviouriteMeal.add(meal);
        _showInfoMessage("Marked as a favorite!");
      });
    }
  }

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _setIndex(int index) {
    setState(() {
      selectedPageIndex = index;
    });
  }

  void _setScreen(String screen) async {
    Navigator.of(context).pop();
    if (screen == "filters") {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
          MaterialPageRoute(builder: (ctx) => FiltersScreen(currentFilters: _selectedFilter,)));

      setState(() {
        //?? sets the fall back value if the result is null
        _selectedFilter = result ?? kFilterInitialValues;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = dummyMeals.where((meal) {
      if (_selectedFilter[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_selectedFilter[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectedFilter[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (_selectedFilter[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();
    Widget selectedScreen = CategoryScreen(
      onToggleFavorite: _toggleMealsFaviouriteStatus,
      availableMeals: availableMeals,
    );

    String activePageTitle = "Categories";

    if (selectedPageIndex == 1) {
      selectedScreen = MealsScreen(
        meals: faviouriteMeal,
        onToggleFavorite: _toggleMealsFaviouriteStatus,
      );
      activePageTitle = "Your Favorites";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      body: selectedScreen,
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: _setIndex,
          currentIndex: selectedPageIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.set_meal), label: "Categories"),
            BottomNavigationBarItem(
                icon: Icon(Icons.star), label: "Your Favorites")
          ]),
    );
  }
}
