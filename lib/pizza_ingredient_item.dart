import 'package:flutter/material.dart';
import 'package:flutter_pizza_challenge/ingradient.dart';

class PizzaIngradientItem extends StatelessWidget {
  final Ingradient ingredient;
  final bool exist;
  final VoidCallback onTap;
  const PizzaIngradientItem({Key key, this.ingredient, this.exist, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: exist
          ? _buildChild()
          : Draggable(
              feedback: DecoratedBox(
                decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                  BoxShadow(
                      blurRadius: 10.0,
                      offset: Offset(0.0, 5.0),
                      color: Colors.black12,
                      spreadRadius: 10)
                ]),
              ),
              data: ingredient,
              child: _buildChild(),
            ),
    );
  }

  Widget _buildChild({bool withImage = true}) {
    return GestureDetector(
      onTap: exist?onTap:null,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color:exist?Colors.red.withOpacity(0.8): Color(0xFFF5EED3),
              shape: BoxShape.circle,
              border: exist ? Border.all(color: Colors.red, width: 2) : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: withImage
                  ? Image.asset(
                      ingredient.image,
                      fit: BoxFit.contain,
                    )
                  : SizedBox.fromSize(),
            ),
          )),
    );
  }
}
