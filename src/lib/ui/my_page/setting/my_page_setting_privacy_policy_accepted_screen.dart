import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/policy/policy_state_provider.dart';

class MyPageSettingPrivacyPolicyAcceptedScreen extends ConsumerStatefulWidget {
  const MyPageSettingPrivacyPolicyAcceptedScreen({super.key});

  @override
  MyPageSettingPrivacyPolicyAcceptedScreenState createState() => MyPageSettingPrivacyPolicyAcceptedScreenState();
}

class MyPageSettingPrivacyPolicyAcceptedScreenState extends ConsumerState<MyPageSettingPrivacyPolicyAcceptedScreen> {
  String dropdownValue = "현행 시행 일자 : 2023년 05월 30일";

  @override
  void initState() {
    super.initState();

    ref.read(policyStateProvider.notifier).getPoliciesDetail("marketing", "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}");
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text(
            "개인정보 수집/이용 동의약관",
          ),
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(
              Puppycat_social.icon_back,
              size: 40,
            ),
          ),
        ),
        body: Scrollbar(
          thumbVisibility: true,
          thickness: 4.0,
          radius: const Radius.circular(8.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20.0.w),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kNeutralColor100,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: Icon(Icons.keyboard_arrow_down),
                      ),
                      isExpanded: true,
                      iconSize: 24,
                      style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: <String>['현행 시행 일자 : 2023년 05월 30일', '현행 시행 일자 : 2023년 04월 30일', '현행 시행 일자 : 2023년 03월 30일', '현행 시행 일자 : 2023년 02월 30일'].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              value,
                              style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: ref.watch(policyStateProvider).length,
                  itemBuilder: (context, idx) {
                    return Html(
                      data: ref.watch(policyStateProvider)[idx].detail,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
