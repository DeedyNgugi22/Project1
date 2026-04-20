import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RequestController extends GetxController {
  var requests = [].obs;
  var isLoading = true.obs;

  Future<void> fetchRequests(String userId) async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse(
          "http://10.215.76.151/propertysales/readrequests.php?userid=$userId",
        ),
      );

      print("REQUEST RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        requests.value = data['data'] ?? [];
      }
    } catch (e) {
      print("ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }

  //DELETE REQUEST
  Future<bool> deleteRequest(String id, String userId) async {
    try {
      final response = await http.post(
        Uri.parse("http://10.215.76.151/propertysales/deleterequest.php"),
        body: {"id": id},
      );

      var result = jsonDecode(response.body);

      if (result["success"] == 1) {
        // refresh list AFTER delete
        await fetchRequests(userId);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("DELETE ERROR: $e");
      return false;
    }
  }
}
