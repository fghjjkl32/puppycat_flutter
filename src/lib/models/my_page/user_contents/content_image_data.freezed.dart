// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content_image_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ContentImageData _$ContentImageDataFromJson(Map<String, dynamic> json) {
  return _ContentImageData.fromJson(json);
}

/// @nodoc
mixin _$ContentImageData {
  String get imgUrl => throw _privateConstructorUsedError;
  int get idx => throw _privateConstructorUsedError;
  int? get commentCnt => throw _privateConstructorUsedError;
  int? get likeCnt => throw _privateConstructorUsedError;
  int get imageCnt => throw _privateConstructorUsedError;
  int? get selfLike => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContentImageDataCopyWith<ContentImageData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContentImageDataCopyWith<$Res> {
  factory $ContentImageDataCopyWith(
          ContentImageData value, $Res Function(ContentImageData) then) =
      _$ContentImageDataCopyWithImpl<$Res, ContentImageData>;
  @useResult
  $Res call(
      {String imgUrl,
      int idx,
      int? commentCnt,
      int? likeCnt,
      int imageCnt,
      int? selfLike});
}

/// @nodoc
class _$ContentImageDataCopyWithImpl<$Res, $Val extends ContentImageData>
    implements $ContentImageDataCopyWith<$Res> {
  _$ContentImageDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imgUrl = null,
    Object? idx = null,
    Object? commentCnt = freezed,
    Object? likeCnt = freezed,
    Object? imageCnt = null,
    Object? selfLike = freezed,
  }) {
    return _then(_value.copyWith(
      imgUrl: null == imgUrl
          ? _value.imgUrl
          : imgUrl // ignore: cast_nullable_to_non_nullable
              as String,
      idx: null == idx
          ? _value.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as int,
      commentCnt: freezed == commentCnt
          ? _value.commentCnt
          : commentCnt // ignore: cast_nullable_to_non_nullable
              as int?,
      likeCnt: freezed == likeCnt
          ? _value.likeCnt
          : likeCnt // ignore: cast_nullable_to_non_nullable
              as int?,
      imageCnt: null == imageCnt
          ? _value.imageCnt
          : imageCnt // ignore: cast_nullable_to_non_nullable
              as int,
      selfLike: freezed == selfLike
          ? _value.selfLike
          : selfLike // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ContentImageDataCopyWith<$Res>
    implements $ContentImageDataCopyWith<$Res> {
  factory _$$_ContentImageDataCopyWith(
          _$_ContentImageData value, $Res Function(_$_ContentImageData) then) =
      __$$_ContentImageDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String imgUrl,
      int idx,
      int? commentCnt,
      int? likeCnt,
      int imageCnt,
      int? selfLike});
}

/// @nodoc
class __$$_ContentImageDataCopyWithImpl<$Res>
    extends _$ContentImageDataCopyWithImpl<$Res, _$_ContentImageData>
    implements _$$_ContentImageDataCopyWith<$Res> {
  __$$_ContentImageDataCopyWithImpl(
      _$_ContentImageData _value, $Res Function(_$_ContentImageData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imgUrl = null,
    Object? idx = null,
    Object? commentCnt = freezed,
    Object? likeCnt = freezed,
    Object? imageCnt = null,
    Object? selfLike = freezed,
  }) {
    return _then(_$_ContentImageData(
      imgUrl: null == imgUrl
          ? _value.imgUrl
          : imgUrl // ignore: cast_nullable_to_non_nullable
              as String,
      idx: null == idx
          ? _value.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as int,
      commentCnt: freezed == commentCnt
          ? _value.commentCnt
          : commentCnt // ignore: cast_nullable_to_non_nullable
              as int?,
      likeCnt: freezed == likeCnt
          ? _value.likeCnt
          : likeCnt // ignore: cast_nullable_to_non_nullable
              as int?,
      imageCnt: null == imageCnt
          ? _value.imageCnt
          : imageCnt // ignore: cast_nullable_to_non_nullable
              as int,
      selfLike: freezed == selfLike
          ? _value.selfLike
          : selfLike // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ContentImageData implements _ContentImageData {
  const _$_ContentImageData(
      {required this.imgUrl,
      required this.idx,
      this.commentCnt,
      this.likeCnt,
      required this.imageCnt,
      this.selfLike});

  factory _$_ContentImageData.fromJson(Map<String, dynamic> json) =>
      _$$_ContentImageDataFromJson(json);

  @override
  final String imgUrl;
  @override
  final int idx;
  @override
  final int? commentCnt;
  @override
  final int? likeCnt;
  @override
  final int imageCnt;
  @override
  final int? selfLike;

  @override
  String toString() {
    return 'ContentImageData(imgUrl: $imgUrl, idx: $idx, commentCnt: $commentCnt, likeCnt: $likeCnt, imageCnt: $imageCnt, selfLike: $selfLike)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ContentImageData &&
            (identical(other.imgUrl, imgUrl) || other.imgUrl == imgUrl) &&
            (identical(other.idx, idx) || other.idx == idx) &&
            (identical(other.commentCnt, commentCnt) ||
                other.commentCnt == commentCnt) &&
            (identical(other.likeCnt, likeCnt) || other.likeCnt == likeCnt) &&
            (identical(other.imageCnt, imageCnt) ||
                other.imageCnt == imageCnt) &&
            (identical(other.selfLike, selfLike) ||
                other.selfLike == selfLike));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, imgUrl, idx, commentCnt, likeCnt, imageCnt, selfLike);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ContentImageDataCopyWith<_$_ContentImageData> get copyWith =>
      __$$_ContentImageDataCopyWithImpl<_$_ContentImageData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ContentImageDataToJson(
      this,
    );
  }
}

abstract class _ContentImageData implements ContentImageData {
  const factory _ContentImageData(
      {required final String imgUrl,
      required final int idx,
      final int? commentCnt,
      final int? likeCnt,
      required final int imageCnt,
      final int? selfLike}) = _$_ContentImageData;

  factory _ContentImageData.fromJson(Map<String, dynamic> json) =
      _$_ContentImageData.fromJson;

  @override
  String get imgUrl;
  @override
  int get idx;
  @override
  int? get commentCnt;
  @override
  int? get likeCnt;
  @override
  int get imageCnt;
  @override
  int? get selfLike;
  @override
  @JsonKey(ignore: true)
  _$$_ContentImageDataCopyWith<_$_ContentImageData> get copyWith =>
      throw _privateConstructorUsedError;
}
