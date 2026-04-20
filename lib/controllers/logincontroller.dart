import 'dart:convert';

import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;

class Logincontroller extends GetxController {
  var userInput = "".obs;
  var password = "".obs;
  var passwordVisible = false.obs;

  Future<Map?> login(user, pass) async {
    final response = await http.get(
      Uri.parse(
        "http://localhost/propertysales/login.php?phonenumber=$user&password=$pass",
      ),
    );

    final data = jsonDecode(response.body);

    if (data['code'] == 1) {
      return data['userdetails'][0];
    } else {
      return null;
    }
  }

  void togglePassword() {
    passwordVisible.value = !passwordVisible.value;
  }
}
