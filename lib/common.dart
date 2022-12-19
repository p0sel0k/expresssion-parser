import 'dart:math';

import 'package:hw1/hw1.dart';
import 'package:hw1/record.dart';

double doubleFromList(List<int> list) {
  if (list.isEmpty) return 0.0;
  return list
      .asMap()
      .entries
      .map((e) {
        int index = e.key;
        int val = e.value;
        return val * pow(10.0, (list.length - index - 1));
      })
      .toList()
      .reduce((value, element) => value + element)
      .toDouble();
}

//Takes Record and index of closing brace to find index of opening one
int findOpenBrace(Record<double, ExpressionUnits> rec, int index) {
  var braceCount = 1;
  while (braceCount > 0) {
    index--;
    if (rec.get(index).value == ExpressionUnits.openBrace) {
      braceCount--;
    } else if (rec.get(index).value == ExpressionUnits.closeBrace) {
      braceCount++;
    }
  }
  return index;
}

int findPlusOrMinus(Record<double, ExpressionUnits> rec, int index) {
  var currElem = rec.get(index).value;
  while (currElem != ExpressionUnits.add && currElem != ExpressionUnits.sub) {
    currElem == ExpressionUnits.closeBrace
        ? index = findOpenBrace(rec, index)
        : index--;
    if (index == -1) return 0;
    currElem = rec.get(index).value;
  }
  return index;
}

int findMulOrDiv(Record<double, ExpressionUnits> rec, int index) {
  var currElem = rec.get(index).value;
  while (currElem != ExpressionUnits.mul && currElem != ExpressionUnits.div) {
    currElem == ExpressionUnits.closeBrace
        ? index = findOpenBrace(rec, index)
        : index--;
    if (index == -1) return 0;
    currElem = rec.get(index).value;
  }
  return index;
}
