import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:skin_detective/models/spa/service_detail/service_data.dart';
import 'package:skin_detective/services/apis/user/user.dart';

class ServiceLogic with ChangeNotifier {
  late BuildContext context;
  UserService ser = UserService.client(isLoading: false);
  ServiceLogic({required this.context});
  ServiceData? serviceData;

  void getServiceDetail(int id) async {
    final lang = await SharedPreferences.getInstance();
    try {
      var response =
          await ser.getServiceDetail(id, lang.getString('lang') ?? 'vn');
      serviceData = response;

      notifyListeners();
    } catch (e) {
      debugPrint('$e');
    }
  }
}
