import 'package:pet_mobile_social_flutter/di/di.dart';
import 'package:pet_mobile_social_flutter/models/profile/profile.dart';
import 'package:riverpod/riverpod.dart';

final profileViewModelProvider = Provider((ref) => ProfileViewModel());

class ProfileViewModel {
  void saveProfile(Profile profile) async {
    profileRepository.saveProfile(profile);
  }
}
