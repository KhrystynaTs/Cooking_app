//The idea here is to build a provider that simply stores all these favorite meals in a list of favorite meals

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/models/meal.dart';

class FavoriteMealsNotifier extends StateNotifier<List<Meal>> {
  //initial value
  FavoriteMealsNotifier() : super([]);

//all the methods that should exist to  change that value.
  bool toggleMealFavoriteStatus(Meal meal) {
    final mealIsFavorite = state.contains(
        meal); //that is how we get information whether a meal is a favorite or not.
//You are not allowed to edit an existing value in memory (variable.add). This approach is not allowed when using StateNotifier
    if (mealIsFavorite) {
      state = state.where((m) => m.id != meal.id).toList();
      return false; // so that is how I remove a meal, because method remove is not allowed like add.
    } else {
      state = [
        ...state,
        meal
      ]; //we pull out and keep all the existing meals and add them to a new list and we also add the new meal to that list
      return true;
    }
  }
}

//provider class is the wrong choice (because it is great if you have static dummy data)
//If you have more complex data, that should change ,in that case you should use StateNotifierProvider class provided by Riverpod
final favoriteMealsProvider =
    StateNotifierProvider<FavoriteMealsNotifier, List<Meal>>((ref) {
  return FavoriteMealsNotifier();
});
