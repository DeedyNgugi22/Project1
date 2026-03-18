import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';

final List propertyImages = [
  "assets/villa1.jpg",
  "assets/apartment1.jpg",
  "assets/house1.jpg",
  "assets/townhse1.jpg",
];
final List propertyTitles = [
  "Luxury Villa",
  "Modern Apartment",
  "Mansionette",
  "Town House",
];
final List propertyPrices = [
  "Ksh 35,000,000",
  "Ksh 8,000,000",
  "Ksh 16,000,000",
  "Ksh 10,000,000",
];

class PropertiesScreen extends StatefulWidget {
  const PropertiesScreen({super.key});

  @override
  State<PropertiesScreen> createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends State<PropertiesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Properties Display Page"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: propertyImages.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
          ),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(20),
                      child: Image.asset(
                        propertyImages[index],
                        height: 400,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 10),

                    Text(
                      propertyTitles[index],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    Text(
                      propertyPrices[index],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
