// import 'dart:async';
// import 'dart:html';
import 'package:hw1/hw1.dart';

Map<String, dynamic> t = {};

void main() async {
  // Map<String, dynamic> json =
  //     conv.jsonDecode('{"firstNam": "Иван","lastName": "Иванов"}');
  // try {
  //   var person = Person.fromJson(json);
  //   print('${person.name} ${person.lastname}');
  // } on Exception catch (e) {
  //   print('Error: $e \nCause: Please send correct json');
  // }
  // while (true) {
  //   print('waiting...');
  // }
  // var a = await innerTest1(1);
  // print(a);
  var animal = Animal();
  // animal.name = 'asd';
  print(animal.nameLen);
}

// class Person {
//   late String name;
//   String lastname;

//   Person(name, this.lastname) {
//     this.name = name == 'Иван' ? 'ЛОХ' : name;
//   }

//   factory Person.fromJson(Map<String, dynamic> json) {
//     var keys = json.keys.toList();
//     if (!(keys.contains('firstName') && keys.contains('lastName'))) {
//       throw Exception('There are no "lastName" or "firstName" values');
//     }
//     return Person(json['firstName'], json['lastName']);
//   }
// }

// Future<void> test() async {
//   print(await innerTest1(10));
//   print(await innerTest2(10));
// }

// Future<int> innerTest1(int a) async {
//   while (a < 100) {
//     a += 1;
//   }
//   return a;
// }

// Future<int> innerTest2(int a) async {
//   while (a < 10000) {
//     a += 1;
//   }
//   return a;
// }



// class Cat extends Animal {
//   @override
//   void sound() {
//     print("myau");
//   }
// }

// class Dog extends Animal {
//   @override
//   void sound() {
//     print("bark");
//   }
// }
