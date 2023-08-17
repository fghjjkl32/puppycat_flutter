import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SystemUIOverlayStatus {
  allView,
  allHide,
  topHide,
  bottomHide,
}

class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({
    Key? key,
  }) : super(key: key);

  @override
  AdminScreenState createState() => AdminScreenState();
}

class AdminScreenState extends ConsumerState<AdminScreen> {
  late TextEditingController devUrlController;
  late TextEditingController stgUrlController;
  late TextEditingController prdUrlController;
  late TextEditingController selUrlController;
  late FocusNode devFocusNode;
  late FocusNode stgFocusNode;
  late FocusNode prdFocusNode;
  late FocusNode selFocusNode;

  List<SystemUiOverlay>? systemUiOverlayList = [];

  bool developMode = false;

  @override
  void initState() {
    super.initState();
    getDevelopMode();

    devUrlController =
        TextEditingController(text: "https://sns-api.devlabs.co.kr:28080/v1");
    stgUrlController =
        TextEditingController(text: "https://api.pcstg.co.kr/v1");
    prdUrlController = TextEditingController(text: "");
    selUrlController = TextEditingController(text: '');
    devFocusNode = FocusNode();
    stgFocusNode = FocusNode();
    prdFocusNode = FocusNode();
    selFocusNode = FocusNode();
  }

  @override
  void dispose() {
    devUrlController.dispose();
    stgUrlController.dispose();
    prdUrlController.dispose();
    selUrlController.dispose();
    devFocusNode.dispose();
    stgFocusNode.dispose();
    prdFocusNode.dispose();
    selFocusNode.dispose();
    super.dispose();
  }

  void setSelectURL(TextEditingController controller) {
    setState(() {
      selUrlController.text = controller.text;
    });
  }

  getDevelopMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      developMode = prefs.getBool('developMode') ?? false;
    });
  }

  setDevelopMode(bool val) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('developMode', val);
    // Restart.restartApp();
  }

  setUrlValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('selectedURL', selUrlController.text);

    baseUrl = await Constants.getBaseUrl();
    // Restart.restartApp();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          devFocusNode.unfocus();
          stgFocusNode.unfocus();
          prdFocusNode.unfocus();
          selFocusNode.unfocus();
        });
      },
      child: Scaffold(
        body: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            return true;
          },
          child: SafeArea(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    // const Text('DEV'),
                    // const SizedBox(
                    //   width: 20,
                    // ),
                    Flexible(
                      child: TextField(
                        controller: devUrlController,
                        focusNode: devFocusNode,
                        decoration: const InputDecoration(label: Text('Dev')),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setSelectURL(devUrlController);
                      },
                      child: const Text('선택'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: stgUrlController,
                        focusNode: stgFocusNode,
                        decoration:
                            const InputDecoration(label: Text('Staging')),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setSelectURL(stgUrlController);
                      },
                      child: const Text('선택'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: prdUrlController,
                        focusNode: prdFocusNode,
                        decoration:
                            const InputDecoration(label: Text('Product')),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setSelectURL(prdUrlController);
                      },
                      child: const Text('선택'),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("개발자 모드"),
                  SizedBox(
                    width: 10.w,
                  ),
                  FlutterSwitch(
                    padding: 2,
                    width: 52.0.w,
                    height: 32.0.h,
                    activeColor: kPrimaryColor,
                    inactiveColor: kNeutralColor300,
                    toggleSize: 28.0.w,
                    value: developMode,
                    borderRadius: 50.0.w,
                    onToggle: (val) async {
                      setDevelopMode(val);

                      setState(() {
                        developMode = val;
                      });
                    },
                  ),
                ],
              ),
              const Divider(),
              Flexible(
                child: TextField(
                  controller: selUrlController,
                  focusNode: selFocusNode,
                  readOnly: true,
                  decoration: const InputDecoration(
                    label: Text('Select Url'),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('취소')),

                  /// 230512 smkang
                  /// 상단, 하단 제어 기능 불필요로 주석 처리
                  /// 추후 완전히 필요 없다 생각되면 제거 예정
                  // ElevatedButton(
                  //     onPressed: () {
                  //       if (selUrlController.text.isEmpty) {
                  //         FocusScope.of(context).requestFocus(selFocusNode);
                  //         return;
                  //       }
                  //       Navigator.pushAndRemoveUntil(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (BuildContext context) =>
                  //                   ToonWebViewWidget(
                  //                     url: selUrlController.text,
                  //                   )),
                  //           (route) => false);
                  //       // Navigator.pop(context);
                  //     },
                  //     child: const Text('적용')),
                  ElevatedButton(
                      onPressed: () {
                        if (selUrlController.text.isEmpty) {
                          FocusScope.of(context).requestFocus(selFocusNode);
                          return;
                        } else {
                          setUrlValue();
                          ref.read(loginStateProvider.notifier).logout(
                                ref.read(userModelProvider)!.simpleType,
                                ref.read(userModelProvider)!.appKey,
                              );
                        }
                      },
                      child: const Text('적용')),
                ],
              )
            ],
          )),
        ),
      ),
    );
  }
}
