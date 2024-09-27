
import 'package:flutter/material.dart';
import 'package:zeytin_app_v2/AppConst.dart';
import 'package:zeytin_app_v2/HomePage.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme:AppBarTheme(
          color: AppConst().vistaBlue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16),bottomRight: Radius.circular(16)))
        ) ,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SafeArea(
        child: HomePage(),
      ),
    );
  }
}






