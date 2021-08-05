import 'package:flutter/material.dart';
import 'package:flutter_pizza_challenge/pizza_order_details.dart';
class MainPizzaOrderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: PizzaOrderDetails(),
    );
  }
}
