import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:skin_detective/config/route_path_api.dart';
import 'package:skin_detective/models/cosmetic/cosmetic_data.dart';
import 'package:skin_detective/models/pagination/pagination.dart';
import 'package:skin_detective/models/save_cosmetic_response/save_cosmetic_response.dart';
import 'package:skin_detective/services/api_client.dart';

part 'cosmetic.g.dart';

@RestApi()
abstract class CosMeticService {
  factory CosMeticService(Dio dio, {String baseUrl}) = _CosMeticService;

  factory CosMeticService.client({bool? isLoading}) {
    return CosMeticService(
      ClientApi().init()..options.headers['isLoading'] = isLoading,
    );
  }

  @GET(RoutePathApi.getCosmetic)
  Future<Pagination<ConsMeticData>> getCosmeTic(
    @Query('paginate') int paginate,
    @Query('page') int page,
    @Query('type') String type,
    @Header('language') String language,
  );

  @GET(RoutePathApi.getBlog)
  Future<Pagination<ConsMeticData>> getBlog(
    @Query('paginate') int paginate,
    @Query('page') int page,
    @Query('type') String type,
    @Header('language') String language,
  );

  @GET("/post/{id}/save")
  Future<SaveCosmeticResponse> saveCosmetic(
    @Path('id') int id,
  );
}
