import 'dart:io';

import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:skin_detective/models/picture/picture.dart';
import 'package:skin_detective/services/api_client.dart';

part 'upload_image.g.dart';

@RestApi()
abstract class UploadImageService {
  factory UploadImageService(Dio dio, {String baseUrl}) = _UploadImageService;

  static UploadImageService get client =>
      UploadImageService(ClientApi().init());

  @POST("/upload-image")
  @MultiPart()
  Future<Picture> uploadImage(@Part() File image);
}
