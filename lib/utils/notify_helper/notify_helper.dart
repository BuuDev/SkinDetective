import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class NotifyHelper {
  static void showSnackBar(String message) {
    var context =
        GetIt.instance.get<GlobalKey<NavigatorState>>().currentState!.context;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
