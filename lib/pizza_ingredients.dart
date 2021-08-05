import 'package:flutter/material.dart';
import 'package:flutter_pizza_challenge/pizza_ingredient_item.dart';
import 'package:flutter_pizza_challenge/pizza_order_provider.dart';

import 'ingradient.dart';

class PizzaIngredients extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = PizzaOrderProvider.of(context);

    return ValueListenableBuilder(
        valueListenable: bloc.notifierTotal,
        builder: (context,value, _) {
          return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: ingredients.length,
              itemBuilder: (context, index) {
                final ingredient = ingredients[index];
                return PizzaIngradientItem(
                  ingredient: ingredient,
                  exist: bloc.containsIngredient(ingredient),
                  onTap: (){
                    print('remove');
                    bloc.removeIngredient(ingredient);
                  },
                );
              });
        });
  }
}
