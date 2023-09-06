import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/customer_support/customer_support_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/customer_support/menu_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/setting/setting_response_model.dart';
import 'package:pet_mobile_social_flutter/services/my_page/customer_support/customer_support_service.dart';
import 'package:pet_mobile_social_flutter/services/my_page/setting/setting_service.dart';

class CustomerSupportRepository {
  late final CustomerSupportService _settingService; // = CustomerSupportService(DioWrap.getDioWithCookie(), baseUrl: baseUrl);

  final Dio dio;

  CustomerSupportRepository({
    required this.dio,
  }) {
    _settingService = CustomerSupportService(DioWrap.getDioWithCookie(), baseUrl: baseUrl);
  }

  Future<CustomerSupportResponseModel?> getFaqList({
    required int page,
  }) async {
    CustomerSupportResponseModel? customerSupportResponseModel = await _settingService.getFaqList(page).catchError((Object obj) async {});

    if (customerSupportResponseModel == null) {
      return null;
    }

    return customerSupportResponseModel;
  }

  Future<MenuResponseModel?> getFaqMenuList() async {
    MenuResponseModel? customerSupportResponseModel = await _settingService.getFaqMenuList().catchError((Object obj) async {});

    if (customerSupportResponseModel == null) {
      return null;
    }

    return customerSupportResponseModel;
  }

  Future<CustomerSupportResponseModel?> getNoticeList(int page, [int? type, int limit = 10]) async {
    Map<String, dynamic> queries = {
      'page': page,
      'limit': limit,
    };

    if (type != null) {
      queries['type'] = type;
    }

    CustomerSupportResponseModel? customerSupportResponseModel = await _settingService.getNoticeList(queries).catchError((Object obj) async {});

    if (customerSupportResponseModel == null) {
      return null;
    }

    return customerSupportResponseModel;
  }

  Future<MenuResponseModel?> getNoticeMenuList() async {
    MenuResponseModel? customerSupportResponseModel = await _settingService.getNoticeMenuList().catchError((Object obj) async {});

    if (customerSupportResponseModel == null) {
      return null;
    }

    return customerSupportResponseModel;
  }
}
