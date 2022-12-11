import 'package:hw1/hw1.dart';
import 'package:test/test.dart';

void main() {
  var expr = ExpressionParser(recieved: "10+62-57*x");
  test('calculate', () {
    expect(expr.parse(), 5);
  });
}
