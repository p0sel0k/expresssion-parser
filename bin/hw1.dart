import 'package:hw1/hw1.dart';

void main() async {
  var expr = "-567+x*(-y+35/(-43))";

  var calculator =
      ExpressionParser(expression: expr, variables: {'x': 56, 'y': 34});
  print('Result of "$expr"  is: ${calculator.result()}');
}
