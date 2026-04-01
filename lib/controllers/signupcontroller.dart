import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;

class SignupController extends GetxController {
  var fullname = "".obs;
  var email = "".obs;
  var password = "".obs;

  var passwordVisible = false.obs;
  var confirmPasswordVisible = false.obs;

  register(String name, String mail, String pass) async {
    fullname.value = name;
    email.value = mail;
    password.value = pass;

    try {
      final response = await http.post(
        Uri.parse("http://localhost/propertysales/signup.php"),
        body: {"fullname": name, "email": mail, "password": pass},
      );

      print(response.body);

      final code = response.body.contains('"code":1');
      return code;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  // TOGGLE PASSWORD VISIBILITY
  void togglePassword() {
    passwordVisible.value = !passwordVisible.value;
  }

  void toggleConfirmPassword() {
    confirmPasswordVisible.value = !confirmPasswordVisible.value;
  }
}
