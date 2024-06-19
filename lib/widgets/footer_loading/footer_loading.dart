import 'package:flutter/cupertino.dart';
import 'package:skin_detective/theme/color.dart';

class FooterLoading extends StatelessWidget {
  final bool isLoading;

  const FooterLoading({Key? key, required this.isLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return const SizedBox.shrink();
    }

    return const SizedBox(
      height: 50,
      width: 50,
      child: CupertinoActivityIndicator(
        color: AppColors.gray,
      ),
    );
  }
}
