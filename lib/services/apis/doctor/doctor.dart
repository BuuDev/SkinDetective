import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:skin_detective/config/route_path_api.dart';
import 'package:skin_detective/models/doctor/doctor.dart';
import 'package:skin_detective/models/doctor/doctor_response.dart';
import 'package:skin_detective/services/api_client.dart';

part 'doctor.g.dart';

@RestApi()
abstract class DoctorService {
  factory DoctorService(Dio dio, {String baseUrl}) = _DoctorService;

  factory DoctorService.client({bool? isLoading}) {
    return DoctorService(
        ClientApi().init()..options.headers['isLoading'] = isLoading);
  }

  @GET(RoutePathApi.doctors)
  Future<DoctorResponse> getDoctorList(
    @Header('language') String lang,
    @Query('paginate') int paginate,
    @Query('filter') String filter,
  );

  @GET(RoutePathApi.doctorsDetail)
  Future<Doctor> getDoctorDetail(
    @Header('language') String lang,
    @Path("id") int id,
    @Query('paginate') int paginate,
    @Query('filter') String filter,
  );
}
