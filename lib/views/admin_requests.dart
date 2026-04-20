import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/configs/colors.dart';
import 'package:get/get.dart';

class AdminRequestsScreen extends StatefulWidget {
  const AdminRequestsScreen({super.key});

  @override
  State<AdminRequestsScreen> createState() => _AdminRequestsScreenState();
}

class _AdminRequestsScreenState extends State<AdminRequestsScreen> {
  List requests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  // FETCH REQUESTS
  Future<void> fetchRequests() async {
    try {
      final res = await http.get(
        Uri.parse("http://10.215.76.151/propertysales/admin_readrequests.php"),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        // handle both formats
        if (data is Map && data.containsKey("data")) {
          requests = data["data"];
        } else {
          requests = data;
        }

        setState(() {});
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load requests");
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // UPDATE STATUS
  Future<bool> updateStatus(String id, String status) async {
    try {
      final res = await http.post(
        Uri.parse(
          "http://10.215.76.151/propertysales/update_requeststatus.php",
        ),
        body: {"id": id, "status": status},
      );

      final data = jsonDecode(res.body);

      if (data["success"] == 1) {
        await fetchRequests();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Update Error: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Admin Requests"),
        centerTitle: true,
      ),

      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : requests.isEmpty
          ? Center(child: Text("No requests available"))
          : GridView.builder(
              padding: EdgeInsets.all(10),
              itemCount: requests.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 0.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                var req = requests[index];

                final String id = req['id'].toString();
                final String name = req['fullname'] ?? "User";
                final String phone = req['phonenumber'] ?? "";
                final String propertyname = req['name'] ?? "Property";
                final String location = req['location'] ?? "";
                final String price = req['price'] ?? "0";
                final String image = req['image'] ?? "";
                final String status = req['status'] ?? "Pending";
                final String date = (req['requestdate'] ?? "No date")
                    .toString();

                return Container(
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // IMAGE
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          "http://10.215.76.151/propertysales/propertyimages/$image",
                          height: 230,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              Icon(Icons.image_not_supported),
                        ),
                      ),

                      SizedBox(height: 8),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "Client Name : $name",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "Property Name : $propertyname",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text("Phone: $phone"),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(price),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(location, style: TextStyle(fontSize: 12)),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "Date: $date",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),

                      // STATUS TAG
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                          margin: EdgeInsets.only(top: 5),
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: status == "Approved"
                                ? Colors.green.withOpacity(0.2)
                                : status == "Declined"
                                ? Colors.red.withOpacity(0.2)
                                : Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              fontSize: 12,
                              color: status == "Approved"
                                  ? Colors.green
                                  : status == "Declined"
                                  ? Colors.red
                                  : Colors.orange,
                            ),
                          ),
                        ),
                      ),

                      Spacer(),

                      // ACTION BUTTONS
                      if (status == "Pending")
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text("Approve Request"),
                                        content: Text(
                                          "Are you sure you want to approve this request?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text(
                                              "No",
                                              style: TextStyle(
                                                color: secondaryColor,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.pop(context);

                                              bool success = await updateStatus(
                                                id,
                                                "Approved",
                                              );

                                              if (success) {
                                                Get.snackbar(
                                                  "Success",
                                                  "Request Approved",
                                                );
                                              } else {
                                                Get.snackbar(
                                                  "Error",
                                                  "Failed to approve",
                                                );
                                              }
                                            },
                                            child: Text(
                                              "Yes",
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
                                    "Approve",
                                    style: TextStyle(color: backgroundColor),
                                  ),
                                ),
                              ),

                              SizedBox(width: 5),

                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text("Decline Request"),
                                        content: Text(
                                          "Are you sure you want to decline this request?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text("No"),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.pop(context);

                                              bool success = await updateStatus(
                                                id,
                                                "Declined",
                                              );

                                              if (success) {
                                                Get.snackbar(
                                                  "Success",
                                                  "Request Declined",
                                                );
                                              } else {
                                                Get.snackbar(
                                                  "Error",
                                                  "Failed to decline",
                                                );
                                              }
                                            },
                                            child: Text("Yes"),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Decline",
                                    style: TextStyle(color: backgroundColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
