import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/controller/token/token_controller.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';

class AdminSettingScreen extends ConsumerStatefulWidget {
  const AdminSettingScreen({super.key});

  @override
  AdminSettingScreenState createState() => AdminSettingScreenState();
}

class AdminSettingScreenState extends ConsumerState<AdminSettingScreen> {
  RunningMode? _preRunMode;
  RunningMode? _selectMode;

  @override
  void initState() {
    super.initState();
  }

  void changeMode(RunningMode mode) {
    setRunningMode(mode);
    initRunningMode();
    _selectMode = mode;
    setState(() {});
  }

  void popProc() {
    final myInfo = ref.read(myInfoStateProvider);
    final isLogined = ref.read(loginStatementProvider);

    TokenController.clearTokens();
    print('myInfo $myInfo / isLogined $isLogined');
    context.pushReplacementNamed("loginScreen");
    // else {
    //   if(_preRunMode == _selectMode) {
    //     ref.read(loginStateProvider.notifier).logout(
    //       myInfo.simpleType!,
    //     );
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Screen'),
      ),
      body: PopScope(
        canPop: true,
        onPopInvoked: (pop) {
          if (pop) {
            print('pop?');
            popProc();
            return;
          }
        },
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      changeMode(RunningMode.dev);
                    },
                    child: const Text('Dev'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      changeMode(RunningMode.stg);
                    },
                    child: const Text('Stg'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      changeMode(RunningMode.prd);
                    },
                    child: const Text('Prd'),
                  ),
                ],
              ),
              const Divider(
                height: 20,
              ),
              FutureBuilder(
                future: getRunningMode(),
                builder: (context, snapshot) {
                  if (snapshot.hasError || !snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  _preRunMode ??= snapshot.data!;

                  return Text('현재 모드 : ${snapshot.data}');
                },
              ),
              Text('이전 모드 : $_preRunMode'),
              const Divider(
                height: 40,
              ),
              const Text('Member API'),
              Text(memberBaseUrl),
              const Divider(
                height: 10,
              ),
              const Text('SNS API'),
              Text(baseUrl),
              const Divider(
                height: 10,
              ),
              const Text('Thumbor URL'),
              Text('$thumborHostUrl(key : $thumborKey})'),
              const Divider(
                height: 10,
              ),
              const Text('Chat API'),
              Text(chatBaseUrl),
              const Divider(
                height: 10,
              ),
              const Text('Maintenance URL'),
              Text(inspectS3BaseUrl),
              const Divider(
                height: 10,
              ),
              const Text('Update URL'),
              Text(updateS3BaseUrl),
              const Divider(
                height: 10,
              ),
              const Text('Walk API'),
              Text(walkBaseUrl),
              const Divider(
                height: 10,
              ),
              const Text('Walk GPS URL'),
              Text(walkGpsBaseUrl),
              ElevatedButton(
                onPressed: () {
                  changeMode(_preRunMode ?? RunningMode.prd);
                  popProc();
                },
                child: const Text('취소'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
