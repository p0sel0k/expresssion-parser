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
  String recieved;
  final Record<ExpressionUnits, int> rec = Record();

  ExpressionParser({required this.recieved});

  int parseRecieved() {
    for (var char in recieved.runes) {
      rec.addPair(_toUnit(char));
    }
    return 5;
  }

  Pair<double, ExpressionUnits> solveExpr(
      Map map, Record<ExpressionUnits, int> rec) {
    Record<double, ExpressionUnits> values = Record();
    var current_position = 0;
    if (rec.contains_after(ExpressionUnits.closeBrace, current_position) !=
            null &&
        rec.contains_after(ExpressionUnits.openBrace, current_position) !=
            null) {
      int? start =
          rec.contains_after(ExpressionUnits.openBrace, current_position);
      int? end =
          rec.contains_after(ExpressionUnits.closeBrace, current_position);
      var sub_rec = rec.get_sub_rec(start!, end!);
      solveExpr(map, sub_rec);
    } else if (rec.contains_after(
            ExpressionUnits.closeBrace, current_position) !=
        null) {
      throw "Expression is incorrect! Doesn't have closing brace!!";
    } else if (rec.contains_after(
            ExpressionUnits.closeBrace, current_position) !=
        null) {
      throw "Expression is incorrect! Doesn't have opening brace!!";
    } else {
      values = _parseExpr(rec);
    }
    var value = _calculate(values);
    return Pair(key: value, value: ExpressionUnits.none);
  }

  Record<double, ExpressionUnits> _parseExpr(Record<ExpressionUnits, int> rec) {
    return Record();
  }

  double _calculate(Record<double, ExpressionUnits> values) {
    return 0.0;
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
