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

  @override
  void initState() {
    super.initState();
    getProperties();
  }

  // FETCH PROPERTIES
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Properties Display"),
        centerTitle: true,
      ),

      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              itemCount: properties.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.95,
              ),
              itemBuilder: (context, index) {
                var property = properties[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),

                  child: Container(
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🖼 IMAGE
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            "http://localhost/propertysales/propertyimages/${property.image}",
                            height: 350,
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
                          child: Text(property.description),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(property.price),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            property.location,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),

                        Spacer(),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: backgroundColor,
                            ),

                            onPressed: () {
                              // First confirmation
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Request Viewing"),
                                  content: Text(
                                    "Do you want to request viewing?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("No"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);

                                        // Second confirmation
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text("Confirm"),
                                            content: Text(
                                              "Are you sure you want to proceed?",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);

                                                  Get.toNamed(
                                                    "/requests",
                                                    arguments: property,
                                                  );
                                                },
                                                child: Text("Proceed"),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: Text("Yes"),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Text(
                              "Request",
                              style: TextStyle(color: backgroundColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
