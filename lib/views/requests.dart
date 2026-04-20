import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/controllers/requestscontroller.dart';
import 'package:flutter_application_1/configs/colors.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  final RequestController controller = Get.put(RequestController());
  late String userId = "";
  @override
  void initState() {
    super.initState();

    final user = Get.arguments ?? {};
    userId = user["id"]?.toString() ?? "";

    print("REQUEST USER ID: $userId");

    controller.fetchRequests(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("My Requests"),
        centerTitle: true,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.requests.isEmpty) {
          return Center(
            child: Text(
              "No requests at the moment",
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return GridView.builder(
          padding: EdgeInsets.all(10),
          itemCount: controller.requests.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 0.68,
            // crossAxisSpacing: 10,
            // mainAxisSpacing: 10,
          ),

          itemBuilder: (context, index) {
            final req = controller.requests[index];

            final String id = (req['id'] ?? '').toString();
            final String name = (req['name'] ?? 'Property').toString();
            final String location = (req['location'] ?? '').toString();
            final String price = (req['price'] ?? '0').toString();
            final String image = (req['image'] ?? '').toString();
            final String status = (req['status'] ?? 'Pending').toString();

            return Padding(
              padding: const EdgeInsets.all(8.0),

              child: Container(
                decoration: BoxDecoration(
                  color: secondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        "http://10.215.76.151/propertysales/propertyimages/$image",
                        height: 350,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            Icon(Icons.image_not_supported),
                      ),
                    ),

                    SizedBox(height: 10),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: Colors.grey),
                          SizedBox(width: 5),
                          Expanded(child: Text(location)),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Icon(Icons.money, size: 16, color: Colors.green),
                          SizedBox(width: 5),
                          Text(price),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
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

                    if (status == "Pending")
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Delete Request"),
                                content: Text(
                                  "Are you sure you want to delete this request?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("No"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);

                                      bool success = await controller
                                          .deleteRequest(id, userId);

                                      if (success) {
                                        Get.snackbar(
                                          "Success",
                                          "Request deleted successfully",
                                          snackPosition: SnackPosition.BOTTOM,
                                        );

                                        // REFRESH LIST
                                        controller.fetchRequests(userId);
                                      } else {
                                        Get.snackbar(
                                          "Error",
                                          "Failed to delete request",
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                      }
                                    },
                                    child: Text("Yes"),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Text("Delete Request"),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
