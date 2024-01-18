import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/models/setting/customer_support/customer_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/setting/customer_support/customer_support_response_model.dart';
import 'package:pet_mobile_social_flutter/models/setting/customer_support/menu_item_model.dart';
import 'package:pet_mobile_social_flutter/models/setting/customer_support/menu_response_model.dart';
import 'package:pet_mobile_social_flutter/providers/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/services/setting/customer_support/customer_support_service.dart';

class CustomerSupportRepository {
  late final CustomerSupportService _settingService; // = CustomerSupportService(DioWrap.getDioWithCookie(), baseUrl: baseUrl);

  final Dio dio;

  CustomerSupportRepository({
    required this.dio,
  }) {
    _settingService = CustomerSupportService(DioWrap.getDioWithCookie(), baseUrl: baseUrl);
  }

  Future<CustomerDataListModel> getFaqList(int page, [int? type, String? searchWord, int limit = 20]) async {
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

    if (responseModel.data == null) {
      throw APIException(
        msg: 'data is null',
        code: responseModel.code,
        refer: 'CustomerSupportRepository',
        caller: 'getFaqList',
      );
    }

    return responseModel.data!;
  }

  Future<List<MenuItemModel>> getFaqMenuList() async {
    MenuResponseModel responseModel = await _settingService.getFaqMenuList();

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'CustomerSupportRepository',
        caller: 'getFaqMenuList',
      );
    }

    if (responseModel.data == null) {
      throw APIException(
        msg: 'data is null',
        code: responseModel.code,
        refer: 'CustomerSupportRepository',
        caller: 'getFaqMenuList',
      );
    }

    return responseModel.data!.list;
  }

  Future<CustomerDataListModel> getNoticeList(int page, [int? type, int limit = 20]) async {
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

    if (responseModel.data == null) {
      throw APIException(
        msg: 'data is null',
        code: responseModel.code,
        refer: 'CustomerSupportRepository',
        caller: 'getNoticeList',
      );
    }

    return responseModel.data!;
  }

  Future<List<MenuItemModel>> getNoticeMenuList() async {
    MenuResponseModel responseModel = await _settingService.getNoticeMenuList();

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'CustomerSupportRepository',
        caller: 'getNoticeMenuList',
      );
    }

    if (responseModel.data == null) {
      throw APIException(
        msg: 'data is null',
        code: responseModel.code,
        refer: 'CustomerSupportRepository',
        caller: 'getNoticeMenuList',
      );
    }

    return responseModel.data!.list;
  }
}
