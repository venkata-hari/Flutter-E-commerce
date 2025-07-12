import 'package:flutter/material.dart';
import 'package:my_flutter_app/Home.dart';
import 'package:my_flutter_app/BottomNavigation.dart';
void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavigation()
    );
  }
}