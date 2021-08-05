import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_pizza_challenge/ingradient.dart';
import 'package:flutter_pizza_challenge/pizza_card_button.dart';
import 'package:flutter_pizza_challenge/pizza_cart_icon.dart';
import 'package:flutter_pizza_challenge/pizza_ingredient_item.dart';
import 'package:flutter_pizza_challenge/pizza_ingredients.dart';
import 'package:flutter_pizza_challenge/pizza_order_bloc.dart';
import 'package:flutter_pizza_challenge/pizza_order_provider.dart';
import 'package:flutter_pizza_challenge/pizza_size_button.dart';

const _pizzaCartSize = 48.0;

class PizzaOrderDetails extends StatefulWidget {
  @override
  _PizzaOrderDetailsState createState() => _PizzaOrderDetailsState();
}

class _PizzaOrderDetailsState extends State<PizzaOrderDetails> {
  final bloc = PizzaOrderBloc();

  @override
  Widget build(BuildContext context) {
    return PizzaOrderProvider(
      bloc: bloc,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "New pizza",
              style: TextStyle(color: Colors.brown, fontSize: 24),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            actions: [
              PizzaCartIconState(),
            ],
          ),
          body: Stack(
            children: [
              Positioned.fill(
                bottom: 50,
                left: 10,
                right: 10,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 10,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 4,
                        child: _PizzaDetails(),
                      ),
                      Expanded(
                        flex: 2,
                        child: PizzaIngredients(),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                  bottom: 25,
                  height: _pizzaCartSize,
                  width: _pizzaCartSize,
                  left: MediaQuery.of(context).size.width / 2 -
                      _pizzaCartSize / 2,
                  child: PizzaCartButton(
                    onTap: () {
                      bloc.startPizzaBoxAnimation();
                    },
                  ))
            ],
          )),
    );
  }
}

class _PizzaDetails extends StatefulWidget {
  @override
  _PizzaDetailsState createState() => _PizzaDetailsState();
}

class _PizzaDetailsState extends State<_PizzaDetails>
    with TickerProviderStateMixin {
  //final _listIngredients = <Ingradient>[];
  //double total = 15.0;
  List<Animation> _animationList = <Animation>[];
  AnimationController _animationController;
  AnimationController _animationRotationController;
  BoxConstraints _pizzaConstaints;
  final _keyPizza = GlobalKey();

  Widget _buildIngredientWidget({Ingradient deletedIngredient}) {
    List<Widget> elements = [];
    final _listIngredients =
        List.from(PizzaOrderProvider.of(context).listIngredients);

    if (deletedIngredient != null) {
      _listIngredients.add(deletedIngredient);
    }
    if (_animationList.isNotEmpty) {
      for (int i = 0; i < _listIngredients.length; i++) {
        Ingradient ingradient = _listIngredients[i];
        final ingredeintWidget = Image.asset(
          ingradient.imageUnit,
          height: 40,
        );
        for (int j = 0; j < ingradient.position.length; j++) {
          final animation = _animationList[j];
          final position = ingradient.position[j];
          final positionX = position.dx;
          final positionY = position.dy;
          if (i == _listIngredients.length - 1 &&
              _animationController.isAnimating) {
            double fromX = 0;
            double fromY = 0;
            if (j < 1) {
              fromX = _pizzaConstaints.maxWidth * (1 - animation.value);
            } else if (j < 2) {
              fromX = _pizzaConstaints.maxWidth * (1 - animation.value);
            } else if (j < 4) {
              fromY = -_pizzaConstaints.maxHeight * (1 - animation.value);
            } else {
              fromY = _pizzaConstaints.maxHeight * (1 - animation.value);
            }
            final opacity = animation.value;
            if (animation.value > 0) {
              elements.add(Opacity(
                opacity: opacity,
                child: Transform(
                    transform: Matrix4.identity()
                      ..translate(
                        fromX + _pizzaConstaints.maxWidth * positionX,
                        fromY + _pizzaConstaints.maxHeight * positionY,
                      ),
                    child: ingredeintWidget),
              ));
            }
          } else {
            elements.add(Transform(
                transform: Matrix4.identity()
                  ..translate(
                    _pizzaConstaints.maxWidth * positionX,
                    _pizzaConstaints.maxHeight * positionY,
                  ),
                child: ingredeintWidget));
          }
        }
      }
      return Stack(
        children: elements,
      );
    }
    return SizedBox.fromSize();
  }

  void _buildIngredientAnimation() {
    _animationList.clear();
    _animationList.add(CurvedAnimation(
        curve: Interval(0.0, 0.8, curve: Curves.decelerate),
        parent: _animationController));

    _animationList.add(CurvedAnimation(
        curve: Interval(0.2, 0.8, curve: Curves.decelerate),
        parent: _animationController));

    _animationList.add(CurvedAnimation(
        curve: Interval(0.4, 0.6, curve: Curves.decelerate),
        parent: _animationController));

    _animationList.add(CurvedAnimation(
        curve: Interval(0.1, 0.6, curve: Curves.decelerate),
        parent: _animationController));

    _animationList.add(CurvedAnimation(
        curve: Interval(0.8, 0.9, curve: Curves.decelerate),
        parent: _animationController));

    _animationList.add(CurvedAnimation(
        curve: Interval(0.5, 0.9, curve: Curves.decelerate),
        parent: _animationController));

    _animationList.add(CurvedAnimation(
        curve: Interval(0.1, 0.2, curve: Curves.decelerate),
        parent: _animationController));
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 700,
      ),
    );

    _animationRotationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = PizzaOrderProvider.of(context);
      bloc.notifierPizzaBoxAnimaiton.addListener(() {
        if (bloc.notifierPizzaBoxAnimaiton.value) {
          _addPizzaToCart();
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationRotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = PizzaOrderProvider.of(context);
    return Column(
      children: [
        Expanded(
            child: DragTarget<Ingradient>(
          onAccept: (ingredient) {
            bloc.notifierFocused.value = false;
            bloc.addIngredient(ingredient);
            _buildIngredientAnimation();
            _animationController.forward(from: 0.0);
          },
          onWillAccept: (ingredient) {
            bloc.notifierFocused.value = true;
            return !bloc.containsIngredient(ingredient);
          },
          onLeave: (ingredient) {
            bloc.notifierFocused.value = false;
          },
          builder: (context, list, rejects) {
            return LayoutBuilder(
              builder: (context, constraints) {
                _pizzaConstaints = constraints;
                return ValueListenableBuilder<PizzaMetaData>(
                    valueListenable: bloc.notifierImagePizza,
                    builder: (context, data, child) {
                      if (data != null) {
                        Future.microtask(() => _startPizzaBoxAnimation(data));
                      }

                      return AnimatedOpacity(
                        duration: Duration(milliseconds: 600),
                        opacity: data != null ? 0.0 : 1.0,
                        child: ValueListenableBuilder<PizzaSizeState>(
                            valueListenable: bloc.notifierPizzaSize,
                            builder: (context, pizzaSize, _) {
                              return RepaintBoundary(
                                key: _keyPizza,
                                child: RotationTransition(
                                  turns: CurvedAnimation(
                                      curve: Curves.elasticIn,
                                      parent: _animationRotationController),
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: ValueListenableBuilder<bool>(
                                            valueListenable:
                                                bloc.notifierFocused,
                                            builder: (context, _focused, _) {
                                              return AnimatedContainer(
                                                duration:
                                                    Duration(milliseconds: 400),
                                                height: _focused
                                                    ? constraints.maxHeight *
                                                        pizzaSize.factor
                                                    : constraints.maxHeight *
                                                            pizzaSize.factor -
                                                        10,
                                                child: Stack(
                                                  children: [
                                                    DecoratedBox(
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          boxShadow: [
                                                            BoxShadow(
                                                                blurRadius: 15,
                                                                color: Colors
                                                                    .black26,
                                                                offset: Offset(
                                                                    0, 5.0),
                                                                spreadRadius: 5)
                                                          ]),
                                                      child: Image.asset(
                                                          "assets/pizza_order/dish.png"),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Image.asset(
                                                          "assets/pizza_order/pizza-1.png"),
                                                    )
                                                  ],
                                                ),
                                              );
                                            }),
                                      ),
                                      ValueListenableBuilder<Ingradient>(
                                          valueListenable:
                                              bloc.notifierDeletedIngredient,
                                          builder:
                                              (context, deletedIngredient, _) {
                                            _animateDeletedIngredient(
                                                deletedIngredient);

                                            return AnimatedBuilder(
                                                animation: _animationController,
                                                builder: (context, _) {
                                                  return _buildIngredientWidget(
                                                      deletedIngredient:
                                                          deletedIngredient);
                                                });
                                          }),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      );
                    });
              },
            );
          },
        )),
        SizedBox(
          height: 5,
        ),
        ValueListenableBuilder<int>(
            valueListenable: bloc.notifierTotal,
            builder: (context, totalValue, _) {
              return AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                /*layoutBuilder: (Widget currentChild,List<Widget> previousChildren){
               return  Stack(
                 fit: StackFit.expand,
                  children: <Widget>[
                    ...previousChildren,
                    if (currentChild != null) currentChild,
                  ],
                  alignment: Alignment.center,
                );
              },*/
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: animation.drive(Tween<Offset>(
                        begin: Offset(0.0, 0.0),
                        end: Offset(0.0, animation.value),
                      )),
                      child: child,
                    ),
                  );
                },
                child: Text(
                  "\$$totalValue",
                  key: UniqueKey(),
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown),
                ),
              );
            }),
        SizedBox(
          height: 15,
        ),
        ValueListenableBuilder<PizzaSizeState>(
            valueListenable: bloc.notifierPizzaSize,
            builder: (context, pizzaSize, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PizzaSizedButton(
                    text: 'S',
                    onTap: () {
                      _updatePizzaSize(PizzaSizeValue.s);
                    },
                    selected: pizzaSize.value == PizzaSizeValue.s,
                  ),
                  PizzaSizedButton(
                    text: 'M',
                    onTap: () {
                      _updatePizzaSize(PizzaSizeValue.m);
                    },
                    selected: pizzaSize.value == PizzaSizeValue.m,
                  ),
                  PizzaSizedButton(
                    text: 'L',
                    onTap: () {
                      _updatePizzaSize(PizzaSizeValue.l);
                    },
                    selected: pizzaSize.value == PizzaSizeValue.l,
                  ),
                ],
              );
            }),
        /*AnimatedBuilder(
            animation: _animationController,
            builder: (context, _) {
              return _buildIngredientWidget();
            })*/
      ],
    );
  }

  Future<void> _animateDeletedIngredient(Ingradient deletedIngredient) async {
    if (deletedIngredient != null) {
      await _animationController.reverse(from: 1.0);
      final bloc = PizzaOrderProvider.of(context);
      bloc.refreshDeletedIngredient();
    }
  }

  void _updatePizzaSize(PizzaSizeValue value) {
    final bloc = PizzaOrderProvider.of(context);
    bloc.notifierPizzaSize.value = PizzaSizeState(value);
    _animationRotationController.forward(from: 0.0);
  }

  void _addPizzaToCart() {
    final bloc = PizzaOrderProvider.of(context);
    RenderRepaintBoundary boundary =
        _keyPizza.currentContext.findRenderObject();

    bloc.transformToImage(boundary);
  }

  OverlayEntry _overlayEntry;

  void _startPizzaBoxAnimation(PizzaMetaData metaData) {
    final bloc = PizzaOrderProvider.of(context);
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(builder: (context) {
        return PizzaOrderAnimation(
          metaData: metaData,
          onComplete: () {
            _overlayEntry.remove();
            _overlayEntry = null;
            bloc.reset();
          },
        );
      });
      Overlay.of(context).insert(_overlayEntry);
    }
  }
}

class PizzaOrderAnimation extends StatefulWidget {
  final PizzaMetaData metaData;
  final VoidCallback onComplete;

  const PizzaOrderAnimation({Key key, this.metaData, this.onComplete})
      : super(key: key);

  @override
  _PizzaOrderAnimationState createState() => _PizzaOrderAnimationState();
}

class _PizzaOrderAnimationState extends State<PizzaOrderAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _pizzaScaleAnimation;
  Animation<double> _pizzaOpacityAnimation;
  Animation<double> _boxEnterScaleAnimation;
  Animation<double> _boxExitScaleAnimation;
  Animation<double> _boxToCartAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2500),
    );
    _pizzaScaleAnimation = Tween(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(
        curve: Interval(0.0, 0.3),
        parent: _controller,
      ),
    );

    _pizzaOpacityAnimation = CurvedAnimation(
      curve: Interval(0.2, 0.4),
      parent: _controller,
    );

    _boxEnterScaleAnimation = CurvedAnimation(
      curve: Interval(0.0, 0.2),
      parent: _controller,
    );

    _boxExitScaleAnimation = Tween(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        curve: Interval(0.5, 0.7),
        parent: _controller,
      ),
    );

    _boxToCartAnimation = CurvedAnimation(
      curve: Interval(0.8, 1.0),
      parent: _controller,
    );
    _controller.addStatusListener((status) {
      if(status==AnimationStatus.completed){
        widget.onComplete();
      }
    });
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final metadata = widget.metaData;
    return Positioned(
      top: metadata.position.dy,
      left: metadata.position.dx,
      width: metadata.size.width,
      height: metadata.size.height,
      child: GestureDetector(
        onTap: () {
          widget.onComplete();
        },
        child: AnimatedBuilder(
            animation: _controller,
            builder: (context, snapshot) {
              final moveToX = _boxToCartAnimation.value > 0
                  ? metadata.position.dx +
                      metadata.size.width / 2 * _boxToCartAnimation.value
                  : 0.0;
              final moveToY = _boxToCartAnimation.value > 0
                  ? -metadata.size.height / 1.5 * _boxToCartAnimation.value
                  : 0.0;
              return Opacity(
                opacity: 1- _boxToCartAnimation.value,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..translate(moveToX, moveToY)
                    ..rotateZ(_boxToCartAnimation.value)
                    ..scale(_boxExitScaleAnimation.value),
                  child: Transform.scale(
                    alignment: Alignment.center,
                    scale: 1 - _boxToCartAnimation.value,
                    child: Stack(
                      children: [
                        _buildBox(),
                        Opacity(
                          opacity: 1 - _pizzaOpacityAnimation.value,
                          child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..scale(_pizzaScaleAnimation.value)
                                ..translate(
                                  0.0,
                                  20 * (1 - _pizzaOpacityAnimation.value),
                                ),
                              child: Image.memory(widget.metaData.imageBytes)),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget _buildBox() {
    return LayoutBuilder(builder: (context, constraints) {
      final boxHeight = constraints.maxHeight / 2;
      final boxWidth = constraints.maxWidth / 2;
      final minAngle = -45.0;
      final maxAngle = -125.0;
      final boxClosingValue =
          lerpDouble(minAngle, maxAngle, 1 - _pizzaOpacityAnimation.value);

      return Opacity(
        opacity: _boxEnterScaleAnimation.value,
        child: Transform.scale(
          scale: _boxEnterScaleAnimation.value,
          child: Stack(
            children: [
              Center(
                child: Transform(
                  alignment: Alignment.topCenter,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.003)
                    ..rotateX(
                      degreesToRadians(minAngle),
                    ),
                  child: Image.asset(
                    "assets/pizza_order/box_inside.png",
                    height: boxHeight,
                    width: boxWidth,
                  ),
                ),
              ),
                Center(
                  child: Transform(
                    alignment: Alignment.topCenter,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.003)
                      ..rotateX(
                        degreesToRadians(boxClosingValue),
                      ),
                    child: Image.asset(
                      "assets/pizza_order/box_front.png",
                      height: boxHeight,
                      width: boxWidth,
                    ),
                  ),
                ),
              if (boxClosingValue >= -90)
                Center(
                  child: Transform(
                    alignment: Alignment.topCenter,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.003)
                      ..rotateX(
                        degreesToRadians(boxClosingValue),
                      ),
                    child: Image.asset(
                      "assets/pizza_order/box_front.png",
                      height: boxHeight,
                      width: boxWidth,
                    ),
                  ),
                )
            ],
          ),
        ),
      );
    });
  }
}

num degreesToRadians(num deg) {
  return (deg * pi) / 180;
}
