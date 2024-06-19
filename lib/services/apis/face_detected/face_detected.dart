import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:skin_detective/models/acne_detail/acne_detail.dart';
import 'package:skin_detective/services/api_client.dart';

part 'face_detected.g.dart';

@RestApi(baseUrl: 'https://skindemo.azurewebsites.net')
abstract class FaceDetectedService {
  factory FaceDetectedService(Dio dio, {String baseUrl}) = _FaceDetectedService;

  static FaceDetectedService get client =>
      FaceDetectedService(ClientApi().init());

  @POST("/predict")
  Future<AcneDetail> getAcneTest(@Part() String image);
}
