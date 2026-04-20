import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';
import 'package:flutter_application_1/controllers/signupcontroller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

// CONTROLLERS
final SignupController signupController = Get.put(SignupController());
final nameController = TextEditingController();
final emailController = TextEditingController();
final phoneController = TextEditingController();
final passwordController = TextEditingController();
final confirmPasswordController = TextEditingController();

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        // prevents overflow
        child: Padding(
          padding: const EdgeInsets.all(8.0),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              SizedBox(height: 40),

              Image.asset('assets/estatelogo.png'),

              // NAME
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 10, 20, 5),
                child: Row(
                  children: [
                    Text(
                      'Enter Name',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 20, 5),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "First and Last Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // EMAIL
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 20, 5),
                child: Row(
                  children: [
                    Text(
                      'Enter Email',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 20, 5),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "username@gmail.com",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: Icon(Icons.mail),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // PHONE
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 20, 5),
                child: Row(
                  children: [
                    Text(
                      'Enter Phone Number',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 20, 5),
                child: TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    hintText: "07********",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // PASSWORD
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 20, 5),
                child: Row(
                  children: [
                    Text(
                      'Enter Password',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),

                child: Obx(
                  () => TextField(
                    controller: passwordController,
                    obscureText: !signupController.passwordVisible.value,

                    decoration: InputDecoration(
                      hintText: "PIN or Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      prefixIcon: Icon(Icons.lock),

                      suffixIcon: IconButton(
                        icon: Icon(
                          signupController.passwordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          signupController.togglePassword();
                        },
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  children: [
                    Text(
                      'Confirm Password',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 20, 5),
                child: Obx(
                  () => TextField(
                    controller: confirmPasswordController,
                    obscureText: !signupController.confirmPasswordVisible.value,
                    decoration: InputDecoration(
                      hintText: "Re-enter Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          signupController.confirmPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          signupController.toggleConfirmPassword();
                        },
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),
              // BUTTON
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),

                child: Container(
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.center,

                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: MaterialButton(
                    onPressed: () async {
                      if (nameController.text.isEmpty) {
                        Get.snackbar("Error", "Please enter full name");
                      } else if (emailController.text.isEmpty) {
                        Get.snackbar("Error", "Please enter email");
                      } else if (phoneController.text.isEmpty) {
                        Get.snackbar("Error", "Please enter phone number");
                      } else if (passwordController.text.isEmpty ||
                          confirmPasswordController.text.isEmpty ||
                          passwordController.text.toString().compareTo(
                                confirmPasswordController.text.toString(),
                              ) !=
                              0) {
                        Get.snackbar(
                          "Error",
                          "Password and Password confirmation should be none empty and matching",
                        );
                      } else {
                        final response = await http.post(
                          Uri.parse(
                            "http://10.7.23.13/propertysales/signup.php",
                          ),
                          body: {
                            "fullname": nameController.text,
                            "email": emailController.text,
                            "phonenumber": phoneController.text,
                            "password": passwordController.text,
                          },
                        );
                        if (response.statusCode == 200) {
                          final serverData = jsonDecode(response.body);
                          if (serverData['success'] == 1) {
                            Get.snackbar("Success", "You are registered");
                            Get.offAndToNamed("/");
                          } else {
                            Get.snackbar("Error", serverData['message']);
                          }
                        }
                      }
                    },

                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),

              // LOGIN LINK
              Row(
                children: [
                  Spacer(),
                  Text("Have an account?", style: TextStyle(fontSize: 18)),

                  GestureDetector(
                    child: Text(
                      " LogIn",
                      style: TextStyle(color: primaryColor, fontSize: 18),
                    ),
                    onTap: () {
                      Get.offAndToNamed("/login");
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
