import 'package:flutter_application_1/views/propertytype.dart';
import 'package:get/state_manager.dart';

class Propertiescontroller extends GetxController {
  var loadingProperties = true.obs;
  var propertyList = <Propertytype>[].obs;

  void updatePropertyList(List<Propertytype> properties) {
    propertyList.clear();
    propertyList.assignAll(properties);
    loadingProperties.value = false;
  }
}
