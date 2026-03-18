import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/routes.dart';
import 'package:flutter_application_1/views/login.dart';
import 'package:get/get.dart';

void main() {
  runApp(
    GetMaterialApp(
      initialRoute: "/",
      getPages: routes,
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    ),
  );
}
