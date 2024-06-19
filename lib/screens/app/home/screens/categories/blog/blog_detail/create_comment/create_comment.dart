import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skin_detective/constants/type_globals.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/widgets/app_bar_widget/app_bar_widget.dart';
import '../../../../../../../../widgets/button_widget/button_widget.dart';

class CreateCommentPage extends StatefulWidget {
  const CreateCommentPage({Key? key}) : super(key: key);

  @override
  State<CreateCommentPage> createState() => _CreateCommentPageState();
}

class _CreateCommentPageState extends State<CreateCommentPage> {
  late TextEditingController controller;

  ValueNotifier<bool> isDisable = ValueNotifier(true);

  @override
  void initState() {
    controller = TextEditingController(text: '');
    super.initState();
  }

  void onTextChange(String text) {
    isDisable.value = text.isEmpty;
  }

  void onComment() {
    if (controller.text.trim() != "") {
      Navigator.pop(context, controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBarWidget(
        title: LocaleKeys.generalBack.tr(),
        centerTitle: false,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    LocaleKeys.commentCreateTitle.tr(),
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          color: AppColors.textBlueBlack,
                          fontWeight: FontWeight.bold,
                          fontFamily: Assets.googleFonts.montserratBold,
                        ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(
                  LocaleKeys.createPostContentLable.tr(),
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: AppColors.textBlueBlack,
                        fontWeight: FontWeight.bold,
                        fontFamily: Assets.googleFonts.montserratBold,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Container(
                  color: Colors.transparent,
                  width: double.infinity,
                  height: size / 1.6,
                  child: TextField(
                    controller: controller,
                    onChanged: onTextChange,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: AppColors.textBlack,
                        ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.backgroundColor,
                      enabled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: AppColors.textBlue,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: LocaleKeys.createPostContentPlaceholder.tr(),
                      hintStyle:
                          Theme.of(context).textTheme.subtitle1!.copyWith(
                                color: AppColors.textLightGray,
                              ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    maxLines: size ~/ 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 24).copyWith(bottom: 50),
        child: ValueListenableBuilder<bool>(
          valueListenable: isDisable,
          builder: (_, disabled, __) {
            return ButtonWidget(
              type: EButton.full,
              onPressed: onComment,
              child: Text(LocaleKeys.createCommentButton.tr()),
              primary: disabled ? AppColors.textLightGray : AppColors.primary,
            );
          },
        ),
      ),
    );
  }
}
