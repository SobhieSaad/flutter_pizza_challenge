import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'ingradient.dart';

class PizzaMetaData {
  final Uint8List imageBytes;
  final Offset position;
  final Size size;

  const PizzaMetaData(this.imageBytes, this.position, this.size);
}

enum PizzaSizeValue { s, m, l }

class PizzaSizeState {
  final PizzaSizeValue value;
  final double factor;

  PizzaSizeState(this.value) : factor = _getFactorBySize(value);

  static double _getFactorBySize(PizzaSizeValue value) {
    switch (value) {
      case PizzaSizeValue.s:
        return 0.75;
      case PizzaSizeValue.m:
        return 0.85;
      case PizzaSizeValue.l:
        return 1.0;
    }
    return 0.0;
  }
}

const initialTotal=15;
class PizzaOrderBloc extends ChangeNotifier {
  final listIngredients = <Ingradient>[];
  final notifierTotal = ValueNotifier(initialTotal);
  final notifierDeletedIngredient = ValueNotifier<Ingradient>(null);
  final notifierFocused = ValueNotifier(false);
  final notifierPizzaSize =
      ValueNotifier<PizzaSizeState>(PizzaSizeState(PizzaSizeValue.m));
  final notifierPizzaBoxAnimaiton = ValueNotifier(false);
  final notifierImagePizza = ValueNotifier<PizzaMetaData>(null);
  final notifierCartIconAnimation=ValueNotifier(0);
  void addIngredient(Ingradient ingradient) {
    listIngredients.add(ingradient);
    notifierTotal.value++;
    notifyListeners();
  }

  bool containsIngredient(Ingradient ingredient) {
    for (Ingradient i in listIngredients) {
      if (i.compare(ingredient)) {
        return true;
      }
    }

    return false;
  }

  void removeIngredient(Ingradient ingredient) {
    listIngredients.remove(ingredient);
    notifierTotal.value--;
    notifierDeletedIngredient.value = ingredient;
  }

  void refreshDeletedIngredient() {
    notifierDeletedIngredient.value = null;
  }

  void reset(){
    notifierPizzaBoxAnimaiton.value=false;
    notifierImagePizza.value=null;
    listIngredients.clear();
    notifierTotal.value=initialTotal;
    notifierCartIconAnimation.value++;
  }
  void startPizzaBoxAnimation() {
    notifierPizzaBoxAnimaiton.value = true;
  }

  Future<void> transformToImage(RenderRepaintBoundary boundary) async {
    final position = boundary.localToGlobal(Offset.zero);
    final size = boundary.size;
    final image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
    notifierImagePizza.value =
        PizzaMetaData(byteData.buffer.asUint8List(), position, size);
  }
}
