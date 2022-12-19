import 'package:hw1/hw1.dart';

void main() async {
  var expr = "(x*3-5)/5";
// 10*5+4/2-1 (результат 51)
// (x*3-5)/5 (результат 5)
// 3*x+15/(3+2) (результат 33)

  var calculator = ExpressionParser(expression: expr, variables: {'x': 10});
  print('Result of "$expr"  is: ${calculator.result()}');
}
