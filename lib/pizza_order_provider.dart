import 'package:flutter/cupertino.dart';
import 'package:flutter_pizza_challenge/pizza_order_bloc.dart';

class PizzaOrderProvider extends InheritedWidget {
  final PizzaOrderBloc bloc;
  final Widget child;

  PizzaOrderProvider({this.bloc, @required this.child});

  static PizzaOrderBloc of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<PizzaOrderProvider>().bloc;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}
