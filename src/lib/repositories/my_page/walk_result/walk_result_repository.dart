import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/my_pet_list/my_pet_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/my_pet_list/my_pet_list_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_result/walk_result_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_result/walk_result_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_result_detail/walk_result_detail_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_result_detail/walk_result_detail_response_model.dart';
import 'package:pet_mobile_social_flutter/services/my_page/walk_result/walk_result_service.dart';

class WalkResultRepository {
  late final WalkResultService _walkResultService;

  final Dio dio;

  WalkResultRepository({
    required this.dio,
  }) {
    _walkResultService = WalkResultService(dio, baseUrl: baseUrl);
  }

  Future<WalkResultResponseModel> getWalkResult({
    required String memberUuid,
    required int together,
    int limit = 10000,
    required String searchStartDate,
    required String searchEndDate,
  }) async {
    WalkResultResponseModel? responseModel = await _walkResultService.getWalkResult(memberUuid, together, limit, searchStartDate, searchEndDate).catchError((Object obj) async {});

    if (responseModel == null) {
      return WalkResultResponseModel(
        result: false,
        code: "",
        data: WalkResultListModel(
          list: [],
        ),
        message: "",
      );
    }

    return responseModel;
  }

  Future<WalkResultDetailResponseModel> getWalkResultDetail({
    required String memberUuid,
    required String walkUuid,
  }) async {
    WalkResultDetailResponseModel? responseModel = await _walkResultService.getWalkResultDetail(memberUuid, walkUuid).catchError((Object obj) async {});

    if (responseModel == null) {
      return WalkResultDetailResponseModel(
        result: false,
        code: "",
        data: WalkResultDetailListModel(
          data: [],
        ),
        message: "",
      );
    }

    return responseModel;
  }

  Future<ResponseModel> putWalkResult({
    required Map<String, dynamic> formDataMap,
  }) async {
    final formData = FormData.fromMap(formDataMap);

    ResponseModel? feedResponseModel = await _walkResultService.putWalkResult(formData);

    if (feedResponseModel == null) {
      throw "error posting feed";
    }

    return feedResponseModel;
  }
}
