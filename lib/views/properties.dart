import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';
import 'package:flutter_application_1/models/propertytype.dart';
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
  Future<void> getProperties() async {
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

  Future<bool> sendRequest(String userId, String propertyId) async {
    try {
      final response = await http.post(
        Uri.parse("http://localhost/propertysales/addrequests.php"),
        body: {
          "userid": userId.toString(),
          "propertyid": propertyId.toString(),
        },
      );

      print("RESPONSE: ${response.body}");

      final result = jsonDecode(response.body);

      if (result["success"] == 1) {
        return true;
      } else {
        Get.snackbar("Info", result["message"]);
        return false;
      }
    } catch (e) {
      print("Request Error: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Get.arguments ?? {};
    final userId = user["id"]?.toString() ?? "";
    print("USER ID FROM ARGUMENTS: $userId");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Properties Display"),
        centerTitle: true,
      ),

      body: GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: properties.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.89,
        ),
        itemBuilder: (context, index) {
          var property = properties[index];

          return Padding(
            padding: const EdgeInsets.all(8.0),

            child: Container(
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.2),
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
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Request Viewing"),
                            content: Text("Do you want to request viewing?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("No"),
                              ),

                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);

                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("Confirm Request"),
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
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            final userId =
                                                user["id"]?.toString() ?? "";
                                            final propertyId = property.id
                                                .toString();
                                            print("USER: $userId");
                                            print("PROPERTY: $propertyId");

                                            // STEP 1: SEND REQUEST
                                            bool success = await sendRequest(
                                              userId,
                                              property.id.toString(),
                                            );

                                            if (success) {
                                              Get.snackbar(
                                                "Success",
                                                "Request sent successfully",
                                              );

                                              //  STEP 2: NAVIGATE
                                              Get.toNamed(
                                                "/requests",
                                                arguments: {"id": userId},
                                              );
                                            } else {
                                              Get.snackbar(
                                                "Error",
                                                "Failed to send request",
                                              );
                                            }
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

                      child: Text("Request"),
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
