import 'package:get/state_manager.dart';

class Logincontroller extends GetxController {
  var username = "".obs;
  var password = "".obs;
  var passwordVisible = false.obs;

  login(user, pass) {
    username.value = user;
    password.value = pass;

    if (username == "admin" && password == "123456") {
      return true;
    } else {
      return false;
    }
  }

  togglePassword() {
    passwordVisible.value = !passwordVisible.value;
  }
}
