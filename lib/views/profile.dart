import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

final box = GetStorage();
String? imagePath;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    imagePath = box.read("profile_image");
  }

  Future<void> pickImage() async {
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // reduces size
      );

      if (picked == null) {
        Get.snackbar("Cancelled", "No image selected");
        return;
      }

      setState(() {
        imagePath = picked.path;
      });

      box.write("profile_image", picked.path);

      Get.snackbar("Success", "Profile image updated");
    } catch (e) {
      Get.snackbar("Error", "Failed to pick image");
      print("IMAGE ERROR: $e");
    }
  }

  void deleteImage() {
    if (imagePath == null) {
      Get.snackbar("Info", "No profile image to remove");
      return;
    }

    setState(() {
      imagePath = null;
    });

    box.remove("profile_image");

    Get.snackbar("Removed", "Profile image removed");
  }

  @override
  Widget build(BuildContext context) {
    final user = Get.arguments ?? {};
    final name = user["fullname"] ?? "User";
    final email = user["email"] ?? "No email";
    final userId = user["id"] ?? "";
    final role = user["role"] ?? "user";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("My Profile"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 10),
            ],
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 130,
                child: ClipOval(
                  child: imagePath != null
                      ? kIsWeb
                            //web
                            ? Image.network(
                                imagePath!,
                                width: 260,
                                height: 260,
                                fit: BoxFit.cover,
                              )
                            // mobile
                            : Image.file(
                                File(imagePath!),
                                width: 260,
                                height: 260,
                                fit: BoxFit.cover,
                              )
                      : Image.asset(
                          'assets/profile.jpg',
                          width: 260,
                          height: 260,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              SizedBox(height: 10),

              if (imagePath != null)
                TextButton(
                  onPressed: deleteImage,
                  child: Text(
                    "Remove Photo",
                    style: TextStyle(color: Colors.red),
                  ),
                ),

              SizedBox(height: 20),

              Text(
                "Name: $name",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),

              Text("Email: $email", style: TextStyle(fontSize: 14)),

              SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.list),
                title: Text("My Requests"),
                onTap: () {
                  if (role == "admin") {
                    Get.toNamed("/adminrequests", arguments: {"id": userId});
                  } else {
                    Get.toNamed("/requests", arguments: {"id": userId});
                  }
                },
              ),

              ListTile(
                leading: Icon(Icons.edit),
                title: Text("Edit Profile"),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.photo),
                          title: Text("Change Profile Picture"),
                          onTap: () {
                            Navigator.pop(context);
                            pickImage();
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text("Remove Profile Picture"),
                          onTap: () {
                            Navigator.pop(context);
                            deleteImage();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),

              ListTile(
                leading: Icon(Icons.house),
                title: Text("Properties"),
                onTap: () {
                  Get.toNamed(
                    "/properties",
                    arguments: {
                      "id": userId,
                      "fullname": name,
                      "email": email,
                      "role": user["role"],
                    },
                  );
                },
              ),

              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Logout"),
                onTap: () {
                  Get.offAllNamed("/login");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
