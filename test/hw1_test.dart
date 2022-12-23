import 'package:hw1/hw1.dart';
import 'package:test/test.dart';

void main() {
  test('calculate 1', () {
    var expr = Calculator(expression: "10*5+4/2-1", variables: {'x': 10});
    expect(expr.result(), 51.0);
  });
  test('calculate 2', () {
    var expr = Calculator(expression: "(x*3-5)/5", variables: {'x': 10});
    expect(expr.result(), 5.0);
  });
  test('calculate 3', () {
    var expr = Calculator(expression: "3*x+15/(3+2)", variables: {'x': 10});
    expect(expr.result(), 33.0);
  });
  test('calculate 4', (() {
    var expr = Calculator(expression: "2*2/2");
    expect(expr.result(), 2.0);
  }));
  test('calculate 5 with infinity result', (() {
    var expr = Calculator(expression: "2/0");
    expect(expr.result(), double.infinity);
  }));
}
