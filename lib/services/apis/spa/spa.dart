import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:skin_detective/config/route_path_api.dart';
import 'package:skin_detective/models/spa/spa.dart';
import 'package:skin_detective/models/spa/spa_response.dart';
import 'package:skin_detective/models/spa/spa_service_id.dart';
import 'package:skin_detective/services/api_client.dart';

part 'spa.g.dart';

@RestApi()
abstract class SpaService {
  factory SpaService(Dio dio, {String baseUrl}) = _SpaService;

  factory SpaService.client({bool? isLoading}) {
    return SpaService(
        ClientApi().init()..options.headers['isLoading'] = isLoading);
  }

  @GET(RoutePathApi.spa)
  Future<SpaResponse> getSpaList(
    @Header('language') String lang,
    @Query('paginate') int paginate,
    @Query('sort') String sort,
    @Query('latitude') String latitude,
    @Query('longitude') String longitude,
    @Query('distance') String distance,
  );

  @GET(RoutePathApi.spaDetail)
  Future<Spa> getSpaDetail(
    @Header('language') String lang,
    @Path("id") int id,
    @Query('paginate') int paginate,
    @Query('filter') String filter,
  );

  @GET(RoutePathApi.spaIdService)
  Future<SpaServiceResponse> getSpaIdService(
    @Header('language') String lang,
    @Path("id") int id,
  );
}
