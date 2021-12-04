import 'package:flutter/material.dart';
import 'package:parcial_final/pages/login_page.dart';

Map<String, Widget Function(BuildContext)> getRoutes() => {
      LoginPage.routeName: (BuildContext context) => LoginPage(),
    };
