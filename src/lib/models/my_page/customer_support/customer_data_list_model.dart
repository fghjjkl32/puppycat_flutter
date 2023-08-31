import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/main/comment/comment_data.dart';
import 'package:pet_mobile_social_flutter/models/my_page/customer_support/customer_support_item_model.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';

part 'customer_data_list_model.freezed.dart';
part 'customer_data_list_model.g.dart';

@freezed
class CustomerDataListModel with _$CustomerDataListModel {
  const factory CustomerDataListModel({
    @Default([]) List<CustomerSupportItemModel> list,
    ParamsModel? params,
  }) = _CustomerDataListModel;

  factory CustomerDataListModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerDataListModelFromJson(json);
}
