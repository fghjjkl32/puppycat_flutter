import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/maintenance/update_response_model.dart';
import 'package:pet_mobile_social_flutter/services/maintenance/maintenance_service.dart';

class MaintenanceRepository {
  late final MaintenanceService _maintenanceService;

  final Dio dio;

  MaintenanceRepository({
    required this.dio,
  }) {
    _maintenanceService = MaintenanceService(dio, baseUrl: baseUrl);
  }

  Future<UpdateResponseModel> getUpdateFile() async {
    try {
      UpdateResponseModel responseModel = await _maintenanceService.getUpdateFile();
      return responseModel;
    } on DioError catch (dioError) {
      throw APIException(
        msg: dioError.message ?? "",
        code: dioError.response?.statusCode.toString() ?? 'Unknown',
        refer: 'MaintenanceRepository',
        caller: 'getUpdateFile',
      );
    } catch (e) {
      throw APIException(
        msg: 'Unknown error occurred',
        code: 'Unknown',
        refer: 'MaintenanceRepository',
        caller: 'getUpdateFile',
      );
    }
  }
}
