import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';

final List images = [
  "assets/villa1.jpg",
  "assets/apartment1.jpg",
  "assets/townhse1.jpg",
  "assets/house1.jpg",
];

final List names = ["Villa", "Apartment", "Townhouse", "Mansionette"];

final List prices = ["35M", "8M", "10M", "16M"];

final List status = ["Pending", "Approved", "Declined", "Pending"];

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("My Requests"),
        centerTitle: true,
      ),
      body: GridView.builder(
        itemCount: images.length,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.0,
        ),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      images[index],
                      height: 270,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  SizedBox(height: 20),

                  Text(
                    names[index],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),

                  Text(prices[index]),

                  // Text(status[index]),
                  Text(
                    status[index],
                    style: TextStyle(
                      color: status[index] == "Approved"
                          ? Colors.green
                          : status[index] == "Declined"
                          ? Colors.red
                          : Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
