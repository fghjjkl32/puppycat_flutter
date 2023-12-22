import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/my_page/customer_support/customer_data_list_model.dart';

part 'customer_support_response_model.freezed.dart';
part 'customer_support_response_model.g.dart';

@freezed
class CustomerSupportResponseModel with _$CustomerSupportResponseModel {
  factory CustomerSupportResponseModel({
    required bool result,
    required String code,
    // required DataInfoModel<CustomerSupportItemModel> data,
    required CustomerDataListModel? data,
    String? message,
  }) = _CustomerSupportResponseModel;

  factory CustomerSupportResponseModel.fromJson(Map<String, dynamic> json) => _$CustomerSupportResponseModelFromJson(json);
}
