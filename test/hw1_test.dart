import 'package:hw1/hw1.dart';
import 'package:test/test.dart';

void main() {
  var expr = ExpressionParser(recieved: "10*5+4/2-1 ");
  test('calculate', () {
    expect(expr.parse(), 5);
  });
}

// 10*5+4/2-1 (результат 51)
// (x*3-5)/5 (результат 5)
// 3*x+15/(3+2) (результат 33)
