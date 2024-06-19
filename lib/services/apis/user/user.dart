import 'dart:io';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:skin_detective/config/route_path_api.dart';
import 'package:skin_detective/models/article_detail/article_detail_data.dart';
import 'package:skin_detective/models/blog_detail/blog_detail_data.dart';
import 'package:skin_detective/models/changePass/change_pass.dart';
import 'package:skin_detective/models/conFirmPassWord/confirmdata.dart';
import 'package:skin_detective/models/cosmetic_detail/cosmetic_detail_data.dart';
import 'package:skin_detective/models/national/national_data.dart';

import 'package:skin_detective/models/otpAuthen/verify_otp_response.dart';
import 'package:skin_detective/models/pagination/pagination.dart';
import 'package:skin_detective/models/posts/posts.dart';
import 'package:skin_detective/models/setting_device/setting_device.dart';
import 'package:skin_detective/models/spa/service_detail/service_data.dart';
import 'package:skin_detective/models/tips/tips.dart';

import 'package:skin_detective/models/user/user.dart';
import 'package:skin_detective/models/user_info/user_info.dart';
import 'package:skin_detective/models/user_setting/user_setting.dart';
import 'package:skin_detective/services/api_client.dart';

part 'user.g.dart';

@RestApi()
abstract class UserService {
  // Nếu muốn custom baseURL thì dùng thằng này
  factory UserService(Dio dio, {String baseUrl}) = _UserService;
  // Nên khởi tạo bằng thằng này
  factory UserService.client({bool? isLoading}) {
    return UserService(
        ClientApi().init()..options.headers['isLoading'] = isLoading);
  }

  @GET("/get-info")
  Future<User> getInfo();

  @GET(RoutePathApi.nationals)
  Future<List<DataNational>> getNational();

  @GET("/token/refresh")
  Future<UserInfo> refreshToken(@Header('Authorization') authorization);

  @POST("/login")
  @FormUrlEncoded()
  Future<UserInfo> getLogin(@Field("email") email, @Field("password") password);

  @POST("/login-google")
  Future<UserInfo> loginByGoogle(@Query('token') String token);

  @POST("/login-facebook")
  Future<UserInfo> loginByFacebook(@Query('token') String token);

  @POST("/login-apple")
  Future<UserInfo> loginByApple(@Body() Map<String, dynamic> data);

  @POST(RoutePathApi.activeAccount)
  Future<UserInfo> verifyOtp(
    @Query('email') String email,
    @Query('otp') String otp,
  );

  @POST(RoutePathApi.register)
  Future<User> register(
      @Query("email") String email, @Query("password") String password);

  @POST(RoutePathApi.updateAccount)
  @MultiPart()
  Future<User> updateAccount(
      @Query("name") String name,
      @Query("year_of_birth") int yearOfBirth,
      @Query("nationality_id") int nationalityId,
      [@Part(name: "avatar") File? avatar]);

  @POST(RoutePathApi.forgotPassword)
  Future<AuthenOtp> confirmEmail(
    @Query('email') String email,
  );

  @POST(RoutePathApi.confirmOtp)
  Future<Data> verityOtpPassword(
    @Query('email') String email,
    @Query('otp') String otp,
  );

  @POST(RoutePathApi.resetPassword)
  Future<AuthenOtp> resetPassword(
    @Query('email') String email,
    @Query('token') String token,
    @Query('password') String password,
  );

  @POST(RoutePathApi.accountChangePassword)
  Future<ChangePass> changePassWord(
    @Query('old_password') String oldPass,
    @Query('new_password') String newPass,
    @Query('confirm_password') String confirmPass,
  );

  @GET(RoutePathApi.postDetail)
  Future<BlogDetailData> getBlogDetail(@Path('id') int id,
      @Query('type') String type, @Header('language') String lang);

  @GET(RoutePathApi.postDetail)
  Future<CosmeticDetailData> getCosmeticDetail(@Path('id') int id,
      @Query('type') String type, @Header('language') String lang);

  @GET("/posts")
  Future<Pagination<Posts>> getPosts(
    @Query('paginate') int pagination,
    @Query('page') int page,
    @Query('type') String type,
    @Header('language') String? language,
  );

  @GET(RoutePathApi.postDetail)
  Future<ArticleDetailData> getPostDetail(@Path('id') id,
      @Query('type') String type, @Header('language') String lang);

  @GET(RoutePathApi.serviceDetail)
  Future<ServiceData> getServiceDetail(
      @Path('id') int id, @Header('language') String lang);

  @GET(RoutePathApi.tips)
  Future<List<Tips>> getTips(@Header('language') String lang);

  @POST(RoutePathApi.updateInfoDevice)
  Future<UserSetting> updateInfoDevice({
    @Query('fcm_token') String? fcmToken,
    @Query('device_id') String? deviceId,
    @Query('os') String? os,
    @Query('new_category') bool? newCategory,
    @Query('your_writing') bool? yourWriting,
    @Query('direction') bool? direction,
    @Header('language') String? language,
  });

  @GET(RoutePathApi.userSetting)
  Future<SettingDevice> getSettingUser();
}
