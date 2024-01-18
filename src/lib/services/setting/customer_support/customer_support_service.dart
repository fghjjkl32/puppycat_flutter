import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/setting/customer_support/customer_support_response_model.dart';
import 'package:pet_mobile_social_flutter/models/setting/customer_support/menu_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'customer_support_service.g.dart';

@RestApi()
abstract class CustomerSupportService {
  factory CustomerSupportService(Dio dio, {String baseUrl}) = _CustomerSupportService;

  @GET('v1/faq')
  Future<CustomerSupportResponseModel> getFaqList(
    @Queries() Map<String, dynamic> queries,
  );

  @GET('v1/faq/menu')
  Future<MenuResponseModel> getFaqMenuList();

  // @GET('/notice')
  // Future<CustomerSupportResponseModel?> getNoticeList(
  //   @Query("page") int page,
  //   @Query("type") int type,
  // );

  @GET('v1/notice')
  Future<CustomerSupportResponseModel> getNoticeList(
    @Queries() Map<String, dynamic> queries,
  );

  @GET('v1/notice/menu')
  Future<MenuResponseModel> getNoticeMenuList();
}
