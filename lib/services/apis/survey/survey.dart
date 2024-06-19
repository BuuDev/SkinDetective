import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:skin_detective/config/route_path_api.dart';
import 'package:skin_detective/models/survey/answers/survey_answers.dart';
import 'package:skin_detective/services/api_client.dart';

import '../../../models/popup_servey_check/popup_servey_check.dart';
import '../../../models/survey/survey.dart';

part 'survey.g.dart';

@RestApi()
abstract class SurveyService {
  factory SurveyService(Dio dio, {String baseUrl}) = _SurveyService;

  factory SurveyService.client({bool? isLoading}) {
    return SurveyService(
        ClientApi().init()..options.headers['isLoading'] = isLoading);
  }

  @GET(RoutePathApi.survey)
  Future<SurveyModel> surveyAPI(@Header('language') String lang);

  @POST(RoutePathApi.surveyAnswers)
  Future<SurveyAnswers> saveAnswer(@Body() SurveyAnswers surveyAnswers);

  @GET(RoutePathApi.popUp)
  Future<PopupServeyCheck> getPopupCheck(@Header('language') String lang);
}
