class RoutePathApi {
  ///POST
  static const String getCosmetic = '/posts';
  static const String getBlog = '/posts';
  static const String getHomeBlog = '/home/posts';
  static const String getHomeCosmetic = '/home/posts';
  static const String getHomePost = '/home/posts';
  static const String createPost = '/post/create';
  static const String getSaveCosmetic = '/saved-posts';
  static const String getSaveBlog = '/saved-posts';
  static const String updatePost = '/post/{id}/update';
  static const String postUser = '/user/post';
  static const String postUserDetail = '/post/{id}';

  ///System_Params
  static const String systemParams = '/system-params';

  ///Login
  static const String forgotPassword = '/forgot-password';
  static const String confirmOtp = '/confirm-otp';
  static const String resetPassword = '/reset-password';

  ///Account
  static const String activeAccount = '/account/active';
  static const String updateAccount = '/account/update';
  static const String accountChangePassword = '/account/change-Password';

  ///National
  static const String nationals = '/nationals';
  //login
  static const String login = '/login';

  //analysis
  static const String analysisHistories = '/analysis/histories';
  static const String analysisDelete = '/analysis/delete';
  static const String resultAnalyze = '/analysis/result';
  static const String detailAnalyze = '/analysis/{id}';
  static const String cancelAnalyze = '/analysis/cancel';

  //comment
  static const String createComment = '/comment/create';
  static const String deleteComment = '/comment/delete/{id}';
  static const String comments = '/comments/{id}';

  //device-info
  static const String updateInfoDevice = '/info-device/update';
  static const String userSetting = '/user-setting';

  //post-detail
  static const String postDetail = '/post/{id}';
  static const String savePost = '/post/{id}/save';
  static const String updateStatusPost = '/post/{id}/update-status';

  //register
  static const String register = '/register';

  //get tips
  static const String tips = '/tips';

  //survey
  static const String survey = '/survey';
  static const String surveyAnswers = '/survey/answer';
  static const String popUp = '/survey/check';

  //Spa
  static const String spa = '/spas';
  static const String spaDetail = '/spa/{id}';
  static const String serviceDetail = '/service/{id}';
  static const String spaIdService = '/spa/{id}/service';

  //Doctor
  static const String doctors = '/doctors';
  static const String doctorsDetail = '/doctor/{id}';

  //rating
  static const String averageRating = '/review/pointaverage';
}
