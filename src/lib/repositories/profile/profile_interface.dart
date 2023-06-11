import 'package:pet_mobile_social_flutter/models/profile/profile.dart';

abstract class ProfileInterface {
  Future<String> saveProfile(Profile profile);

  Future<bool> updateProfile(Profile profile);

  Future<bool> deleteProfile(String profile);
}
