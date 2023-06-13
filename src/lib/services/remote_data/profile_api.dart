import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pet_mobile_social_flutter/models/profile/profile.dart';
import 'package:dio/dio.dart';

class ProfileApi {
  final Dio dio;
  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  ProfileApi({
    required this.dio,
  });

  Future<String> saveProfile(Profile profile) async {
    String profileUrl = '$_baseUrl/v2/profile';
    try {
      Response response;
      response = await dio.post(
        profileUrl,
        data: {
          "title": profile.title,
          "content": profile.content,
        },
      );

      final String diaryId = response.data['data'];
      return diaryId;
    } on DioError catch (e) {
      debugPrint(e.toString());
      return "";
    }
  }

  Future<bool> updateProfile(Profile profile) async {
    String profileUrl = '$_baseUrl/v2/profile/${profile.id}';
    try {
      Response response;
      response = await dio.post(profileUrl, data: {
        "title": profile.title,
        "content": profile.content,
      });

      return response.data['data'];
    } on DioError catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> deleteProfile(String diaryId) async {
    String diaryUrl = '$_baseUrl/v1/profile/$diaryId';
    try {
      Response response;
      response = await dio.delete(
        diaryUrl,
      );

      return response.data['data'];
    } on DioError catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
