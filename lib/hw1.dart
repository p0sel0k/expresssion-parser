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

  int parse() {
    for (var char in recieved.runes) {
      rec.addPair(toUnit(char));
    }
    return 5;
  }

  double solveExpr(Map map, Record<ExpressionUnits, int> rec) {
    Record<double, ExpressionUnits> values = Record();
    var current_position = 0;
    if (rec.contains_after(ExpressionUnits.closeBrace, current_position) !=
            null &&
        rec.contains_after(ExpressionUnits.openBrace, current_position) !=
            null) {
      var start =
          rec.contains_after(ExpressionUnits.openBrace, current_position);
      var end =
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
    }

    return 1.0;
  }

  Pair<ExpressionUnits, int> toUnit(int c) {
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

class Record<K, V> {
  final List<Pair<K, V>> record = [];

  Record();

  void add({required K key, required V val}) {
    record.add(Pair(key: key, value: val));
  }

  void addPair(Pair<K, V> pair) {
    record.add(pair);
  }

  int? contains_after(K elem, int curr_pos) {
    int index = 0;
    for (var p in record) {
      if (p.key == elem && index > curr_pos) {
        return index;
      }
      index++;
    }
    return null;
  }

  Record<K, V> get_sub_rec(int start, int end) {
    Record<K, V> rec = Record();
    int index = 0;
    for (var p in record) {
      if (index >= start && index <= end) {
        rec.addPair(p);
      }
    }
    return rec;
  }
}

class Pair<K, V> {
  final K key;
  final V value;

  Pair({required this.key, required this.value});
}
