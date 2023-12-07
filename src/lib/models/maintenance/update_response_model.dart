import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_response_model.freezed.dart';
part 'update_response_model.g.dart';

@freezed
class UpdateResponseModel with _$UpdateResponseModel {
  factory UpdateResponseModel({
    int? currentBuildNumber,
    required int minBuildNumber,
    required int recommendBuildNumber,
    int? majorNumber,
    int? minorNumber,
    int? patchNumber,
    String? updatedDate,
  }) = _UpdateResponseModel;

  factory UpdateResponseModel.fromJson(Map<String, dynamic> json) => _$UpdateResponseModelFromJson(json);
}
