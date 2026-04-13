import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RequestController extends GetxController {
  var requests = [].obs;
  var isLoading = true.obs;

  Future<void> fetchRequests(String userId) async {
    try {
      final response = await http.get(
        Uri.parse(
          "http://localhost/propertysales/readrequests.php?user_id=$userId",
        ),
      );

      if (response.statusCode == 200) {
        requests.value = jsonDecode(response.body); // ✅ THIS FIXES YOUR ERROR
      }
    } catch (e) {
      print("ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteRequest(String id, String userId) async {
    try {
      await http.post(
        Uri.parse("http://localhost/propertysales/deleterequest.php"),
        body: {"id": id},
      );

      fetchRequests(userId); // refresh
    } catch (e) {
      print("DELETE ERROR: $e");
    }
  }
}
