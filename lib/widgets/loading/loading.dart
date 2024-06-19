import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:skin_detective/services/navigation.dart';
import 'package:skin_detective/theme/color.dart';

class Loading {
  static OverlayEntry? _overlay;
  static __LoadingState? _loading;
  static void show() {
    if (_overlay != null) {
      return;
    }
    _loading = __LoadingState();
    _overlay = OverlayEntry(builder: (BuildContext context) => _loading!);
    Navigator.of(NavigationService.context).overlay!.insert(_overlay!);
  }

  static void hide([void Function()? completion]) {
    try {
      _overlay?.remove();
        _overlay = null;
        _loading = null;
        if (completion != null) {
          completion();
        }
    } catch (error) {
      debugPrint('$error');
    }
  }
}


class __LoadingState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black.withAlpha(5),
      child: Center(
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.black.withAlpha(70)),
          child: const Center(
            child: SpinKitFadingFour(
              size: 30,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
