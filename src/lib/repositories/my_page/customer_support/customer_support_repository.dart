import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/my_page/customer_support/customer_support_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/customer_support/menu_response_model.dart';
import 'package:pet_mobile_social_flutter/services/my_page/customer_support/customer_support_service.dart';

class CustomerSupportRepository {
  late final CustomerSupportService _settingService; // = CustomerSupportService(DioWrap.getDioWithCookie(), baseUrl: baseUrl);

  final Dio dio;

  CustomerSupportRepository({
    required this.dio,
  }) {
    _settingService = CustomerSupportService(DioWrap.getDioWithCookie(), baseUrl: baseUrl);
  }

  Future<CustomerSupportResponseModel?> getFaqList(int page, [int? type, String? searchWord, int limit = 20]) async {
    Map<String, dynamic> queries = {
      'page': page,
      'limit': limit,
    };

    if (type != null) {
      queries['type'] = type;
    }
    if (searchWord != null) {
      queries['searchWord'] = searchWord;
    }

    CustomerSupportResponseModel responseModel = await _settingService.getFaqList(queries);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'CustomerSupportRepository',
        caller: 'getFaqList',
      );
    }

    return responseModel;
  }

  Future<MenuResponseModel?> getFaqMenuList() async {
    MenuResponseModel responseModel = await _settingService.getFaqMenuList();

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'CustomerSupportRepository',
        caller: 'getFaqMenuList',
      );
    }

    return responseModel;
  }

  Future<CustomerSupportResponseModel?> getNoticeList(int page, [int? type, int limit = 20]) async {
    Map<String, dynamic> queries = {
      'page': page,
      'limit': limit,
    };

    if (type != null) {
      queries['type'] = type;
    }

    CustomerSupportResponseModel responseModel = await _settingService.getNoticeList(queries);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'CustomerSupportRepository',
        caller: 'getNoticeList',
      );
    }

    return responseModel;
  }

  Future<MenuResponseModel?> getNoticeMenuList() async {
    MenuResponseModel responseModel = await _settingService.getNoticeMenuList();

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'CustomerSupportRepository',
        caller: 'getNoticeMenuList',
      );
    }

    return responseModel;
  }
}
