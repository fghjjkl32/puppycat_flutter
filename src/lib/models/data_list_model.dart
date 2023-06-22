import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_list_model.freezed.dart';
part 'data_list_model.g.dart';

@freezed
@JsonSerializable(genericArgumentFactories: true)
class DataListModel<T> with _$DataListModel<T> {
  factory DataListModel({
    required List<T> list,
  }) = _DataListModel<T>;

  // factory DataListModel.fromJson(Map<String, dynamic> json) =>
  //     _$DataListModelFromJson(json);

  factory DataListModel.fromJson(
      Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
    return _$DataListModelFromJson<T>(json, fromJsonT);
  }
}