import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:skin_detective/models/setting_device/setting_device.dart';
import 'package:skin_detective/providers/app/app.dart';
import 'package:skin_detective/services/apis/user/user.dart';
import 'package:skin_detective/services/local_storage.dart';
import 'package:skin_detective/theme/color.dart';

class NotificationService {
  static final NotificationService _internal = NotificationService._singleton();
  StreamSubscription<RemoteMessage>? _streamOnForeground;
  StreamSubscription<RemoteMessage>? _streamOnOpened;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    ledColor: AppColors.primary,
    enableLights: true,
    importance: Importance.max,
  );

  factory NotificationService() => _internal;
  NotificationService._singleton();

  Future<void> initialize() async {
    try {
      bool isAuthorized = await _internal.requestPermission();
      String? token = await FirebaseMessaging.instance.getToken();
      if (!isAuthorized || token == null || token.isEmpty) {
        LocalStorage().fcmToken = '';
        return;
      }

      debugPrint('Fcm Token Device: $token');

      await _setupForegroundMessage();
      _streamOnForeground =
          FirebaseMessaging.onMessage.listen(_onMessageForeground);

      ///Update fcm token to local
      if (LocalStorage.instance.fcmToken.isEmpty &&
          GetIt.instance<AppVM>().isLogged) {
        registerFcmToken(token);
      }

      LocalStorage.instance.fcmToken = token;

      FirebaseMessaging.onBackgroundMessage(_onMessageBackground);
      _streamOnOpened =
          FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpened);

      return Future.value();
    } catch (error) {
      debugPrint('$error');
      return Future.error(error);
    }
  }

  static void registerFcmToken(String? fcmToken) async {
    try {
      //update fcm_token to server in here
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      late String? uniqueId;

      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        uniqueId = build.androidId;
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        uniqueId = data.identifierForVendor;
      }
      UserService service = UserService.client(isLoading: false);
      SettingDevice data = await service.getSettingUser();
      if (fcmToken != null) {
        service.updateInfoDevice(
          fcmToken: fcmToken,
          deviceId: uniqueId,
          os: Platform.operatingSystem,
          newCategory: data.newCategory,
          yourWriting: data.yourWriting,
          direction: data.direction,
        );
      }
    } catch (_) {
      debugPrint('Failed to get platform version');
    }
  }

  void _onMessageForeground(RemoteMessage remoteMessage) {
    debugPrint('onForeground: ${remoteMessage.data}');
    if (Platform.isAndroid) {
      try {
        flutterLocalNotificationsPlugin.show(
          remoteMessage.notification.hashCode,
          remoteMessage.notification?.title ?? '',
          remoteMessage.notification?.body ?? '',
          NotificationDetails(
              android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            priority: Priority.high,
            importance: Importance.max,
          )),
        );
      } catch (error) {
        debugPrint('$error');
      }
    }
  }

  void _onMessageOpened(RemoteMessage remoteMessage) async {
    debugPrint('onPressedNotify: ${remoteMessage.data}');
  }

  static Future<void> _onMessageBackground(RemoteMessage remoteMessage) {
    debugPrint('onBackground: ${remoteMessage.data}');

    return Future.value();
  }

  Future<void> _setupForegroundMessage() async {
    if (Platform.isIOS) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true,
      );
    } else {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  Future<bool> requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.getNotificationSettings();

    if (checkAcceptedPermission(settings.authorizationStatus)) {
      ///App has pre-setup, so we don't need re-setup
      return true;
    }

    settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    return checkAcceptedPermission(settings.authorizationStatus);
  }

  static bool checkAcceptedPermission(AuthorizationStatus status) {
    debugPrint('Status notification: $status');
    switch (status) {
      case AuthorizationStatus.authorized:
        return true;
      default:
        return false;
    }
  }

  void initAppSetting() {
    if (Platform.isAndroid) {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/launcher_icon');

      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);
      flutterLocalNotificationsPlugin.initialize(initializationSettings);
    }
  }

  removeToken() {
    FirebaseMessaging.instance.deleteToken();
  }

  dispose() {
    _streamOnForeground?.cancel();
    _streamOnOpened?.cancel();
  }
}
