import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;

class Logincontroller extends GetxController {
  var userInput = "".obs;
  var password = "".obs;
  var passwordVisible = false.obs;

  login(user, pass) async {
    userInput.value = user;
    password.value = pass;

    final response = await http.get(
      Uri.parse(
        "http://localhost/propertysales/login.php?phonenumber=123456789&password=mypassword123",
      ),
    );

    print(response.body);
    if (response.body.contains('"code": 1')) {
      return true;
    } else {
      return false;
    }
  }

  togglePassword() {
    passwordVisible.value = !passwordVisible.value;
  }
}
