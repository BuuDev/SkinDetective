import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/providers/camera/camera_provider.dart';
import 'package:skin_detective/providers/tut_camera/tut_camera_provider.dart';
import 'package:skin_detective/providers/user/user.dart';
import 'package:skin_detective/routes/routes.dart';
import 'package:skin_detective/providers/app/app.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:skin_detective/services/notification/notification.dart';
import 'package:skin_detective/theme/theme.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';

import 'injection.dart';
import 'packages/nested_navigation.dart';
import 'utils/multi_languages/locale_keys.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  await EasyLocalization.ensureInitialized();
  await configurationDependInjection();

  await Firebase.initializeApp();
  NotificationService().initAppSetting();

  runApp(
    EasyLocalization(
      supportedLocales: LocaleKeys.supportedLocales,
      path: Assets
          .translations.langs, // <-- change the path of the translation files
      assetLoader: CsvAssetLoader(),
      startLocale: LocaleKeys.supportedLocales[0],
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => GetIt.instance.get<AppVM>(),
          ),
          ChangeNotifierProvider(
            create: (context) => GetIt.instance.get<UserViewModel>(),
          ),
          ChangeNotifierProvider(create: (_) => CameraProvider()),
          ChangeNotifierProvider(create: (_) => TutCameraProvider()),
        ],
        child: MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          debugShowCheckedModeBanner: false,
          darkTheme: AppTheme.dark,
          theme: AppTheme.light,
          locale: context.locale,
          navigatorKey: GetIt.instance.get<GlobalKey<NavigatorState>>(),
          title: 'Skin Detective',
          onGenerateRoute: (settings) => generateRoute(
            settings,
            AppRoutes().routesConfig,
          ),
        ),
      ),
    );
  }
}
