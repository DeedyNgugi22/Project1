import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';
import 'package:flutter_application_1/controllers/logincontroller.dart';
import 'package:get/get.dart';

Logincontroller logincontroller = Logincontroller() = Get.put(
  Logincontroller(),
);

TextEditingController usernameController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      // appBar: AppBar(
      //   backgroundColor: Colors.pinkAccent,
      //   title: Text('LogIn Page', style: TextStyle(color: Colors.white)),
      //   centerTitle: true,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text(
            //   "Jumia Market Place",
            //   style: TextStyle(
            //     color: Colors.purple,
            //     fontSize: 18.5,
            //     fontWeight: FontWeight.w800,
            //   ),
            // ),
            Image.asset('assets/estatelogo.png'),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 20, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Enter Username',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 20, 5),
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hint: Text("Email or Phone Number"),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 20, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Enter Password',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Obx(
                () => TextField(
                  controller: passwordController,
                  obscureText: !logincontroller.passwordVisible.value,
                  decoration: InputDecoration(
                    hint: Text("PIN or Password"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: GestureDetector(
                      child: Icon(
                        logincontroller.passwordVisible.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onTap: () {
                        logincontroller.togglePassword();
                      },
                    ),
                  ),
                ),
              ),
            ),
            // MaterialButton(
            //   onPressed: () {},
            //   child: Text('LogIn'),
            //   color: Colors.pinkAccent,
            //   textColor: Colors.white,
            // ),
            SizedBox(height: 20),
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Text(
                    "Log In",
                    style: TextStyle(color: backgroundColor, fontSize: 14),
                  ),
                ),
              ),
              onTap: () {
                bool success = logincontroller.login(
                  usernameController.text,
                  passwordController.text,
                );
                if (success) {
                  Get.offAndToNamed("/homescreen");
                } else {
                  Get.snackbar("Login Failed", "Please check your credentials");
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 30, 0),
              child: Row(
                children: [
                  Spacer(),
                  Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 18),
                  ),
                  GestureDetector(
                    child: Text(
                      "SignUp",
                      style: TextStyle(color: primaryColor, fontSize: 18),
                    ),
                    onTap: () {
                      Get.offAndToNamed("/signup");
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
