import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/maintenance/inspect_response_model.dart';
import 'package:pet_mobile_social_flutter/models/maintenance/update_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'maintenance_service.g.dart';

@RestApi()
abstract class MaintenanceService {
  factory MaintenanceService(Dio dio) = _MaintenanceService;

  @GET('{updateS3BaseUrl}/appUpdateInfo.json')
  Future<UpdateResponseModel> getUpdateFile(@Path('updateS3BaseUrl') String updateS3BaseUrl);

  @GET('{inspectS3BaseUrl}/appInspectInfo.json')
  Future<InspectResponseModel> getInspectFile(@Path('inspectS3BaseUrl') String inspectS3BaseUrl);
}
