import 'dart:math';

import 'package:hw1/record.dart';

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
  final Map variables;

  ExpressionParser({required this.expression, required this.variables});

  double result() {
    var rec = _parseRecieved(expression);
    return _solveExpr(variables, rec, 0).key;
  }

  Record<ExpressionUnits, int> _parseRecieved(String recieved) {
    Record<ExpressionUnits, int> rec = Record();
    for (var char in recieved.runes) {
      rec.addPair(_toUnit(char));
    }
    rec.addPair(Pair(key: ExpressionUnits.none, value: 0));
    return rec;
  }

  Pair<double, ExpressionUnits> _solveExpr(
      Map map, Record<ExpressionUnits, int> rec, int curr_pos) {
    Record<double, ExpressionUnits> values = Record();
    var current_position = curr_pos;
    for (var p in rec.record) {
      print('key: ${p.key}, value: ${p.value}');
    }
    while (current_position < rec.len) {
      if (rec.contains_after(ExpressionUnits.closeBrace, current_position) !=
              null &&
          rec.contains_after(ExpressionUnits.openBrace, current_position) !=
              null &&
          (rec.contains_after(ExpressionUnits.openBrace, current_position) ==
                  current_position ||
              rec.contains_after(ExpressionUnits.openBrace, current_position) ==
                  current_position + 1)) {
        print("im here!!!!!!!");
        int? start =
            rec.contains_after(ExpressionUnits.openBrace, current_position);
        int? end =
            rec.contains_after(ExpressionUnits.closeBrace, current_position);
        print('start: $start! end: $end!');
        var sub_rec = rec.get_sub_rec(start! + 1, end! + 1);
        Pair<double, ExpressionUnits> sub_expr_result =
            _solveExpr(map, sub_rec, current_position);
        values.addPair(sub_expr_result);
        current_position = end + 1;
      }
      values = _parseExprWithoutBrace(rec, current_position, map);
      if (rec.contains_after(ExpressionUnits.openBrace, current_position) !=
          null) {
        current_position =
            rec.contains_after(ExpressionUnits.openBrace, current_position)!;
      }
      current_position = rec.len;
    }
    var value = _calculate(values);
    return Pair(key: value, value: ExpressionUnits.none);
  }

  Record<double, ExpressionUnits> _parseExprWithoutBrace(
      Record<ExpressionUnits, int> rec, int curr_pos, Map map) {
    Record<double, ExpressionUnits> parsed = Record();
    var prev_unit = ExpressionUnits.none;
    bool is_negative = false;
    bool is_variable = false;
    List<int> decimals = [];
    double constant_value = 0;
    double variable = 0;

    var closeBrace = rec.contains_after(ExpressionUnits.closeBrace, curr_pos);
    var parseEnd = closeBrace != null ? closeBrace + 2 : rec.len;
    for (var i = curr_pos; i < parseEnd; i++) {
      print("step: $i");
      var p = rec.get(i);
      switch (p.key) {
        case ExpressionUnits.openBrace:
          prev_unit = ExpressionUnits.openBrace;
          break;
        case ExpressionUnits.sub:
          if (prev_unit == ExpressionUnits.none ||
              prev_unit == ExpressionUnits.openBrace) {
            is_negative = true;
          } else {
            if (is_negative) {
              is_variable ? variable * (-1.0) : constant_value * (-1.0);
              is_negative = false;
            }
            constant_value = double_from_list(decimals);
            is_variable
                ? parsed
                    .addPair(Pair(key: variable, value: ExpressionUnits.sub))
                : parsed.addPair(
                    Pair(key: constant_value, value: ExpressionUnits.sub));
            decimals = [];
            is_variable = false;
          }
          prev_unit = ExpressionUnits.sub;
          break;
        case ExpressionUnits.constant:
          // constant_value += p.value * pow(10.0, decimals);
          print("list len: ${decimals.length} value: ${p.value}");
          decimals.add(p.value);
          prev_unit = ExpressionUnits.constant;
          break;
        case ExpressionUnits.add:
          if (is_negative) {
            is_variable ? variable * (-1.0) : constant_value * (-1.0);
            is_negative = false;
          }
          constant_value = double_from_list(decimals);
          is_variable
              ? parsed.addPair(Pair(key: variable, value: ExpressionUnits.add))
              : parsed.addPair(
                  Pair(key: constant_value, value: ExpressionUnits.add));
          decimals = [];
          is_variable = false;
          break;
        case ExpressionUnits.mul:
          if (is_negative) {
            is_variable ? variable * (-1.0) : constant_value * (-1.0);
            is_negative = false;
          }
          constant_value = double_from_list(decimals);
          is_variable
              ? parsed.addPair(Pair(key: variable, value: ExpressionUnits.mul))
              : parsed.addPair(
                  Pair(key: constant_value, value: ExpressionUnits.mul));
          decimals = [];
          is_variable = false;
          break;
        case ExpressionUnits.div:
          if (is_negative) {
            is_variable ? variable * (-1.0) : constant_value * (-1.0);
            is_negative = false;
          }
          constant_value = double_from_list(decimals);
          is_variable
              ? parsed.addPair(Pair(key: variable, value: ExpressionUnits.div))
              : parsed.addPair(
                  Pair(key: constant_value, value: ExpressionUnits.div));
          decimals = [];
          is_variable = false;
          break;
        case ExpressionUnits.variable:
          variable = map[String.fromCharCode(p.value)];
          is_variable = true;
          break;
        case ExpressionUnits.closeBrace:
          if (is_negative) {
            is_variable ? variable * (-1.0) : constant_value * (-1.0);
            is_negative = false;
          }
          constant_value = double_from_list(decimals);
          is_variable
              ? parsed.addPair(
                  Pair(key: variable, value: ExpressionUnits.closeBrace))
              : parsed.addPair(
                  Pair(key: constant_value, value: ExpressionUnits.closeBrace));
          decimals = [];
          is_variable = false;
          break;
        case ExpressionUnits.none:
          if (is_negative) {
            is_variable ? variable * (-1.0) : constant_value * (-1.0);
            is_negative = false;
          }
          constant_value = double_from_list(decimals);
          is_variable
              ? parsed.addPair(Pair(key: variable, value: ExpressionUnits.none))
              : parsed.addPair(
                  Pair(key: constant_value, value: ExpressionUnits.none));
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
