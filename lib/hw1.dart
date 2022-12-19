import 'dart:math';

import 'package:hw1/record.dart';

import 'common.dart';

enum ExpressionUnits {
  add,
  sub,
  mul,
  div,
  pow,
  none,
  variable,
  constant,
  openBrace,
  closeBrace,
}

class ExpressionParser {
  final String expression;
  final Map<String, double> variables;

  ExpressionParser({required this.expression, required this.variables});

  double result() {
    var rec = _parseRecieved(expression);
    var expr = _asUnitsExpression(rec, variables);
    var res = calculateExpr(expr);
    return res;
  }

  double calculateExpr(Record<double, ExpressionUnits> expr) {
    if (expr.len == 0) return 0.0;
    if (expr.len == 1) return calculateValue(expr);
    var n = findPlusOrMinus(expr, expr.len - 1);
    var curr = expr.get(n).value;
    var rSubexpr =
        n > 0 ? expr.getSubRec(n + 1, expr.len) : expr.getSubRec(n, expr.len);
    var lSubexpr = expr.getSubRec(0, n);
    if (curr == ExpressionUnits.sub) {
      return calculateExpr(lSubexpr) - calculateMulDivExpr(rSubexpr);
    } else {
      return calculateExpr(lSubexpr) + calculateMulDivExpr(rSubexpr);
    }
  }

  double calculateMulDivExpr(Record<double, ExpressionUnits> expr) {
    if (expr.len == 0) return 1.0;
    if (expr.len == 1) return calculateValue(expr);
    var n = findMulOrDiv(expr, expr.len - 1);
    var curr = expr.get(n).value;
    var rSubexpr =
        n > 0 ? expr.getSubRec(n + 1, expr.len) : expr.getSubRec(n, expr.len);
    var lSubexpr = expr.getSubRec(0, n);
    if (curr == ExpressionUnits.div) {
      return calculateMulDivExpr(lSubexpr) / calculateValue(rSubexpr);
    } else {
      return calculateMulDivExpr(lSubexpr) * calculateValue(rSubexpr);
    }
  }

  double calculateValue(Record<double, ExpressionUnits> expr) {
    if (expr.len == 0) return 0.0;
    if (expr.get(0).value == ExpressionUnits.openBrace) {
      return calculateExpr(expr.getSubRec(1, expr.len - 1));
    } else {
      return expr.get(0).key;
    }
  }

  Record<ExpressionUnits, int> _parseRecieved(String recieved) {
    Record<ExpressionUnits, int> rec = Record();
    for (var char in recieved.runes) {
      rec.addPair(_toUnit(char));
    }
    rec.addPair(Pair(key: ExpressionUnits.none, value: 0));
    return rec;
  }

  Record<double, ExpressionUnits> _asUnitsExpression(
      Record<ExpressionUnits, int> rec, Map<String, double> map) {
    Record<double, ExpressionUnits> parsed = Record();
    var prevUnit = ExpressionUnits.none;
    bool isNegative = false;
    bool isVariable = false;
    List<int> decimals = [];
    double constantValue = 0;
    double variable = 0;

    for (var i = 0; i < rec.len; i++) {
      var p = rec.get(i);
      switch (p.key) {
        case ExpressionUnits.openBrace:
          prevUnit = ExpressionUnits.openBrace;
          parsed.addPair(
              Pair(key: p.value.toDouble(), value: ExpressionUnits.openBrace));
          break;
        case ExpressionUnits.sub:
          if (prevUnit == ExpressionUnits.none ||
              prevUnit == ExpressionUnits.openBrace) {
            isNegative = true;
          } else {
            constantValue = doubleFromList(decimals);
            if (isNegative) {
              isVariable ? variable *= (-1.0) : constantValue *= (-1.0);
              isNegative = false;
            }
            prevUnit == ExpressionUnits.closeBrace
                ? parsed.addPair(
                    Pair(key: p.value.toDouble(), value: ExpressionUnits.sub))
                : isVariable
                    ? parsed
                        .addPair(Pair(
                            key: variable, value: ExpressionUnits.variable))
                        .addPair(Pair(
                            key: p.value.toDouble(),
                            value: ExpressionUnits.sub))
                    : parsed
                        .addPair(Pair(
                            key: constantValue,
                            value: ExpressionUnits.constant))
                        .addPair(Pair(
                            key: p.value.toDouble(),
                            value: ExpressionUnits.sub));
            decimals = [];
            isVariable = false;
          }
          prevUnit = ExpressionUnits.sub;
          break;
        case ExpressionUnits.constant:
          // constant_value += p.value * pow(10.0, decimals);
          // print("list len: ${decimals.length + 1} value: ${p.value}");
          decimals.add(p.value);
          prevUnit = ExpressionUnits.constant;
          break;
        case ExpressionUnits.add:
          constantValue = doubleFromList(decimals);
          if (isNegative) {
            isVariable ? variable *= (-1.0) : constantValue *= (-1.0);
            isNegative = false;
          }
          prevUnit == ExpressionUnits.closeBrace
              ? parsed.addPair(
                  Pair(key: p.value.toDouble(), value: ExpressionUnits.add))
              : isVariable
                  ? parsed
                      .addPair(
                          Pair(key: variable, value: ExpressionUnits.variable))
                      .addPair(Pair(
                          key: p.value.toDouble(), value: ExpressionUnits.add))
                  : parsed
                      .addPair(Pair(
                          key: constantValue, value: ExpressionUnits.constant))
                      .addPair(Pair(
                          key: p.value.toDouble(), value: ExpressionUnits.add));
          decimals = [];
          isVariable = false;
          prevUnit = ExpressionUnits.add;
          break;
        case ExpressionUnits.mul:
          constantValue = doubleFromList(decimals);
          if (isNegative) {
            isVariable ? variable *= (-1.0) : constantValue *= (-1.0);
            isNegative = false;
          }
          prevUnit == ExpressionUnits.closeBrace
              ? parsed.addPair(
                  Pair(key: p.value.toDouble(), value: ExpressionUnits.mul))
              : isVariable
                  ? parsed
                      .addPair(
                          Pair(key: variable, value: ExpressionUnits.variable))
                      .addPair(Pair(
                          key: p.value.toDouble(), value: ExpressionUnits.mul))
                  : parsed
                      .addPair(Pair(
                          key: constantValue, value: ExpressionUnits.constant))
                      .addPair(Pair(
                          key: p.value.toDouble(), value: ExpressionUnits.mul));
          decimals = [];
          isVariable = false;
          prevUnit = ExpressionUnits.mul;
          break;
        case ExpressionUnits.div:
          constantValue = doubleFromList(decimals);
          if (isNegative) {
            isVariable ? variable *= (-1.0) : constantValue *= (-1.0);
            isNegative = false;
          }
          prevUnit == ExpressionUnits.closeBrace
              ? parsed.addPair(
                  Pair(key: p.value.toDouble(), value: ExpressionUnits.div))
              : isVariable
                  ? parsed
                      .addPair(
                          Pair(key: variable, value: ExpressionUnits.variable))
                      .addPair(Pair(
                          key: p.value.toDouble(), value: ExpressionUnits.div))
                  : parsed
                      .addPair(Pair(
                          key: constantValue, value: ExpressionUnits.constant))
                      .addPair(Pair(
                          key: p.value.toDouble(), value: ExpressionUnits.div));
          decimals = [];
          isVariable = false;
          prevUnit = ExpressionUnits.mul;
          break;
        case ExpressionUnits.variable:
          variable = map[String.fromCharCode(p.value)]!;
          isVariable = true;
          prevUnit = ExpressionUnits.variable;
          break;
        case ExpressionUnits.closeBrace:
          constantValue = doubleFromList(decimals);
          if (isNegative) {
            isVariable ? variable *= (-1.0) : constantValue *= (-1.0);
            isNegative = false;
          }
          prevUnit == ExpressionUnits.closeBrace
              ? parsed.addPair(Pair(
                  key: p.value.toDouble(), value: ExpressionUnits.closeBrace))
              : isVariable
                  ? parsed
                      .addPair(
                          Pair(key: variable, value: ExpressionUnits.variable))
                      .addPair(Pair(
                          key: p.value.toDouble(),
                          value: ExpressionUnits.closeBrace))
                  : parsed
                      .addPair(Pair(
                          key: constantValue, value: ExpressionUnits.constant))
                      .addPair(Pair(
                          key: p.value.toDouble(),
                          value: ExpressionUnits.closeBrace));
          decimals = [];
          isVariable = false;
          prevUnit = ExpressionUnits.closeBrace;
          break;
        case ExpressionUnits.none:
          constantValue = doubleFromList(decimals);
          if (isNegative) {
            isVariable ? variable *= (-1.0) : constantValue *= (-1.0);
            isNegative = false;
          }
          prevUnit == ExpressionUnits.closeBrace
              ? null
              : isVariable
                  ? parsed.addPair(
                      Pair(key: variable, value: ExpressionUnits.variable))
                  : parsed.addPair(Pair(
                      key: constantValue, value: ExpressionUnits.constant));
          decimals = [];
          isVariable = false;
          break;
        default:
          break;
      }
    }
    return parsed;
  }

  Pair<ExpressionUnits, int> _toUnit(int c) {
    var char = String.fromCharCode(c);
    switch (char) {
      case '+':
        return Pair(key: ExpressionUnits.add, value: c);
      case '-':
        return Pair(key: ExpressionUnits.sub, value: c);
      case '*':
        return Pair(key: ExpressionUnits.mul, value: c);
      case '/':
        return Pair(key: ExpressionUnits.div, value: c);
      case '^':
        return Pair(key: ExpressionUnits.pow, value: c);
      case 'x':
      case 'y':
      case 'z':
        return Pair(key: ExpressionUnits.variable, value: c);
      case '(':
        return Pair(key: ExpressionUnits.openBrace, value: c);
      case ')':
        return Pair(key: ExpressionUnits.closeBrace, value: c);
      default:
        var res = int.tryParse(char) != null
            ? Pair(key: ExpressionUnits.constant, value: int.parse(char))
            : Pair(key: ExpressionUnits.none, value: c);
        return res;
    }
  }
}
