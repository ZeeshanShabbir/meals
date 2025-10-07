import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/screens/meal_detail.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectPageIndex = 0;

  // Replace this with your actual available meals source
  final List<Meal> _availableMeals = dummyMeals;

  final List<Meal> _favoriteMeals = [];

  void _selectPage(int index) {
    setState(() {
      _selectPageIndex = index;
    });
  }

  void _toggleFavorite(Meal meal) {
    setState(() {
      final existingIndex = _favoriteMeals.indexWhere((m) => m.id == meal.id);
      if (existingIndex >= 0) {
        _favoriteMeals.removeAt(existingIndex);
      } else {
        _favoriteMeals.add(meal);
      }
    });
  }

  bool _isMealFavorite(String id) {
    return _favoriteMeals.any((m) => m.id == id);
  }

  // Helper to open MealDetail with favorite callback + state
  void _openMealDetail(BuildContext context, Meal meal) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealDetail(
          meal: meal,
          isFavorite: _isMealFavorite(meal.id),
          onToggleFavorite: () => _toggleFavorite(meal),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage;
    String activePageTitle;

    if (_selectPageIndex == 1) {
      // Favourites tab
      activePage = MealsScreen(
        meals: _favoriteMeals,
        onSelectMeal: (meal) => _openMealDetail(context, meal),
        onToggleFavorite: (meal) => _toggleFavorite(meal),
        isMealFavorite: (id) => _isMealFavorite(id),
      );
      activePageTitle = 'Your Favourites';
    } else {
      // Categories (show the grid). Pass callbacks so category -> meals -> detail works
      activePage = CategoriesScreen(
        onSelectMeal: (ctx, meal) => _openMealDetail(ctx, meal),
        onToggleFavorite: (meal) => _toggleFavorite(meal),
        isMealFavorite: (id) => _isMealFavorite(id),
      );
      activePageTitle = 'Categories';
    }

    return Scaffold(
      appBar: AppBar(title: Text(activePageTitle)),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          _selectPage(index);
        },
        currentIndex: _selectPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favourites'),
        ],
      ),
    );
  }
}
