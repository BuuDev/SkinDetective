import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:skin_detective/config/route_path_api.dart';
import 'package:skin_detective/models/history_skin_analysis/history_skin_analysis.dart';
import 'package:skin_detective/services/api_client.dart';

part 'history_skin_analysis.g.dart';

@RestApi()
abstract class HistorySkinAnalysisService {
  factory HistorySkinAnalysisService(Dio dio, {String baseUrl}) =
      _HistorySkinAnalysisService;

  factory HistorySkinAnalysisService.client({bool? isLoading}) {
    return HistorySkinAnalysisService(
        ClientApi().init()..options.headers['isLoading'] = isLoading);
  }

  @GET(RoutePathApi.analysisHistories)
  Future<List<HistorySkinAnalysisResponse>> getHistorySkinAnalysis(@Header('language') String lang);

  @POST(RoutePathApi.analysisDelete)
  Future<void> deleteHistorySkinAnalysis(@Query('list_id') String id);
}
