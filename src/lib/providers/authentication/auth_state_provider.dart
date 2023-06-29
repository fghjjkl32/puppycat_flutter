import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/repositories/authentication/auth_repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_state_provider.g.dart';

final passUrlProvider = StateProvider<String>((ref) => 'about:blank');
final authTokenProvider = StateProvider<String>((ref) => '');

@Riverpod(keepAlive: true)
class AuthState extends _$AuthState {
  @override
  bool build() {
    return false;
  }

  void getPassAuthUrl() async {
    final authRepository = AuthRepository();
    try {
      String passUrl = await authRepository.getPassAuthUrl();
      // passUrl = "http://172.16.4.8:3037";
      ref.read(passUrlProvider.notifier).state = passUrl;
    } catch(e) {
      print(e);
      ref.read(passUrlProvider.notifier).state = 'about:blank';
    }
  }
}
