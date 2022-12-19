import 'package:hw1/hw1.dart';
import 'package:test/test.dart';

void main() {
  test('calculate 1', () {
    var expr = ExpressionParser(expression: "10*5+4/2-1", variables: {'x': 10});
    expect(expr.result(), 51.0);
  });
  test('calculate 2', () {
    var expr = ExpressionParser(expression: "(x*3-5)/5 ", variables: {'x': 10});
    expect(expr.result(), 5.0);
  });
  test('calculate 3', () {
    var expr =
        ExpressionParser(expression: "3*x+15/(3+2) ", variables: {'x': 10});
    expect(expr.result(), 33.0);
  });
}
