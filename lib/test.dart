import 'dart:convert' as conv;

Map<String, dynamic> t = {};

void main() {
  Map<String, dynamic> json =
      conv.jsonDecode('{"firstName": "Иван","lastName": "Иванов"}');
  print('$json');
}
