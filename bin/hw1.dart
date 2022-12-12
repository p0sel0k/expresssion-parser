import 'package:hw1/hw1.dart';

void main() async {
  var expr = "789*45+54-5";

  var calculator = ExpressionParser(expression: expr, variables: {});
  print('Result of "$expr"  is: ${calculator.result()}');
}
