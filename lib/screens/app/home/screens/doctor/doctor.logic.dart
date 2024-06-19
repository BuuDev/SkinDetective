import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_detective/providers/app/app.dart';
import 'package:skin_detective/services/apis/doctor/doctor.dart';

import '../../../../../models/doctor/doctor.dart';

class DoctorLogic with ChangeNotifier {
  final BuildContext context;
  List<Doctor> doctors = [];
  List<String?> listSortExperience = [
    '0 - 2',
    '2 - 4',
    '4 - 6',
    '6 - 10',
    '10 - 15',
    '15+'
  ];
  List<String?> listSortPrice = ['asc', 'desc'];
  bool isPriceSelected = false;
  bool isExpSelected = false;
  int expIndex = 0;
  int priceIndex = 0;

  bool isFilter = false;

  DoctorLogic({required this.context}) {
    initData();
  }

  void initData() async {
    final test = await SharedPreferences.getInstance();
    if (GetIt.instance<AppVM>().isLogged) {
      await DoctorService.client(isLoading: false)
          .getDoctorList(test.getString('lang') ?? 'vn', 100, '{}')
          .then((doctorList) => doctors = doctorList.data!);
      notifyListeners();
    }
  }

  void onRefresh() {
    resetFilter();
    onChangeFilter();
  }

  void onChangeExpValue(int value) {
    try {
      if (isExpSelected && expIndex == value) {
        isExpSelected = false;
      } else if (!isExpSelected) {
        isExpSelected = true;
      }
      if (expIndex != value) expIndex = value;
    } finally {
      notifyListeners();
    }
  }

  void onChangePriceValue(int value) {
    try {
      if (isPriceSelected && priceIndex == value) {
        isPriceSelected = false;
      } else if (!isPriceSelected) {
        isPriceSelected = true;
      }
      if (priceIndex != value) priceIndex = value;
    } finally {
      notifyListeners();
    }
  }

  void onChangeFilter() async {
    final test = await SharedPreferences.getInstance();
    if (isPriceSelected || isExpSelected) {
      isFilter = true;
      await DoctorService.client(isLoading: false)
          .getDoctorList(test.getString('lang') ?? 'vn', 100,
              '{"sort": "$_sortFilter"${isExpSelected ? ',"exp_year":"$expValue"' : ''}}')
          .then((doctorList) => doctors = doctorList.data!);
    } else {
      isFilter = false;

      initData();
    }
    notifyListeners();
  }

  String get expValue {
    switch (expIndex) {
      case 0:
        return '0';
      case 1:
        return '2';
      case 2:
        return '4';
      case 3:
        return '6';
      case 4:
        return '10';
      case 5:
        return '15';
      default:
        return '0';
    }
  }

  void resetFilter() {
    isPriceSelected = false;
    isExpSelected = false;
    priceIndex = 0;
    expIndex = 0;
    notifyListeners();
  }

  void onCancel(
      bool isPriceSelected, int priceIndex, bool isExpSelected, int expIndex) {
    this.isPriceSelected = isPriceSelected;
    this.isExpSelected = isExpSelected;
    this.priceIndex = priceIndex;
    this.expIndex = expIndex;
    notifyListeners();
  }

  String get _sortFilter =>
      isPriceSelected ? (priceIndex == 0 ? "asc" : "desc") : '';
}
