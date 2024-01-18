import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/models/maintenance/inspect_response_model.dart';
import 'package:pet_mobile_social_flutter/models/maintenance/update_response_model.dart';
import 'package:pet_mobile_social_flutter/services/maintenance/maintenance_service.dart';

class MaintenanceRepository {
  late final MaintenanceService _maintenanceService;

  final Dio dio;

  MaintenanceRepository({
    required this.dio,
  }) {
    _maintenanceService = MaintenanceService(dio);
  }

  Future<UpdateResponseModel> getUpdateFile() async {
    try {
      UpdateResponseModel responseModel = await _maintenanceService.getUpdateFile(updateS3BaseUrl);
      return responseModel;
    } on DioException catch (dioError) {
      throw APIException(
        msg: dioError.message ?? "",
        code: dioError.response?.statusCode.toString() ?? 'Unknown',
        refer: 'MaintenanceRepository',
        caller: 'getUpdateFile',
      );
    } catch (e) {
      //TODO
      //여긴 나중에 따로 오류 관련 Exception으로 변경 필요
      throw APIException(
        msg: 'Unknown error occurred',
        code: 'Unknown',
        refer: 'MaintenanceRepository',
        caller: 'getUpdateFile',
      );
    }
  }

  Future<InspectResponseModel> getInspectFile() async {
    try {
      InspectResponseModel responseModel = await _maintenanceService.getInspectFile(inspectS3BaseUrl);
      return responseModel;
    } on DioError catch (dioError) {
      throw APIException(
        msg: dioError.message ?? "",
        code: dioError.response?.statusCode.toString() ?? 'Unknown',
        refer: 'MaintenanceRepository',
        caller: 'getInspectFile',
      );
    } catch (e) {
      throw APIException(
        msg: 'Unknown error occurred',
        code: 'Unknown',
        refer: 'MaintenanceRepository',
        caller: 'getInspectFile',
      );
    }
  }
}
