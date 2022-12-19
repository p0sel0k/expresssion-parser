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
    return 0.0;
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
    var prev_unit = ExpressionUnits.none;
    bool is_negative = false;
    bool is_variable = false;
    List<int> decimals = [];
    double constant_value = 0;
    double variable = 0;

    for (var i = 0; i < rec.len; i++) {
      var p = rec.get(i);
      switch (p.key) {
        case ExpressionUnits.openBrace:
          prev_unit = ExpressionUnits.openBrace;
          parsed.addPair(
              Pair(key: p.value.toDouble(), value: ExpressionUnits.openBrace));
          break;
        case ExpressionUnits.sub:
          if (prev_unit == ExpressionUnits.none ||
              prev_unit == ExpressionUnits.openBrace) {
            is_negative = true;
            print("negative");
          } else {
            constant_value = double_from_list(decimals);
            if (is_negative) {
              is_variable ? variable *= (-1.0) : constant_value *= (-1.0);
              is_negative = false;
            }
            is_variable
                ? parsed
                    .addPair(
                        Pair(key: variable, value: ExpressionUnits.variable))
                    .addPair(Pair(
                        key: p.value.toDouble(), value: ExpressionUnits.sub))
                : parsed
                    .addPair(Pair(
                        key: constant_value, value: ExpressionUnits.constant))
                    .addPair(Pair(
                        key: p.value.toDouble(), value: ExpressionUnits.sub));
            decimals = [];
            is_variable = false;
          }
          prev_unit = ExpressionUnits.sub;
          break;
        case ExpressionUnits.constant:
          // constant_value += p.value * pow(10.0, decimals);
          print("list len: ${decimals.length + 1} value: ${p.value}");
          decimals.add(p.value);
          prev_unit = ExpressionUnits.constant;
          break;
        case ExpressionUnits.add:
          constant_value = double_from_list(decimals);
          if (is_negative) {
            is_variable ? variable *= (-1.0) : constant_value *= (-1.0);
            is_negative = false;
          }
          is_variable
              ? parsed
                  .addPair(Pair(key: variable, value: ExpressionUnits.variable))
                  .addPair(
                      Pair(key: p.value.toDouble(), value: ExpressionUnits.add))
              : parsed
                  .addPair(Pair(
                      key: constant_value, value: ExpressionUnits.constant))
                  .addPair(Pair(
                      key: p.value.toDouble(), value: ExpressionUnits.add));
          decimals = [];
          is_variable = false;
          break;
        case ExpressionUnits.mul:
          constant_value = double_from_list(decimals);
          if (is_negative) {
            is_variable ? variable *= (-1.0) : constant_value *= (-1.0);
            is_negative = false;
          }
          is_variable
              ? parsed
                  .addPair(Pair(key: variable, value: ExpressionUnits.variable))
                  .addPair(
                      Pair(key: p.value.toDouble(), value: ExpressionUnits.mul))
              : parsed
                  .addPair(Pair(
                      key: constant_value, value: ExpressionUnits.constant))
                  .addPair(Pair(
                      key: p.value.toDouble(), value: ExpressionUnits.mul));
          decimals = [];
          is_variable = false;
          break;
        case ExpressionUnits.div:
          constant_value = double_from_list(decimals);
          if (is_negative) {
            is_variable ? variable *= (-1.0) : constant_value *= (-1.0);
            is_negative = false;
          }
          is_variable
              ? parsed
                  .addPair(Pair(key: variable, value: ExpressionUnits.variable))
                  .addPair(
                      Pair(key: p.value.toDouble(), value: ExpressionUnits.div))
              : parsed
                  .addPair(Pair(
                      key: constant_value, value: ExpressionUnits.constant))
                  .addPair(Pair(
                      key: p.value.toDouble(), value: ExpressionUnits.div));
          decimals = [];
          is_variable = false;
          break;
        case ExpressionUnits.variable:
          variable = map[String.fromCharCode(p.value)]!;
          is_variable = true;
          break;
        case ExpressionUnits.closeBrace:
          constant_value = double_from_list(decimals);
          if (is_negative) {
            is_variable ? variable *= (-1.0) : constant_value *= (-1.0);
            is_negative = false;
          }
          is_variable
              ? parsed
                  .addPair(Pair(key: variable, value: ExpressionUnits.variable))
                  .addPair(Pair(
                      key: p.value.toDouble(),
                      value: ExpressionUnits.closeBrace))
              : parsed
                  .addPair(Pair(
                      key: constant_value, value: ExpressionUnits.constant))
                  .addPair(Pair(
                      key: p.value.toDouble(),
                      value: ExpressionUnits.closeBrace));
          decimals = [];
          is_variable = false;
          break;
        case ExpressionUnits.none:
          constant_value = double_from_list(decimals);
          if (is_negative) {
            is_variable ? variable *= (-1.0) : constant_value *= (-1.0);
            is_negative = false;
          }
          is_variable
              ? parsed
                  .addPair(Pair(key: variable, value: ExpressionUnits.variable))
                  .addPair(Pair(
                      key: p.value.toDouble(), value: ExpressionUnits.none))
              : parsed
                  .addPair(Pair(
                      key: constant_value, value: ExpressionUnits.constant))
                  .addPair(Pair(
                      key: p.value.toDouble(), value: ExpressionUnits.none));
          decimals = [];
          is_variable = false;
          break;
        default:
          break;
      }
    }
    return parsed;
  }

  double _calculate(Record<double, ExpressionUnits> values) {
    for (var p in values.record) {
      print('value is: ${p.key}, expr is: ${p.value}');
    }
    return 1.0;
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
