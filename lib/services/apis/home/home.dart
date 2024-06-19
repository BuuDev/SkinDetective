import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:skin_detective/config/route_path_api.dart';
import 'package:skin_detective/models/cosmetic/cosmetic_data.dart';
import 'package:skin_detective/models/pagination/pagination.dart';
import 'package:skin_detective/models/system_param/system_param.dart';
import 'package:skin_detective/services/api_client.dart';
part 'home.g.dart';

@RestApi()
abstract class HomeService {
  factory HomeService(Dio dio, {String baseUrl}) = _HomeService;

  factory HomeService.client({bool? isLoading}) {
    return HomeService(
        ClientApi().init()..options.headers['isLoading'] = isLoading);
  }

  @GET(RoutePathApi.getHomeCosmetic)
  Future<Pagination<ConsMeticData>> getHomeCosmeTic(
    @Query('type') String type,
    @Header('language') String language,
  );

  @GET(RoutePathApi.getHomeBlog)
  Future<Pagination<ConsMeticData>> getHomeBlog(
    @Query('type') String type,
    @Header('language') String language,
  );

  @GET(RoutePathApi.getHomePost)
  Future<Pagination<ConsMeticData>> getHomePost(
    @Query('type') String type,
    @Header('language') String language,
  );

  @GET(RoutePathApi.systemParams)
  Future<SystemParam> activePost();
}
