import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/models/meal.dart';

class FavouriteMealNotifier extends Notifier<List<Meal>> {
  @override
  List<Meal> build() {
    return [];
  }

  void toggleMealFavoriteStatus(Meal meal) {
    if (state.contains(meal)) {
      state = state.where((m) => m.id != meal.id).toList();
    } else {
      state = [...state, meal];
    }
  }
}

final favoriteMealsProvider =
    NotifierProvider<FavouriteMealNotifier, List<Meal>>(() {
      return FavouriteMealNotifier();
    });
