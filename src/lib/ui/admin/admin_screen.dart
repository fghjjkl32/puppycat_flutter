import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
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
  late TextEditingController walkDevUrlController;
  late TextEditingController walkStgUrlController;
  late TextEditingController walkPrdUrlController;
  late TextEditingController walkDevGpsUrlController;
  late TextEditingController walkStgGpsUrlController;
  late TextEditingController walkPrdGpsUrlController;
  late TextEditingController selUrlController;
  late TextEditingController selWalkUrlController;
  late TextEditingController selWalkGpsUrlController;
  late TextEditingController selThumborHostController;
  late TextEditingController selThumborKeyController;
  late TextEditingController selThumborDomainController;

  late TextEditingController selInspectS3UrlController;
  late TextEditingController selUpdateS3UrlController;

  late FocusNode devFocusNode;
  late FocusNode stgFocusNode;
  late FocusNode prdFocusNode;
  late FocusNode selFocusNode;
  late FocusNode selWalkFocusNode;
  late FocusNode selWalkGpsFocusNode;
  late FocusNode selFocusNode2;
  late FocusNode selFocusNode3;
  late FocusNode selFocusNode4;
  late FocusNode selInspectS3FocusNode;
  late FocusNode selUpdateS3FocusNode;

  List<SystemUiOverlay>? systemUiOverlayList = [];

  bool developMode = false;

  String devThumborHostUrl = "https://tb.devlabs.co.kr/";
  String stgThumborHostUrl = "https://tb.pcstg.co.kr/";
  String prdThumborHostUrl = "https://tb.puppycat.co.kr/";

  String devThumborKey = "B5C2FAB11C3CB963";
  String stgThumborKey = "Tjaqhvpt";
  String prdThumborKey = "vjvlzotvldkfel";

  String stgThumborDomainUrl = "https://imgs.pcstg.co.kr";
  String devThumborDomainUrl = "https://dev-imgs.devlabs.co.kr";
  String prdThumborDomainUrl = "https://imgs.puppycat.co.kr";

  String devUpdateS3Url = "https://pet-mnt.devlabs.co.kr/update/dev";
  String stgUpdateS3Url = "https://mnt.pcstg.co.kr/update/stg";
  String prdUpdateS3Url = "https://mnt.puppycat.co.kr/update/prd";

  String devInspectS3Url = "https://pet-mnt.devlabs.co.kr/maintenance/dev";
  String stgInspectS3Url = "https://mnt.pcstg.co.kr/maintenance/stg";
  String prdInspectS3Url = "https://mnt.puppycat.co.kr/maintenance/prd";

  @override
  void initState() {
    super.initState();
    getDevelopMode();

    devUrlController = TextEditingController(text: "https://pet-api.devlabs.co.kr/");
    stgUrlController = TextEditingController(text: "https://api.pcstg.co.kr/");
    prdUrlController = TextEditingController(text: "https://api.puppycat.co.kr/");

    walkDevUrlController = TextEditingController(text: "https://pet-walk-dev-api.devlabs.co.kr/");
    walkStgUrlController = TextEditingController(text: "https://walk-api.pcstg.co.kr/");
    walkPrdUrlController = TextEditingController(text: "https://walk-api.puppycat.co.kr/");

    walkDevGpsUrlController = TextEditingController(text: "https://pet-walk-dev-gps.devlabs.co.kr/");
    walkStgGpsUrlController = TextEditingController(text: "https://walk-gps.pcstg.co.kr/");
    walkPrdGpsUrlController = TextEditingController(text: "https://walk-gps.puppycat.co.kr/");

    selUrlController = TextEditingController(text: '');
    selWalkUrlController = TextEditingController(text: '');
    selWalkGpsUrlController = TextEditingController(text: '');

    selThumborHostController = TextEditingController(text: '');
    selThumborKeyController = TextEditingController(text: '');
    selThumborDomainController = TextEditingController(text: '');
    selInspectS3UrlController = TextEditingController(text: '');
    selUpdateS3UrlController = TextEditingController(text: '');

    devFocusNode = FocusNode();
    stgFocusNode = FocusNode();
    prdFocusNode = FocusNode();
    selFocusNode = FocusNode();
    selWalkFocusNode = FocusNode();
    selWalkGpsFocusNode = FocusNode();
    selFocusNode2 = FocusNode();
    selFocusNode3 = FocusNode();
    selFocusNode4 = FocusNode();
    selInspectS3FocusNode = FocusNode();
    selUpdateS3FocusNode = FocusNode();
  }

  @override
  void dispose() {
    devUrlController.dispose();
    stgUrlController.dispose();
    prdUrlController.dispose();
    walkDevUrlController.dispose();
    walkStgUrlController.dispose();
    walkPrdUrlController.dispose();
    walkDevGpsUrlController.dispose();
    walkStgGpsUrlController.dispose();
    walkPrdGpsUrlController.dispose();
    selUrlController.dispose();
    selWalkUrlController.dispose();
    selWalkGpsUrlController.dispose();
    selInspectS3UrlController.dispose();
    selUpdateS3UrlController.dispose();
    devFocusNode.dispose();
    stgFocusNode.dispose();
    prdFocusNode.dispose();
    selFocusNode.dispose();
    selWalkFocusNode.dispose();
    selWalkGpsFocusNode.dispose();
    selFocusNode2.dispose();
    selFocusNode3.dispose();
    selFocusNode4.dispose();
    selInspectS3FocusNode.dispose();
    selUpdateS3FocusNode.dispose();
    super.dispose();
  }

  void setSelectURL(
    TextEditingController urlController,
    TextEditingController walkUrlController,
    TextEditingController walkGpsUrlController,
    String thumborHost,
    String thumborKey,
    String thumborDomain,
    String inspectS3Url,
    String updateS3Url,
  ) {
    setState(() {
      selUrlController.text = urlController.text;
      selWalkUrlController.text = walkUrlController.text;
      selWalkGpsUrlController.text = walkGpsUrlController.text;
      selThumborHostController.text = thumborHost;
      selThumborKeyController.text = thumborKey;
      selThumborDomainController.text = thumborDomain;
      selInspectS3UrlController.text = inspectS3Url;
      selUpdateS3UrlController.text = updateS3Url;
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

  setWalkUrlValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('selectedWalkURL', selWalkUrlController.text);

    walkBaseUrl = await Constants.getBaseWalkUrl();
  }

  setWalkGpsUrlValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('selectedWalkGpsURL', selWalkGpsUrlController.text);

    walkGpsBaseUrl = await Constants.getBaseWalkGpsUrl();
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

    // imgDomain = await Constants.getThumborDomain();
  }

  setInspectS3UrlValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('selectedInspectS3URL', selInspectS3UrlController.text);

    inspectS3BaseUrl = await Constants.getInspectS3Domain();
  }

  setUpdateS3UrlValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('selectedUpdateS3URL', selUpdateS3UrlController.text);

    updateS3BaseUrl = await Constants.getUpdateS3Domain();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selWalkFocusNode.unfocus();
          selWalkGpsFocusNode.unfocus();
          devFocusNode.unfocus();
          stgFocusNode.unfocus();
          prdFocusNode.unfocus();
          selFocusNode.unfocus();
        });
      },
      child: Scaffold(
        body: SafeArea(
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
                      setSelectURL(
                        devUrlController,
                        walkDevUrlController,
                        walkDevGpsUrlController,
                        devThumborHostUrl,
                        devThumborKey,
                        devThumborDomainUrl,
                        devInspectS3Url,
                        devUpdateS3Url,
                      );
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
                      decoration: const InputDecoration(label: Text('Staging')),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setSelectURL(
                        stgUrlController,
                        walkStgUrlController,
                        walkStgGpsUrlController,
                        stgThumborHostUrl,
                        stgThumborKey,
                        stgThumborDomainUrl,
                        stgInspectS3Url,
                        stgUpdateS3Url,
                      );
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
                      decoration: const InputDecoration(label: Text('Product')),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setSelectURL(
                        prdUrlController,
                        walkPrdUrlController,
                        walkPrdGpsUrlController,
                        prdThumborHostUrl,
                        prdThumborKey,
                        prdThumborDomainUrl,
                        prdInspectS3Url,
                        prdUpdateS3Url,
                      );
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
                  activeColor: kPreviousPrimaryColor,
                  inactiveColor: kPreviousNeutralColor300,
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
                controller: selWalkUrlController,
                focusNode: selWalkFocusNode,
                readOnly: true,
                decoration: const InputDecoration(
                  label: Text('Select Walk Url'),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Flexible(
              child: TextField(
                controller: selWalkGpsUrlController,
                focusNode: selWalkGpsFocusNode,
                readOnly: true,
                decoration: const InputDecoration(
                  label: Text('Select Walk Gps Url'),
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
            Flexible(
              child: TextField(
                controller: selInspectS3UrlController,
                focusNode: selInspectS3FocusNode,
                readOnly: true,
                decoration: const InputDecoration(
                  label: Text('Inspect S3 Url'),
                ),
              ),
            ),
            Text("${selInspectS3UrlController.text}"),
            const SizedBox(
              height: 20,
            ),
            Flexible(
              child: TextField(
                controller: selUpdateS3UrlController,
                focusNode: selUpdateS3FocusNode,
                readOnly: true,
                decoration: const InputDecoration(
                  label: Text('Update S3 Url'),
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
                        setWalkUrlValue();
                        setThumborHostUrl();
                        setThumborKey();
                        setThumborDomain();
                        setInspectS3UrlValue();
                        setUpdateS3UrlValue();

                        final myInfo = ref.read(myInfoStateProvider);
                        final isLogined = ref.read(loginStatementProvider);

                        if (!isLogined) {
                          context.pushReplacementNamed("loginScreen");
                        } else {
                          ref.read(loginStateProvider.notifier).logout(
                                myInfo.simpleType!,
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
    );
  }
}
