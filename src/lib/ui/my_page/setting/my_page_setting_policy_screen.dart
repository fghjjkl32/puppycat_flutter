import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

// import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_menu_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/policy/policy_detail_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/policy/policy_menu_state_provider.dart';

class MyPageSettingPolicyScreen extends ConsumerStatefulWidget {
  const MyPageSettingPolicyScreen({required this.menuName, required this.idx, required this.dateList, super.key});

  final int idx;
  final List<String>? dateList;
  final String menuName;

  @override
  MyPageSettingPolicyScreenState createState() => MyPageSettingPolicyScreenState();
}

class MyPageSettingPolicyScreenState extends ConsumerState<MyPageSettingPolicyScreen> {
  String dropdownValue = "";
  List<String> policyDateList = [];

  late Future _fetchPolicyDataFuture;

  @override
  void initState() {
    super.initState();

    _fetchPolicyDataFuture = _fetchPolicyData();
  }

  Future<void> _fetchPolicyData() async {
    if (widget.dateList == null) {
      await ref.read(policyMenuStateProvider.notifier).getPoliciesMenu();

      // 상태가 업데이트된 후에 상태를 확인
      var policyMenu = ref.read(policyMenuStateProvider);
      print(widget.idx);

      print("ref.watch(policyMenuStateProvider) ${ref.read(policyMenuStateProvider)}");
      print("ref.watch(policyMenuStateProvider) ${policyMenu}");

      PolicyMenuItemModel? itemWithIdxTwo = ref.read(policyMenuStateProvider).firstWhere((item) {
        print("item.idx ${item.idx}");
        print(" widget.idx ${widget.idx}");

        return item.idx == widget.idx;
      });

      print("itemWithIdxTwo ${itemWithIdxTwo}");

      List<String> tempList = [];

      tempList = itemWithIdxTwo.dateList!;

      ref.read(policyDetailStateProvider.notifier).getPoliciesDetail(widget.idx, tempList[0]);

      policyDateList = tempList.map((date) {
        return "현행 시행 일자 : ${DateFormat('yyyy년 MM월 dd일').format(DateTime.parse(date))}";
      }).toList();

      dropdownValue = policyDateList.isNotEmpty ? policyDateList[0] : "";
    } else {
      ref.read(policyDetailStateProvider.notifier).getPoliciesDetail(widget.idx, widget.dateList![0]);

      policyDateList = widget.dateList!.map((date) {
        return "현행 시행 일자 : ${DateFormat('yyyy년 MM월 dd일').format(DateTime.parse(date))}";
      }).toList();

      dropdownValue = policyDateList.isNotEmpty ? policyDateList[0] : "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
            widget.menuName,
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
        body: FutureBuilder(
            future: _fetchPolicyDataFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('error');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Scrollbar(
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
                              if (newValue != null) {
                                // dropdownValue를 업데이트
                                setState(() {
                                  dropdownValue = newValue;
                                });

                                // "현행 시행 일자 : yyyy년 MM월 dd일" 형식에서 날짜 부분만 추출
                                String dateString = newValue.split(' : ')[1];
                                // "yyyy년 MM월 dd일"에서 "yyyy-MM-dd" 형식으로 변환
                                DateTime date = DateFormat('yyyy년 MM월 dd일').parse(dateString);
                                String formattedDate = DateFormat('yyyy-MM-dd').format(date);

                                // getPoliciesDetail 함수 호출
                                ref.read(policyDetailStateProvider.notifier).getPoliciesDetail(widget.idx, formattedDate);
                              }
                            },
                            items: policyDateList.map<DropdownMenuItem<String>>((String value) {
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
                        itemCount: ref.watch(policyDetailStateProvider).length,
                        itemBuilder: (context, idx) {
                          return Html(
                            data: ref.watch(policyDetailStateProvider)[idx].detail ?? "",
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
