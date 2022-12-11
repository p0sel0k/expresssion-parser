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
      var unit = toUnit(char);
      rec.addPair(unit);
    }
    return 5;
  }

  double solveExpr(Map map) {
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
}

class Pair<K, V> {
  final K key;
  final V value;

  Pair({required this.key, required this.value});
}

class Animal {
  String _firstName = '';
  Animal();
  static int chromosoma = 43;

  int get nameLen => _firstName.length;
  set name(String str) => _firstName = str;

  void sound() {}
}
