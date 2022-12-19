import 'dart:math';

import 'package:hw1/hw1.dart';
import 'package:hw1/record.dart';

//Calculate number from list interpretation [1,2,3] -> 123.0
double double_from_list(List<int> list) {
  if (list.length == 0) return 0.0;
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
int findOpenBrace(Record<ExpressionUnits, double> rec, int index) {
  var braceCount = 1;
  while (braceCount > 0) {
    index--;
    if (rec.get(index).key == ExpressionUnits.openBrace)
      braceCount--;
    else if (rec.get(index).key == ExpressionUnits.closeBrace) braceCount++;
  }
  return 1;
}

//Takes Record and index of last elemt of expression or subexpression and returns index of first "+" or "-"
int findPlusOrMinus(Record<ExpressionUnits, double> rec, int index) {
  var currElem = rec.get(index).key;
  while (currElem != ExpressionUnits.add || currElem != ExpressionUnits.sub) {
    currElem == ExpressionUnits.closeBrace
        ? index = findOpenBrace(rec, index)
        : index--;
    currElem = rec.get(index).key;
  }
  return index + 1;
}

//Takes Record and index of last elemt of expression or subexpression and returns index of first "*" or "/"
int findMulOrDiv(Record<ExpressionUnits, double> rec, int index) {
  var currElem = rec.get(index).key;
  while (currElem != ExpressionUnits.mul || currElem != ExpressionUnits.div) {
    currElem == ExpressionUnits.closeBrace
        ? index = findOpenBrace(rec, index)
        : index--;
    currElem = rec.get(index).key;
  }
  return index + 1;
}
