import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skin_detective/constants/type_globals.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/routes/routes.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/widgets/button_widget/button_widget.dart';

class OnFaceScreen extends StatefulWidget {
  final String backgroundScreen;
  final String imageCaption;
  final String caption;
  final String description;
  final String labelButton;
  final bool? preBack;
  final bool? next;
  final Function(BuildContext context)? nextPage;
  final Function(BuildContext context)? prePage;

  const OnFaceScreen({
    Key? key,
    required this.backgroundScreen,
    required this.imageCaption,
    required this.caption,
    required this.description,
    required this.labelButton,
    this.preBack,
    this.next,
    this.nextPage,
    this.prePage,
  }) : super(key: key);

  @override
  State<OnFaceScreen> createState() => _OnFaceScreenState();
}

class _OnFaceScreenState extends State<OnFaceScreen> {
  Widget getButton(BuildContext context) {
    if (widget.preBack ?? false) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 25.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: () {
                  if (widget.prePage != null) {
                    widget.prePage!(context);
                  }
                },
                child: SizedBox(
                  height: 48,
                  child: SvgPicture.asset(
                    Assets.icons.arrowLeftBack,
                    color: AppColors.primary,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0.0,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6),
            ),
            Expanded(
              flex: 3,
              child: ButtonWidget(
                child: Text(
                  widget.labelButton,
                  style: Theme.of(context).textTheme.bodyText1!.merge(
                        const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                ),
                onPressed: () {
                  if (widget.next != null) {
                    widget.nextPage!(context);
                  } else {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.facePermission,
                    );
                  }
                },
                primary: AppColors.primary,
              ),
            )
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: ButtonWidget(
        onPressed: () {
          if (widget.nextPage != null) {
            widget.nextPage!(context);
          }
        },
        child: Text(
          widget.labelButton,
          style: Theme.of(context).textTheme.bodyText1!.merge(
                const TextStyle(
                    color: AppColors.white, fontWeight: FontWeight.bold),
              ),
        ),
        type: EButton.full,
        primary: AppColors.primary,
        elevation: 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Image.asset(
            widget.backgroundScreen,
            fit: BoxFit.cover,
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color.fromRGBO(32, 32, 32, 0),
                Color.fromRGBO(32, 32, 32, 0.92),
              ],
              begin: Alignment.center,
              end: Alignment.bottomCenter,
            )),
          ),
        ),
        Positioned(
          right: 0,
          left: 0,
          bottom: MediaQuery.of(context).size.height * 0.05,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16, left: 5),
                  child: SvgPicture.asset(widget.imageCaption),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    widget.caption,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.caption!.merge(
                          const TextStyle(
                              fontSize: 22,
                              color: AppColors.white,
                              fontWeight: FontWeight.bold),
                        ),
                  ).tr(),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 21,
                  ),
                  child: Text(
                    widget.description,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.caption!.merge(
                          const TextStyle(
                            fontSize: 12,
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  ).tr(),
                ),
                getButton(context),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
