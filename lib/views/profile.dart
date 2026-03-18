import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';
// ignore: unused_import
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 130,
                backgroundImage: AssetImage('assets/me.jpg'),
              ),
              SizedBox(height: 20),
              Text(
                "Name: Deedy Ngugi",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 10),
              Text(
                "Email: deedyngugi@gmail.com",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w200),
              ),
              SizedBox(height: 10),

              ListTile(leading: Icon(Icons.list), title: Text("My Requests")),

              ListTile(leading: Icon(Icons.edit), title: Text("Edit Profile")),

              ListTile(
                leading: Icon(Icons.bookmark),
                title: Text("Saved Properties"),
              ),

              ListTile(leading: Icon(Icons.logout), title: Text("Logout")),
            ],
          ),
        ),
      ),
    );
  }
}
