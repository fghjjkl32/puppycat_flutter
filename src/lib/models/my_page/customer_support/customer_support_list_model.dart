import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/my_page/customer_support/customer_support_item_model.dart';

part 'customer_support_list_model.freezed.dart';
part 'customer_support_list_model.g.dart';

@freezed
class CustomerSupportListModel with _$CustomerSupportListModel {
  const factory CustomerSupportListModel({
    @Default([]) List<CustomerSupportItemModel> list,
    @Default(true) bool isLoading,
  }) = _CustomerSupportListModel;

  factory CustomerSupportListModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerSupportListModelFromJson(json);
}
