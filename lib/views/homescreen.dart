import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';
// import 'package:flutter_application_1/controllers/homescreencontroller.dart';
// import 'package:flutter_application_1/views/login.dart';
import 'package:flutter_application_1/views/properties.dart';
import 'profile.dart';
import 'dashboard.dart';
import 'requests.dart';
import 'admin_requests.dart';
import 'package:get/get.dart';

final List titles = ["Villas", "Apartments", "Mansionettes", "Town Houses"];
final List iconData = [
  Icons.villa,
  Icons.apartment,
  Icons.house_outlined,
  Icons.house,
];
final List values = ["300", "200", "70", "100"];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Get.arguments ?? {};
    final username = user["fullname"] ?? "User";
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Image.asset('assets/estatelogo.png'),
        //     Text(
        //     'Hi Deedy. Find Your Dream Home Today!!!',
        //     style: TextStyle(
        //       fontSize: 18,
        //       fontWeight: FontWeight.w600,
        //       color: secondaryColor,
        //     ),
        //   ),
        // ],
        children: [
          Image.asset('assets/estatelogo.png'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Hi $username. Find Your Dream Home Today!!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          GridView.builder(
            itemCount: titles.length,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        iconData[index],
                        size: 50,
                        color: primaryColor.withOpacity(0.8),
                      ),
                      Text(
                        titles[index],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        values[index],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),

      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: primaryColor,
        items: <Widget>[
          Icon(Icons.dashboard, size: 30),
          Icon(Icons.category, size: 30),
          Icon(Icons.request_page, size: 30),
          Icon(Icons.person, size: 30),
        ],
        onTap: (index) {
          if (index == 0) {
            Get.to(() => DashboardScreen(), arguments: user);
          } else if (index == 1) {
            Get.to(() => PropertiesScreen(), arguments: user);
          } else if (index == 2) {
            if (user["role"] == "admin") {
              Get.to(() => AdminRequestsScreen(), arguments: user);
            } else {
              Get.to(() => RequestsScreen(), arguments: user);
            }
          } else if (index == 3) {
            Get.to(() => ProfileScreen(), arguments: user);
          }
        },
      ),
    );
  }
}
