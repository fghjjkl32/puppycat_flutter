import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_route_provider.dart';
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
  late TextEditingController selThumborHostController;
  late TextEditingController selThumborKeyController;
  late TextEditingController selThumborDomainController;

  late FocusNode devFocusNode;
  late FocusNode stgFocusNode;
  late FocusNode prdFocusNode;
  late FocusNode selFocusNode;
  late FocusNode selFocusNode2;
  late FocusNode selFocusNode3;
  late FocusNode selFocusNode4;

  List<SystemUiOverlay>? systemUiOverlayList = [];

  bool developMode = false;

  String devThumborHostUrl = "https://tb.devlabs.co.kr/";
  String stgThumborHostUrl = "https://tb.pcstg.co.kr/";

  String devThumborKey = "B5C2FAB11C3CB963";
  String stgThumborKey = "Tjaqhvpt";

  String stgThumborDomainUrl = "https://imgs.pcstg.co.kr";
  String devThumborDomainUrl = "https://dev-imgs.devlabs.co.kr";

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
    selThumborHostController = TextEditingController(text: '');
    selThumborKeyController = TextEditingController(text: '');
    selThumborDomainController = TextEditingController(text: '');

    devFocusNode = FocusNode();
    stgFocusNode = FocusNode();
    prdFocusNode = FocusNode();
    selFocusNode = FocusNode();
    selFocusNode2 = FocusNode();
    selFocusNode3 = FocusNode();
    selFocusNode4 = FocusNode();
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
    selFocusNode2.dispose();
    selFocusNode3.dispose();
    selFocusNode4.dispose();

    super.dispose();
  }

  void setSelectURL(
    TextEditingController controller,
    String thumborHost,
    String thumborKey,
    String thumborDomain,
  ) {
    setState(() {
      selUrlController.text = controller.text;
      selThumborHostController.text = thumborHost;
      selThumborKeyController.text = thumborKey;
      selThumborDomainController.text = thumborDomain;
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
  }

  setThumborHostUrl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('thumborHostUrl', selThumborHostController.text);

    thumborHostUrl = await Constants.getThumborHostUrl();
  }

  setThumborKey() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('thumborKey', selThumborKeyController.text);

    thumborKey = await Constants.getThumborKey();
  }

  setThumborDomain() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('thumborDomain', selThumborDomainController.text);

    imgDomain = await Constants.getThumborDomain();
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
                        setSelectURL(devUrlController, devThumborHostUrl,
                            devThumborKey, devThumborDomainUrl);
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
                        setSelectURL(stgUrlController, stgThumborHostUrl,
                            stgThumborKey, stgThumborDomainUrl);
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
              Flexible(
                child: TextField(
                  controller: selThumborHostController,
                  focusNode: selFocusNode2,
                  readOnly: true,
                  decoration: const InputDecoration(
                    label: Text('thumbor Host Url'),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Flexible(
                child: TextField(
                  controller: selThumborKeyController,
                  focusNode: selFocusNode3,
                  readOnly: true,
                  decoration: const InputDecoration(
                    label: Text('Thumbor Key'),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Flexible(
                child: TextField(
                  controller: selThumborDomainController,
                  focusNode: selFocusNode4,
                  readOnly: true,
                  decoration: const InputDecoration(
                    label: Text('Thumbor Domain'),
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
                          setThumborHostUrl();
                          setThumborKey();
                          setThumborDomain();

                          if (ref.read(userModelProvider) == null) {
                            context.pushReplacementNamed("loginScreen");
                          } else {
                            ref.read(loginStateProvider.notifier).logout(
                                  ref.read(userModelProvider)!.simpleType,
                                  ref.read(userModelProvider)!.appKey,
                                );
                          }
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
