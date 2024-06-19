import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:skin_detective/utils/notify_helper/notify_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class URLLauncher {
  static Future<void> openMap(String lat, String lng) async {
    String url = '';
    String urlAppleMaps = '';

    try {
      if (Platform.isIOS) {
        urlAppleMaps = 'https://maps.apple.com/?q=$lat,$lng';
        url = 'comgooglemaps://?saddr=&daddr=$lat,$lng&directionsmode=driving';
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          await launch(urlAppleMaps);
        }
      } else {
        /// *** Notes: Ko dùng canLaunch cho android vì hàm đang chạy ko đúng với android OS (url_launcher: ^6.0.20). Refer: https://github.com/flutter/flutter/issues/82496
        url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
        await launch(url);
      }
    } catch (e) {
      NotifyHelper.showSnackBar('Could not launch $url');
    }
  }

  static Future<void> openWebsite(String website) async {
    try {
      if (!website.contains("http")) website = "http://" + website;
      await launch(website);
    } catch (e) {
      debugPrint('$e');
      NotifyHelper.showSnackBar('Could not launch $website');
    }
  }

  static Future<void> openPhone(String phoneNum) async {
    try {
      await launch("tel://$phoneNum");
    } catch (e) {
      debugPrint('$e');
      NotifyHelper.showSnackBar('Could not launch $phoneNum');
    }
  }
}
