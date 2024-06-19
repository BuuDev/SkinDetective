import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_detective/models/spa/spa.dart';
import 'package:skin_detective/services/apis/spa/spa.dart';

import '../../../../../providers/app/app.dart';
import '../../../../../utils/helper/geolocation.dart';

class SpaLogic with ChangeNotifier {
  final BuildContext context;
  List<int?> listSortRadius = [3, 5, 10, 15];
  List<String?> listSortPrice = ['asc', 'desc'];
  List<Spa> spas = [];
  bool isPriceSelected = false;
  bool isRadiusSelected = false;
  int radiusIndex = 0;
  int priceIndex = 0;
  bool isFilter = false;
  Position? position;

  SpaLogic({required this.context}) {
    initData();
  }

  void initData() async {
    final test = await SharedPreferences.getInstance();
    if (GetIt.instance<AppVM>().isLogged) {
      await SpaService.client(isLoading: false)
          .getSpaList(test.getString('lang') ?? 'vn', 100, '', '', '', '')
          .then((spaList) => spas = spaList.data!);

      notifyListeners();
    }
  }

  void onReFresh() {
    resetFilter();
    onSubmitFilter();
  }

  void onChangeRadiusValue(int value) {
    try {
      if (isRadiusSelected && radiusIndex == value) {
        isRadiusSelected = false;
      } else if (!isRadiusSelected) {
        isRadiusSelected = true;
      }
      if (radiusIndex != value) radiusIndex = value;
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

  void onSubmitFilter() async {
    if (isPriceSelected || isRadiusSelected) {
      final test = await SharedPreferences.getInstance();
      isFilter = true;
      // Get current location of user
      await getLocation();
      await SpaService.client(isLoading: false)
          .getSpaList(
              test.getString('lang') ?? 'vn',
              100,
              _sortFilter,
              position!.latitude.toString(),
              position!.longitude.toString(),
              _distanceFilter)
          .then((spaList) => spas = spaList.data!);
    } else {
      isFilter = false;
      initData();
    }
    notifyListeners();
  }

  void onCancel(bool isPriceSelected, int priceIndex, bool isRadiusSelected,
      int radiusIndex) {
    this.isPriceSelected = isPriceSelected;
    this.isRadiusSelected = isRadiusSelected;
    this.priceIndex = priceIndex;
    this.radiusIndex = radiusIndex;
    notifyListeners();
  }

  void resetFilter() {
    isRadiusSelected = false;
    isPriceSelected = false;
    priceIndex = 0;
    radiusIndex = 0;
    notifyListeners();
  }

  void onLoadMore() {
    notifyListeners();
  }

  String get _sortFilter =>
      isPriceSelected ? (priceIndex == 0 ? "asc" : "desc") : '';

  String get _distanceFilter =>
      isRadiusSelected ? '${listSortRadius[radiusIndex]}' : '';

  Future<void> getLocation() async {
    position = await GeoLocationHelper.determinePosition();
    return Future.value();
  }
}
