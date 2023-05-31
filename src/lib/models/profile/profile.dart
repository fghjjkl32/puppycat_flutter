import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';

part 'profile.g.dart';

@freezed
class Profile with _$Profile {
  factory Profile({
    @Default(0) int id,
    @Default('') String title,
    @Default('') String content,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
