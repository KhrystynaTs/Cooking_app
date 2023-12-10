import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/category.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/category_grid_item.dart';
import 'package:meals/models/meal.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen(
      {super.key,
      //required this.onToggleFavorite,
      required this.availableMeals});

  //final void Function(Meal meal) onToggleFavorite;
  final List<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController
      _animationController; //late means that this variable will have a value as soon as it is being used the first time but not yet
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    );
    _animationController
        .forward(); //this will start the animation and play it to its end unless you stop it in between
  }

  @override
  void dispose() {
    _animationController
        .dispose(); //this make sure that animation_controller will be removed from the device memory when it's widget is removed
    super.dispose();
  }

  //This is how we would push this MealsScreen on top of this stack of pages;we should make sure that we load the meals that belong to the selected category, so for this we should eccept a second parameter here.
  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = widget.availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList(); // thai it return true, if this meal for this function is curently executed does include that category ID and false otherwise
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title,
          meals: filteredMeals,
          //onToggleFavorite: onToggleFavorite,
        ),
      ),
    ); // Navigator.push(context, route)
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: GridView(
        //Here we are controlling what should be animated, we also using performance optimization of putting the content that actually should only be part of the animation but which should not be rebuilt because its value do not change by putting that contetnt into the separate child here so that it is included in the animation content but not rebuilt
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ), //controls the layout of the GridView items.
        children: [
          //availableCategories.map((category)=>CategoryGridItem(category:category)).toList()
          for (final category in availableCategories)
            CategoryGridItem(
              category: category,
              onSelectCategory: () {
                _selectCategory(context, category);
              },
            )
        ],
      ),
      //drive simply allows us to translate our animation between zero and one to an animation between two other values
      builder: (context, child) => SlideTransition(
        position:
            //_animationController.drive(
            Tween(
          begin: const Offset(0, 0.3),
          end: const Offset(0, 0),
        ).animate(
          CurvedAnimation(
              parent: _animationController, curve: Curves.bounceInOut),
        ),
        child: child,
      ),
    );
    /*Padding(
        padding: EdgeInsets.only(
          top: 100 - _animationController.value * 100,
        ),
        child: child,
      ),*/
  }
}
