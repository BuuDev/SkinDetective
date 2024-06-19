import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_detective/models/doctor/doctor.dart';
import 'package:skin_detective/services/apis/doctor/doctor.dart';

class DoctorDetailLogic with ChangeNotifier {
  final Doctor doctor;
  bool isShowButton = false;
  bool isExpand = false;

  DoctorDetailLogic({required this.doctor}) {
    initData();
  }

  void initData() async {
    final test = await SharedPreferences.getInstance();
    await DoctorService.client()
        .getDoctorDetail(test.getString('lang') ?? 'vn', doctor.id, 100, '{}')
        .then((doctor) => doctor);

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
