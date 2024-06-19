import 'package:provider/provider.dart';
import 'package:skin_detective/providers/acne_analyze/acne_analyze.dart';
import 'package:skin_detective/screens/app/face_analysis/face_acne_detail/face_acne_detail.dart';
import 'package:skin_detective/screens/app/face_analysis/face_analysis.dart';
import 'package:skin_detective/screens/app/face_stream/ty_test_camera/face_permission.dart';
import 'package:skin_detective/screens/app/face_stream/face_guide.dart';
import 'package:skin_detective/screens/app/home/home.dart';

import 'package:skin_detective/screens/app/home/screens/analyze/survey/survey.dart';
import 'package:skin_detective/screens/app/home/screens/categories/article/article_detail/article_detail.dart';
import 'package:skin_detective/screens/app/home/screens/categories/article/article_logic.dart';
import 'package:skin_detective/screens/app/home/screens/categories/blog/blog.dart';

import 'package:skin_detective/screens/app/home/screens/categories/blog/blog_detail/blog_detail.dart';
import 'package:skin_detective/screens/app/home/screens/categories/blog/blog_detail/create_comment/create_comment.dart';
import 'package:skin_detective/screens/app/home/screens/categories/categories.logic.dart';
import 'package:skin_detective/screens/app/home/screens/categories/cosmetic/cosmetic.dart';
import 'package:skin_detective/screens/app/home/screens/categories/personal/blog_deltail_personal/blog_detail_personal.dart';

import 'package:skin_detective/screens/app/home/screens/categories/personal/new_post/new_post.dart';
import 'package:skin_detective/screens/app/home/screens/categories/personal/personal.dart';

import 'package:skin_detective/screens/app/home/screens/doctor/doctor.dart';
import 'package:skin_detective/screens/app/home/screens/doctor/doctor.logic.dart';
import 'package:skin_detective/screens/app/home/screens/history_skin_analysis/history_skin_analysis.dart';
import 'package:skin_detective/screens/app/home/screens/history_skin_analysis/history_skin_analysis_logic.dart';
import 'package:skin_detective/screens/app/home/screens/settings/question/question.dart';
import 'package:skin_detective/screens/app/home/screens/settings/Rating/rating.dart';
import 'package:skin_detective/screens/app/home/screens/settings/Terms/term.dart';
import 'package:skin_detective/screens/app/home/screens/spa/spa.dart';
import 'package:skin_detective/screens/app/home/screens/spa_detail/spa_service/spa_service.dart';

import 'package:skin_detective/screens/app/login/login.dart';
import 'package:skin_detective/screens/app/product_detail/product_detail.dart';

import 'package:skin_detective/screens/app/sign_up/sign_up_authen_otp/sign_up_authen_otp.dart';

import 'package:skin_detective/screens/app/sign_up/sign_Up/sign_up.dart';

import 'package:skin_detective/screens/app/sign_up/signup_email_test_error.dart';
import 'package:skin_detective/screens/auth_loading/auth_loading.dart';
import 'package:skin_detective/screens/intro/intro.dart';
import 'package:skin_detective/screens/widgets_custom.dart';

import '../screens/app/forgot_password/authen_otp_forgot_password/authen_otp_password.dart';
import '../screens/app/forgot_password/confirm_email/confirm_email.dart';
import '../screens/app/forgot_password/confirm_password/confirm_password.dart';
import '../screens/app/home/screens/categories/cosmetic/cosmetic_detail/cosmetic_detail.dart';
import '../screens/app/home/screens/spa/spa.logic.dart';
import '../screens/app/sign_up/err_old/err_old.dart';
import '../screens/app/sign_up/signup_email_info/sign_up_email.dart';
import '../screens/app/user_profile/reset_password/reset_password.dart';
import '../screens/app/user_profile/user_profile_setting/user_profile.dart';

class AppRoutes {
  ///Danh sách các providers của widgets
  static const providers = 'providers';

  //Route Names
  static const root = '/';

  //Route Names
  static const intro = '/intro';

  //Widgets customize
  static const widgetsCustom = '/widgets-custom';

  //Authentication
  static const auth = '/auth';
  static const loginPage = '/login';
  static const signUpPage = '/sign-up';

  //App Stack
  static const appStack = '/app';
  static const homePage = '/app/home';
  static const productDetailPage = '/home/product-detail';
  static const facePermission = '/home/face-permission';
  static const skinScanGuide = '/home/face-skin-guide';
  static const faceAnalysis = '/home/face-analysis';
  static const faceResultAcne = '/home/face-result-acne';
  static const faceAcneDetail = '/home/face-acne-detail';
  static const signUpEmailForm = '/sign-up-email-form';
  static const authenOtp = '/auth/authen_otp';
  static const updateInfo = '/update-info';
  static const errOld = '/err-old';
  static const confirmEmail = '/forgot-confirmEmail';
  static const authenOtpPassword = '/authenOtpPassword';
  static const confirmPassword = '/confirmPassword';
  static const userProfile = '/userProfile';
  static const resetPassWord = '/resetPassWord';
  static const doctor = '/doctor';
  static const spa = '/spa';
  static const cosmeticDetail = '/cosmeticDetail';
  static const cosmetic = '/cosmetic';
  static const blogDetailPersonal = '/personal/blogDetailPersonal';
  static const historySkinAnalysis = '/home/historySkinAnalysis';
  static const articleDetail = '/article/detail';
  static const spaServiceDetail = '/spa/spaServiceDetail';

  static const blogDetail = '/blogDetail';
  static const createCommentPage = '/blogDetail/createComment';
  static const newPost = '/new_post';
  static const survey = '/survey';

  //Settings
  static const question = '/app/home/setting/question';
  static const term = '/app/home/setting/term';
  static const rating = '/app/home/setting/rating';

  static final AppRoutes _instance = AppRoutes._();

  AppRoutes._();

  ///This is [instance] of [AppRoutes]
  factory AppRoutes() => _instance;

  ///This is [instance] of [AppRoutes]
  static AppRoutes get instance => _instance;

  Map<String, dynamic> get routesConfig => {
        // root: (_) => const TestLoginThirdParty(),
        root: (_) => const AuthLoadingPage(),
        appStack: {
          providers: [
            ChangeNotifierProvider(create: (context) => AcneAnalyzeVM(context)),
            ChangeNotifierProvider(
                create: (context) => UserProfileLogic(context: context)),
            ChangeNotifierProvider(
              create: (context) => PersonalLogic(context: context),
            ),
            ChangeNotifierProvider(
              create: (context) => BlogLogic(context: context),
            ),
            ChangeNotifierProvider(
              create: (context) => CosMeticLogic(context: context),
            ),
            ChangeNotifierProvider(
              create: (context) => ArticleLogic(context: context),
            ),
            ChangeNotifierProvider(
              create: (context) => HistorySkinAnalysisLogic(context: context),
            ),
            ChangeNotifierProvider(
              create: (context) => SpaLogic(context: context),
            ),
            ChangeNotifierProvider(
              create: (context) => DoctorLogic(context: context),
            ),
            ChangeNotifierProvider(
              create: (context) => CategoriesLogic(context: context),
            ),
          ],
          homePage: (_) => const HomePage(),
          productDetailPage: (_) => const ProductDetailPage(),
          facePermission: (_) => const FacePermission(),
          skinScanGuide: (_) => const SkinScanGuide(),
          faceAnalysis: (_) => const FaceAnalysis(),
          faceAcneDetail: (_) => const FaceAcneDetail(),
          question: (_) => const QuestionScreen(),
          term: (_) => const TermScreen(),
          rating: (_) => const RateScreen(),
          userProfile: (_) => const UserProfile(),
          resetPassWord: (_) => const ResetPass(),
          doctor: (_) => const DoctorPage(),
          spa: (_) => const SpaPage(),
          cosmeticDetail: (_) => const CosmeticDetail(),
          blogDetail: (_) => const BlogDetail(),
          createCommentPage: (_) => const CreateCommentPage(),
          newPost: (_) => const NewPost(),
          blogDetailPersonal: (_) => const BlogDetailPersonal(),
          survey: (_) => const SurveyScreen(),
          historySkinAnalysis: (_) => const HistorySkinAnalysis(),
          cosmetic: (_) => const Cosmetic(),
          articleDetail: (_) => const ArticleDetail(),
          spaServiceDetail: (_) => const ServiceSpa(),
        },
        updateInfo: (_) => const SignUpEmail(),
        errOld: (_) => const ErrOld(),
        auth: {
          loginPage: (_) => const Login(),
          signUpPage: (_) => const SignUp(),
          signUpEmailForm: (_) => const SignUpEmailTestError(),
          authenOtp: (_) => const LoginConfirm(),
          confirmEmail: (_) => const ConFirmEmail(),
          authenOtpPassword: (_) => const AuthenOtpPassword(),
          confirmPassword: (_) => const ConfirmPassword(),
        },
        intro: (_) => const IntroApp(),
        widgetsCustom: (_) => const WidgetsCustom(),
      };
}
