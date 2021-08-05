import 'package:flutter/material.dart';

class PizzaCartButton extends StatefulWidget {
  final VoidCallback onTap;

  const PizzaCartButton({Key key, this.onTap}) : super(key: key);

  @override
  PizzaCartButtonState createState() => PizzaCartButtonState();
}

class PizzaCartButtonState extends State<PizzaCartButton>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
        lowerBound: 1.0,
        upperBound: 1.5,
        duration: Duration(milliseconds: 150),
        reverseDuration: Duration(milliseconds: 200));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _animateButton() async {
    await _animationController.forward(from: 0.0);
    await _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
        _animateButton();
      },
      child: AnimatedBuilder(
        child: Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15.0,
                    offset: Offset(0.0, 4.0),
                    spreadRadius: 4.0)
              ],
              borderRadius: BorderRadius.circular(5),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.orange.withOpacity(0.5), Colors.orange])),
          child: Icon(
            Icons.shopping_cart_outlined,
            color: Colors.white,
            size: 35,
          ),
        ),
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
              scale: (2 - _animationController.value), child: child);
        },
      ),
    );
  }
}
