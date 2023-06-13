import 'package:appspector/appspector.dart';
import 'package:flutter/material.dart';
import 'package:pet_mobile_social_flutter/repositories/login/login_repository.dart';
import 'package:pet_mobile_social_flutter/services/login/social_login/kakao/kakao_login.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network('src'),
            Text('내 소중한 아이의'),
            Text('추억을 기록하고 공유해보세요.'),
            ElevatedButton(onPressed: () async {
              // KakaoLoginService kakao = KakaoLoginService();
              // var token = await kakao.login();
              // print('accessToken : $token');
              // if(token != null) {
              //   var userInfo = await kakao.getUserInfo();
              //   print('userInfo $userInfo');
              // }
              LoginRepository repository = LoginRepository(provider: 'kakao');
              repository.login();
            }, child: const Text('kakao login')),
            ElevatedButton(onPressed: () {
              LoginRepository repository = LoginRepository(provider: 'kakao');
              repository.signUp();
            }, child: const Text('naver login')),
            ElevatedButton(onPressed: () {}, child: const Text('google login')),
            ElevatedButton(onPressed: () async {
              await AppSpectorPlugin.shared().start();

            }, child: const Text('apple login')),
          ],
        ),
      ),
    );
  }
}

