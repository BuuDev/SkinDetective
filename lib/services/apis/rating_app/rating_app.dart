import 'dart:io';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:skin_detective/config/route_path_api.dart';
import 'package:skin_detective/models/dataRating/data_rating.dart';
import 'package:skin_detective/models/rating/average_rating.dart';
import 'package:skin_detective/services/api_client.dart';

part 'rating_app.g.dart';

@RestApi()
abstract class RatingService {
  factory RatingService(Dio dio, {String baseUrl}) = _RatingService;

  factory RatingService.client({bool? isLoading}) {
    return RatingService(
        ClientApi().init()..options.headers['isLoading'] = isLoading);
  }

  @POST("/review")
  @MultiPart()
  Future<DataRating> rating(@Query("point") double point,
      @Query("comment") String comment, @Query("agree_term") bool agreeTerm,
      [@Part(name: "images[]") List<File>? images]);

  @GET(RoutePathApi.averageRating)
  Future<AverageRating> getAverageRating();
}
