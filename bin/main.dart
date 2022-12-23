import 'package:hw1/hw1.dart';

void main() async {
  var expr = "(x*3-5)/5";
  var calculator = Calculator(expression: expr, variables: {'x': 10});
  print('Result of "$expr"  is: ${calculator.result()}');
}
