import 'package:freezed_annotation/freezed_annotation.dart';

part 'inspect_response_model.freezed.dart';
part 'inspect_response_model.g.dart';

@freezed
class InspectResponseModel with _$InspectResponseModel {
  factory InspectResponseModel({
    required String endDate,
    required String startDate,
    required List<String> targetServiceList,
    String? message,
  }) = _InspectResponseModel;

  factory InspectResponseModel.fromJson(Map<String, dynamic> json) => _$InspectResponseModelFromJson(json);
}
