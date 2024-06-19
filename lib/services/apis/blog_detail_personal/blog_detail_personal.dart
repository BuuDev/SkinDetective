import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:skin_detective/services/api_client.dart';

part 'blog_detail_personal.g.dart';

@RestApi()
abstract class BlogDetailPersonalService {
  factory BlogDetailPersonalService(Dio dio, {String baseUrl}) =
      _BlogDetailPersonalService;

  factory BlogDetailPersonalService.client({bool? isLoading}) {
    return BlogDetailPersonalService(
        ClientApi().init()..options.headers['isLoading'] = isLoading);
  }

  @POST("/post/{id}/update-status")
  Future<void> getUsers(@Path('id') int id, @Query('status') String status);
}
