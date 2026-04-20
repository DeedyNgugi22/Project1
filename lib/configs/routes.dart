import 'package:flutter_application_1/views/homescreen.dart';
import 'package:flutter_application_1/views/login.dart';
import 'package:flutter_application_1/views/properties.dart';
import 'package:flutter_application_1/views/requests.dart';
import 'package:flutter_application_1/views/signup.dart';
import 'package:flutter_application_1/views/admin_requests.dart';
import 'package:get/get.dart';

var routes = [
  GetPage(name: "/", page: () => LoginScreen()),
  GetPage(name: "/signup", page: () => SignupScreen()),
  GetPage(name: "/homescreen", page: () => HomeScreen()),
  GetPage(name: "/properties", page: () => PropertiesScreen()),
  GetPage(name: "/requests", page: () => RequestsScreen()),
  GetPage(name: "/adminrequests", page: () => AdminRequestsScreen()),
];
