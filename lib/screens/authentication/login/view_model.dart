part of 'login.dart';

class _BusinessLogic with ChangeNotifier {
  final BuildContext context;

  _BusinessLogic(this.context);

  void login() {
    NavigationService.gotoAppStack();
  }
}
