import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_detective/models/spa/spa.dart';
import 'package:skin_detective/models/spa/spa_service.dart';
import 'package:skin_detective/models/spa/spa_service_id_data.dart';
import 'package:skin_detective/services/apis/spa/spa.dart';

class SpaDetailLogic with ChangeNotifier {
  final Spa spa;
  bool isExpand = false;
  bool isShowButton = false;
  List<ServiceIdDetail> spaServices = [];
  SpaDetailLogic({required this.spa}) {
    initData();
    //print(spa.id);
    getIdServices(spa.id);
  }

  void initData() async {
    final test = await SharedPreferences.getInstance();
    await SpaService.client()
        .getSpaDetail(test.getString('lang') ?? 'vn', spa.id, 100, '{}');

    notifyListeners();
  }

  void getIdServices(int id) async {
    final test = await SharedPreferences.getInstance();

    try {
      var a = await SpaService.client().getSpaIdService(
        test.getString('lang') ?? 'vn',
        id,
      );
      spaServices = a.data;
    } catch (e) {
      debugPrint('$e');
    }

    notifyListeners();
  }

  void onClickExpanded() {
    isExpand = !isExpand;
    notifyListeners();
  }

  void onShowButton() {
    isShowButton = !isExpand;
    notifyListeners();
  }
}
