import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/maintenance/update_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'maintenance_service.g.dart';

@RestApi()
abstract class MaintenanceService {
  factory MaintenanceService(Dio dio, {String baseUrl}) = _MaintenanceService;

  @GET('http://172.16.40.17:3037/update.json')
  Future<UpdateResponseModel> getUpdateFile();
}
