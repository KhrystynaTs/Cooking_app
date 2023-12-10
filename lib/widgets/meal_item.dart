import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:meals/models/meal.dart';
import 'package:meals/widgets/meal_item_trait.dart';

class MealItem extends StatelessWidget {
  const MealItem({super.key, required this.meal, required this.onSelectMeal});

  final Meal meal;
  final void Function(BuildContext context, Meal meal) onSelectMeal;

  String get complexityText {
    return meal.complexity.name[0].toUpperCase() +
        meal.complexity.name.substring(1);
  }

  String get affordabilityText {
    return meal.affordability.name[0].toUpperCase() +
        meal.affordability.name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      //Stack() by default ignores the shape that is why I might have set up here on this Card - clipBehavior
      clipBehavior: Clip.hardEdge,
      elevation: 2, //3D effect
      child: InkWell(
        //we use InkWell because these meals should also be tappable.
        onTap: () {
          onSelectMeal(context, meal);
        },
        child: Stack(
          children: [
            Hero(
              //this widget   exists to enimate widgets across different widgets
              tag: meal
                  .id, //tag behind the scenes, will be used for identifying a widget on this screen and onn the target screen
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(meal
                    .imageUrl), //image will be load from Internet but it will be loaded in a very smooth way
                fit: BoxFit
                    .cover, //BoxFit.cover I use for to make sure that the image is never distroyed but instead cut off and zoomed in a bit if it would not fit into the box otherwise
                height: 200,
                width: double.infinity,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 44),
                child: Column(
                  children: [
                    Text(
                      meal.title, maxLines: 2, textAlign: TextAlign.center,
                      softWrap: true,
                      overflow: TextOverflow
                          .ellipsis, //very long text would simply be cut off by adding three dots after it
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MealItemTrait(
                          label: '${meal.duration} min',
                          icon: Icons.schedule,
                        ),
                        const SizedBox(width: 12),
                        MealItemTrait(
                          label: complexityText,
                          icon: Icons.work,
                        ),
                        const SizedBox(width: 12),
                        MealItemTrait(
                          label: affordabilityText,
                          icon: Icons.attach_money,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ), //this is a widget that can be used to position multiple widgets above each other but not like a column, instead directly above each other(so we can for example set an image as a backgroung and have some text on top it)
      ),
    );
  }
}
