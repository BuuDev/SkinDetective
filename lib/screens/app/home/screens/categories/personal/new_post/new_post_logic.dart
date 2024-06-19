part of 'new_post.dart';

class NewPostLogic with ChangeNotifier {
  late BuildContext context;

  late PersonalLogic personal;

  int? postId;

  NewPostLogic({required this.context}) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      postId = ModalRoute.of(context)!.settings.arguments as int?;
      personal = context.read<PersonalLogic>();
      if (postId != null) {
        getPostUserDetail(postId!);
        check = true;
        enable = true;
      }
    });
  }
  bool check = false;
  PostService service = PostService.client(isLoading: false);
  BlogDetailPersonalService update =
      BlogDetailPersonalService.client(isLoading: false);
  TextEditingController txtTitle = TextEditingController(text: '');
  TextEditingController txtContent = TextEditingController(text: '');
  bool enable = false;
  CreatePostData? data;

  final ImagePicker picker = ImagePicker();
  List<XFile>? image = [];
  List<File> file = [];
  List<Images>? updateImage = [];
  String lstDeleteImage = '';

  Future<void> getPostUserDetail(int id) async {
    try {
      final lang = await SharedPreferences.getInstance();
      data = await service.getPostUserDetail(
          id, 'post', lang.getString('lang') ?? 'vn');
      txtTitle.text = data!.detail.title;
      txtContent.text = data!.detail.content;
      updateImage!.addAll(data!.images!);
      notifyListeners();
    } catch (err) {
      debugPrint('$err');
    }
  }

  void selectImage() async {
    image = await picker.pickMultiImage();
    if (image!.isNotEmpty) {
      if (image!.length > 3) {
        NotifyHelper.showSnackBar(
            LocaleKeys.generalMessageErrorSelectMaxImage.tr() + ' 3');
      } else {
        image?.forEach((item) {
          file.add(File(item.path));
          notifyListeners();
        });
      }
    }
    if (file.length > 3) {
      for (int i = 3; i < file.length; i++) {
        file.removeAt(i);
      }
      notifyListeners();
      /*   NotifyHelper.showSnackBar(
          LocaleKeys.generalMessageErrorSelectMaxImage.tr() +
              ' ${file.length}'); */
    }
    notifyListeners();
  }

  void showNotification(String title, String subtitle) {
    showDialog(
        //barrierDismissible: dismissible ? true : false,
        barrierColor: AppColors.textLightGrayBG.withOpacity(0.6),
        context: context,
        builder: (context) {
          return CustomDialog(
            height: 250,
            icon: SvgPicture.asset(
              Assets.icons.upStatus,
              height: 80,
            ),
            title: title,
            titleColor: AppColors.textBlack,
            subtitle: subtitle,
          );
        });
  }

  void removeImage(index) {
    file.removeAt(index);

    notifyListeners();
  }

  void deleteImageUpdate(index) {
    for (var i = 0; i < updateImage!.length; i++) {
      if (index == i) {
        lstDeleteImage += updateImage![i].id.toString().trim() + ',';
        break;
      }
    }
    updateImage!.removeAt(index);
    notifyListeners();
  }

  void activeRadioButton() {
    check = !check;
    if (check &&
        txtTitle.text.trim().isNotEmpty &&
        txtContent.text.trim().isNotEmpty) {
      enable = true;
    } else {
      enable = false;
    }

    notifyListeners();
  }

  Future<void> updatePost(String status) async {
    try {
      if (file.isNotEmpty) {
        await service.updatePost(postId!, lstDeleteImage, txtTitle.text,
            txtContent.text, status, file);

        personal.changeXemThemPost();

        clean();
        Future.delayed(const Duration(seconds: 2), () {
          NavigationService.popUntil(ModalRoute.withName(AppRoutes.homePage));
        });
      } else {
        await service.updatePost(
            postId!, lstDeleteImage, txtTitle.text, txtContent.text, status);

        personal.changeXemThemPost();
        clean();
        Future.delayed(const Duration(seconds: 2), () {
          NavigationService.popUntil(ModalRoute.withName(AppRoutes.homePage));

          notifyListeners();
        });
      }
    } catch (err) {
      debugPrint('$err');
    }
  }

  Future<void> createPost() async {
    try {
      if (postId == null) {
        if (enable) {
          await service.createPost(
              txtTitle.text, 'waiting', txtContent.text, check, file);
          personal.changeXemThemPost();
          clean();

          showNotification(
            LocaleKeys.createPostPopupTitle.tr(),
            LocaleKeys.createPostPopupContent.tr(),
          );
          Future.delayed(const Duration(seconds: 2), () {
            NavigationService.popUntil(ModalRoute.withName(AppRoutes.homePage));
          });
        }
      } else {
        showNotification(
          LocaleKeys.createPostPopupTitle.tr(),
          LocaleKeys.createPostPopupContent.tr(),
        );
        return updatePost('waiting');
      }
    } catch (err) {
      debugPrint('$err');
    }
  }

  Future<void> createDraft() async {
    try {
      if (postId == null) {
        if (enable) {
          await service.createPost(
              txtTitle.text, 'draft', txtContent.text, check, file);
          clean();
          personal.changeXemThemPost();
          showNotification(
              LocaleKeys.createPostPopupDraftContent.tr(), ''.tr());
          Future.delayed(const Duration(seconds: 2), () {
            NavigationService.popUntil(ModalRoute.withName(AppRoutes.homePage));
          });
        }
      } else {
        showNotification(LocaleKeys.createPostPopupDraftContent.tr(), '');
        return updatePost('draft');
      }
    } catch (err) {
      debugPrint('$err');
    }
  }

  void clean() {
    txtTitle.clear();
    txtContent.clear();
    check = false;
    enable = false;
    file = [];
    updateImage = [];
    notifyListeners();
  }

  void validate() {
    if (check &&
        txtTitle.text.trim().isNotEmpty &&
        txtContent.text.trim().isNotEmpty) {
      enable = true;
    } else {
      enable = false;
    }

    notifyListeners();
  }

  void delete() async {
    if (enable) {
      showDialog(
          barrierColor: AppColors.textLightGrayBG.withOpacity(0.6),
          context: context,
          builder: (context) {
            return CustomDialog(
              height: Helper.percentHeight(pixel: 190, context: context),
              width: Helper.percentWidth(pixel: 251, context: context),
              icon: SvgPicture.asset(
                Assets.icons.delete,
                height: 56,
              ),
              title: LocaleKeys.postDetailUpdateStatusDelete.tr(),
              subtitle: LocaleKeys.deletePostPopupContent.tr(),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 9, right: 9),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ButtonWidget(
                          type: EButton.normal,
                          onPressed: () async {
                            if (postId == null) {
                              clean();
                              Navigator.of(context, rootNavigator: false).pop();
                            } else {
                              await update.getUsers(postId!, 'delete');
                              clean();

                              Navigator.of(context, rootNavigator: false).pop();

                              personal.changeXemThemPost();

                              NotifyHelper.showSnackBar(
                                  LocaleKeys.deletePostPopupContentDelet.tr());

                              NavigationService.popUntil(
                                  ModalRoute.withName(AppRoutes.homePage));
                            }
                          },
                          primary: AppColors.red,
                          child: Text(
                            LocaleKeys.accept.tr(),
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: AppFonts.font_14,
                                      fontFamily:
                                          Assets.googleFonts.montserratSemiBold,
                                    ),
                          ).tr(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ButtonWidget(
                          type: EButton.normal,
                          primary: AppColors.textLightGrayBG,
                          onPressed: () async {
                            await service.createPost(txtTitle.text, 'draft',
                                txtContent.text, check, file);
                            clean();
                            Navigator.of(context, rootNavigator: false).pop();

                            showNotification(
                                LocaleKeys.createPostPopupDraftContent.tr(),
                                '');

                            personal.changeXemThemPost();
                            Navigator.of(context, rootNavigator: false).pop();
                            NavigationService.popUntil(
                                ModalRoute.withName(AppRoutes.homePage));
                          },
                          child: Text(
                            LocaleKeys.createPostDraftButton.tr(),
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: AppColors.textBlack,
                                      fontSize: AppFonts.font_14,
                                      fontWeight: FontWeight.w600,
                                      fontFamily:
                                          Assets.googleFonts.montserratSemiBold,
                                    ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          });
    }
  }
}
