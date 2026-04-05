import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';
import 'package:flutter_application_1/views/propertytype.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PropertiesScreen extends StatefulWidget {
  const PropertiesScreen({super.key});

  @override
  State<PropertiesScreen> createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends State<PropertiesScreen> {
  List<Propertytype> properties = [];
  List<Propertytype> filteredProperties = [];

  String selectedLocation = "All";
  double maxPrice = 100000000;

  @override
  void initState() {
    super.initState();
    getProperties();
  }

  getProperties() async {
    final response = await http.get(
      Uri.parse("http://localhost/propertysales/readproperties.php"),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      List<Propertytype> loaded = (data['data'] as List)
          .map((e) => Propertytype.fromJson(e))
          .toList();

      setState(() {
        properties = loaded;
        filteredProperties = loaded;
      });
    }
  }

  void filterProperties() {
    setState(() {
      filteredProperties = properties.where((p) {
        double price = double.tryParse(p.price) ?? 0;

        bool locationMatch =
            selectedLocation == "All" || p.location == selectedLocation;

        bool priceMatch = price <= maxPrice;

        return locationMatch && priceMatch;
      }).toList();
    });
  }

  // FILTER UI
  void showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Filter"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: selectedLocation,
                items: ["All", "Karen", "Muthaiga", "Kiambu"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  selectedLocation = value!;
                },
              ),
              Slider(
                value: maxPrice,
                min: 1000000,
                max: 100000000,
                divisions: 10,
                label: maxPrice.toString(),
                onChanged: (value) {
                  setState(() {
                    maxPrice = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                filterProperties();
              },
              child: Text("Apply"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Properties"),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: showFilterDialog,
          ),
        ],
      ),

      body: GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: filteredProperties.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
        ),
        itemBuilder: (context, index) {
          var property = filteredProperties[index];

          return GestureDetector(
            onTap: () {
              Get.toNamed("/requests", arguments: property);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // IMAGE
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        "http://localhost/propertysales/propertyimages/${property.image}",
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.image_not_supported);
                        },
                      ),
                    ),

                    SizedBox(height: 10),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        property.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        property.price,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        property.location,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
