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

  // fetch properties
  Future<void> getProperties() async {
    final response = await http.get(
      Uri.parse("http://10.215.76.151/propertysales/readproperties.php"),
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

  //send requests
  Future<bool> sendRequest(String userId, String propertyId) async {
    try {
      final response = await http.post(
        Uri.parse("http://10.215.76.151/propertysales/addrequests.php"),
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

  //update property status
  Future<bool> updatePropertyStatus(String propertyId, String status) async {
    try {
      final response = await http.post(
        Uri.parse("http://10.215.76.151/propertysales/updateproperty.php"),
        body: {"id": propertyId, "status": status},
      );

      final result = jsonDecode(response.body);
      return result["success"] == 1;
    } catch (e) {
      print("STATUS ERROR: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Get.arguments ?? {};
    final userId = user["id"]?.toString() ?? "";
    final role = user["role"]?.toString() ?? "user";

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
          crossAxisCount: 1,
          childAspectRatio: 0.67,
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
                      "http://10.215.76.151/propertysales/propertyimages/${property.image}",
                      height: 250,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      margin: EdgeInsets.only(top: 5),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: property.status == "Sold"
                            ? Colors.red.withOpacity(0.2)
                            : Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        property.status == "Sold"
                            ? "UNFORTUNATELY THIS UNIT HAS BEEN SOLD"
                            : "AVAILABLE",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: property.status == "Sold"
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                    ),
                  ),

                  Spacer(),
                  if (role == "user" && property.status == "Available")
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
                                  child: Text(
                                    "No",
                                    style: TextStyle(color: secondaryColor),
                                  ),
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
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                color: secondaryColor,
                                              ),
                                            ),
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
                                            child: Text(
                                              "Proceed",
                                              style: TextStyle(
                                                color: secondaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Yes",
                                    style: TextStyle(color: secondaryColor),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },

                        child: Text("Request"),
                      ),
                    ),
                  if (role == "admin")
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: property.status == "Sold"
                              ? Colors.green
                              : Colors.red,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Update Property"),
                              content: Text(
                                property.status == "Sold"
                                    ? "Mark this property as Available?"
                                    : "Mark this property as Sold?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(color: secondaryColor),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);

                                    bool success = await updatePropertyStatus(
                                      property.id.toString(),
                                      property.status == "Sold"
                                          ? "Available"
                                          : "Sold",
                                    );

                                    if (success) {
                                      Get.snackbar("Success", "Status updated");
                                      getProperties(); // refresh
                                    } else {
                                      Get.snackbar("Error", "Failed to update");
                                    }
                                  },
                                  child: Text(
                                    "Yes",
                                    style: TextStyle(color: secondaryColor),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text(
                          property.status == "Sold"
                              ? "Mark as Available"
                              : "Mark as Sold",
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
    );
  }
}
