import 'dart:io';

import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:skin_detective/config/route_path_api.dart';
import 'package:skin_detective/models/analytic/analytic.dart';
import 'package:skin_detective/models/cancel_analytic/cancel_analytic.dart';
import 'package:skin_detective/services/api_client.dart';

part 'ance.g.dart';

@RestApi()
abstract class AnceService {
  factory AnceService(Dio dio, {String baseUrl}) = _AnceService;

  // Nên khởi tạo bằng thằng này
  factory AnceService.client({bool? isLoading}) {
    return AnceService(
        ClientApi().init()..options.headers['isLoading'] = isLoading);
  }

  @POST(RoutePathApi.resultAnalyze)
  Future<Analytic> resultAnalyze(
      @Query('uuid') String uuid,
      @Part() File frontal,
      @Part() File left,
      @Part() File right,
      @Header('language') String lang);

  @GET(RoutePathApi.detailAnalyze)
  Future<Analytic> detailAnalyze(@Header('language') String lang, @Path() id);

  @POST(RoutePathApi.cancelAnalyze)
  Future<CancelAnalytic> cancelAnalyze(@Query('uuid') String uuid);
}
