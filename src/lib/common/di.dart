import 'package:pet_mobile_social_flutter/services/remote_data/profile_api.dart';
import 'package:pet_mobile_social_flutter/repositories/profile/profile_repository.dart';
import 'package:dio/dio.dart';

final dio = Dio();

final ProfileRepository profileRepository =
    ProfileRepository(profileApi: ProfileApi(dio: dio));
