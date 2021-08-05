import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_pizza_challenge/pizza_order_provider.dart';

class PizzaCartIconState extends StatefulWidget {
  @override
  _PizzaCartIconStateState createState() => _PizzaCartIconStateState();
}

class _PizzaCartIconStateState extends State<PizzaCartIconState>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  int counter = 0;
  Animation<double> _animationScaleOut;
  Animation<double> _animationScaleIn;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _animationScaleOut =
        CurvedAnimation(curve: Interval(0.0, 0.5), parent: _controller);
    _animationScaleIn =
        CurvedAnimation(curve: Interval(0.5, 1), parent: _controller);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = PizzaOrderProvider.of(context);
      bloc.notifierCartIconAnimation.addListener(() {
        counter = bloc.notifierCartIconAnimation.value;
        _controller.forward(from: 0.0);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
        animation: _controller,
        builder: (context, snapshot) {
          double scale;
          const scaleFactor = 0.5;
          if (_animationScaleOut.value < 1.0) {
            scale = 1.0 + scaleFactor * _animationScaleOut.value;
          } else if (_animationScaleIn.value <= 1.0) {
            scale = (1.0 + scaleFactor) - scaleFactor * _animationScaleIn.value;
          }
          return Transform.scale(
            scale: scale,
            alignment: Alignment.center,
            child: Stack(children: [
              IconButton(
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.brown,
                ),
                onPressed: () {},
              ),
              if(_animationScaleOut.value>0)
                Positioned(
                  top: 7,
                  right: 7,
                  child: Transform.scale(
                    scale: _animationScaleOut.value,
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 7 ,
                      backgroundColor: Colors.red,
                      child: Text(counter.toString(),
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
            ]),
          );
        });
  }
}
