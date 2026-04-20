import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';

final List dashboardTitles = [
  "Total Properties",
  "Available Properties",
  "Pending Requests",
  "Approved Requests",
];

final List dashboardvalues = ["670", "520", "12", "8"];

final List dashboardIcons = [
  Icons.home,
  Icons.check_circle,
  Icons.access_time,
  Icons.verified,
];

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: primaryColor,
      //   title: Text("Welcome to the Dashboard"),
      //   centerTitle: true,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("Dashboard"),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 0, 20, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GridView.builder(
              itemCount: dashboardTitles.length,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.5,
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          dashboardIcons[index],
                          size: 40,
                          color: primaryColor,
                        ),
                        SizedBox(height: 20),

                        Text(
                          dashboardvalues[index],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 20),

                        Text(
                          dashboardTitles[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
