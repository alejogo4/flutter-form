import 'package:flutter/material.dart';
import 'package:parcial_final/pages/login_page.dart';
import 'package:parcial_final/routes/routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: getRoutes(),
      initialRoute: LoginPage.routeName,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      title: 'Login',
    );
  }
}
