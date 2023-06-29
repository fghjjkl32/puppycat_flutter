import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';

class PuppyCatMain extends ConsumerWidget {
  const PuppyCatMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var userProvider = ref.watch(userModelProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Text('$userProvider'),
              ElevatedButton(onPressed: () {
                if(userProvider == null) {
                  print('aa');
                  return;
                }
                ref.read(loginStateProvider.notifier).logout(userProvider.simpleType, userProvider.appKey);
              }, child: const Text('logout')),
            ],
          ),
        ),
      ),
    );
  }
}
