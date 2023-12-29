import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/restrain/restrain_item_model.dart';

part 'restrain_list_model.freezed.dart';
part 'restrain_list_model.g.dart';

@freezed
class RestrainDataModel with _$RestrainDataModel {
  const factory RestrainDataModel({
    required RestrainItemModel? restrain,
  }) = _RestrainDataModel;

  factory RestrainDataModel.fromJson(Map<String, dynamic> json) => _$RestrainDataModelFromJson(json);
}
