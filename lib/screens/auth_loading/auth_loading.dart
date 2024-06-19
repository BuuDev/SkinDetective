import 'package:skin_detective/providers/app/app.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AuthLoadingPage extends StatefulWidget {
  const AuthLoadingPage({Key? key}) : super(key: key);

  @override
  State<AuthLoadingPage> createState() => _AuthLoadingPageState();
}

class _AuthLoadingPageState extends State<AuthLoadingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => GetIt.instance.get<AppVM>().middleWareHandle(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        /*  body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Align(
          alignment: Alignment.center,
          child: Image.asset(
            Assets.images.onBoardingIconApp.path,
            fit: BoxFit.cover,
            width: Helper.percentWidth2(
              context: context,
            ),
          ),
        ),
      ), */
        );
  }
}
