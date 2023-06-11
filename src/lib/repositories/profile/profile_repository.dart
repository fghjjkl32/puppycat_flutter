import 'package:pet_mobile_social_flutter/data/remote_data/profile_api.dart';
import 'package:pet_mobile_social_flutter/models/profile/profile.dart';

import 'profile_interface.dart';

class ProfileRepository implements ProfileInterface {
  final ProfileApi profileApi;

  ProfileRepository({
    required this.profileApi,
  });

  @override
  Future<String> saveProfile(Profile profile) async {
    return await profileApi.saveProfile(profile);
  }

  @override
  Future<bool> updateProfile(Profile profile) async {
    return await profileApi.updateProfile(profile);
  }

  @override
  Future<bool> deleteProfile(String id) async {
    return await profileApi.deleteProfile(id);
  }
}
