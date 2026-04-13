import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/controllers/requestscontroller.dart';
import 'package:flutter_application_1/configs/colors.dart';

class RequestsScreen extends StatefulWidget {
  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  final RequestController controller = Get.put(RequestController());
  final user = Get.arguments ?? {};

  @override
  void initState() {
    super.initState();

    final userId = user["id"]?.toString() ?? "";
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
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),

          itemBuilder: (context, index) {
            final req = controller.requests[index];

            final String id = (req['id'] ?? '').toString();
            final String name = (req['name'] ?? 'Property').toString();
            final String price = (req['price'] ?? '0').toString();
            final String image = (req['image'] ?? '').toString();
            final String status = (req['status'] ?? 'Pending').toString();

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
              ),

              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                    child: Image.network(
                      "http://localhost/propertysales/propertyimages/$image",
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(Icons.image, size: 50),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Text(
                          name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),

                        Text("KES $price"),

                        Container(
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
                              color: status == "Approved"
                                  ? Colors.green
                                  : status == "Declined"
                                  ? Colors.red
                                  : Colors.orange,
                            ),
                          ),
                        ),

                        if (status == "Pending")
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              controller.deleteRequest(
                                id,
                                user["id"]?.toString() ?? "",
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
