import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:multi_trigger_autocomplete/multi_trigger_autocomplete.dart';
import 'package:pet_mobile_social_flutter/components/feed/comment/mention_autocomplete_options.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_result/walk_result_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/walk_result/walk_result_detail_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/search/search_state_notifier.dart';
import 'package:thumbor/thumbor.dart';

final walkLogContentProvider = StateProvider<TextEditingController>((ref) => TextEditingController());

class WalkLogResultEditScreen extends ConsumerStatefulWidget {
  final List<WalkResultItemModel> events;
  final int initialIndex;

  const WalkLogResultEditScreen({
    Key? key,
    required this.events,
    required this.initialIndex,
  }) : super(key: key);

  @override
  WalkLogResultEditScreenState createState() => WalkLogResultEditScreenState();
}

class WalkLogResultEditScreenState extends ConsumerState<WalkLogResultEditScreen> with TickerProviderStateMixin {
  late int currentIndex;
  late TabController tabController = TabController(
    initialIndex: 0,
    length: 1,
    vsync: this,
  );
  int selectedButton = 0;
  final ScrollController _scrollController = ScrollController();

  List<PetState> petStates = [];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;

    init(widget.events[currentIndex].walkUuid!);
  }

  init(String walkUuid) async {
    setState(() {
      petStates = [];
    });

    Future(() async {
      await ref.watch(walkResultDetailStateProvider.notifier).getWalkResultDetail(walkUuid: walkUuid);

      tabController = TabController(
        initialIndex: 0,
        length: ref.watch(walkResultDetailStateProvider).data[0].walkPetList!.length,
        vsync: this,
      );

      ref.watch(walkLogContentProvider.notifier).state.text =
          replaceMentionsWithNicknamesInContentAsTextFieldString(ref.watch(walkResultDetailStateProvider).data[0].contents!, ref.watch(walkResultDetailStateProvider).data[0].mentionList!);

      for (var pet in ref.watch(walkResultDetailStateProvider).data[0].walkPetList!) {
        petStates.add(PetState(
          petUuid: pet.petUuid!,
          peeCount: pet.peeCount!,
          peeAmount: peeAmountList.indexOf(pet.peeAmountText!),
          peeColor: peeColorList.indexOf(pet.peeColorText!),
          poopCount: pet.poopCount!,
          poopAmount: poopAmountList.indexOf(pet.poopAmountText!),
          poopColor: poopColorList.indexOf(pet.poopColorText!),
          poopForm: poopFormList.indexOf(pet.poopFormText!),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          "${DateFormat('M월').format(DateTime.parse(widget.events[currentIndex].startDate!))} 산책일지",
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
        actions: [
          TextButton(
            onPressed: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return WillPopScope(
                    onWillPop: () async => false,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/lottie/icon_loading.json',
                            fit: BoxFit.fill,
                            width: 80,
                            height: 80,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );

              Map<String, dynamic> baseParams = {
                "walkUuid": ref.watch(walkResultDetailStateProvider).data[0].walkUuid,
                "memberUuid": ref.read(userInfoProvider).userModel!.uuid,
                "contents": ref.watch(walkLogContentProvider.notifier).state.text ?? "",
              };

              List<int> imgIdxList = [];

              for (int i = 0; i < petStates.length; i++) {
                baseParams["walkPetList[$i].petUuid"] = petStates[i].petUuid;
                baseParams["walkPetList[$i].peeCount"] = petStates[i].peeCount;
                baseParams["walkPetList[$i].peeAmount"] = petStates[i].peeAmount;
                baseParams["walkPetList[$i].peeColor"] = petStates[i].peeColor;
                baseParams["walkPetList[$i].poopCount"] = petStates[i].poopCount;
                baseParams["walkPetList[$i].poopAmount"] = petStates[i].poopAmount;
                baseParams["walkPetList[$i].poopColor"] = petStates[i].poopColor;
                baseParams["walkPetList[$i].poopForm"] = petStates[i].poopForm;
              }

              for (int i = 0; i < petStates.length; i++) {
                imgIdxList.add(ref.watch(walkResultDetailStateProvider).data[0].imgList![i].idx!);
              }

              baseParams["imgIdxList"] = imgIdxList;

              final result = await ref.watch(walkResultDetailStateProvider.notifier).putWalkResult(formDataMap: baseParams);
              context.pop();

              if (result.result) {}
            },
            child: Text(
              '수정',
              style: kButton12BoldStyle.copyWith(
                color: kPrimaryColor,
              ),
            ),
          ),
        ],
      ),
      body: Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return ListView(
          children: [
            Stack(
              children: [
                Image.network(
                  Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("$imgDomain${ref.watch(walkResultDetailStateProvider).data[0].imgList![0].url}").toUrl(),
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: kNeutralColor400,
                        backgroundColor: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () async {},
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                          '이 경로로 산책하기',
                          style: kBody14BoldStyle.copyWith(color: kNeutralColor100),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: -5,
                    blurRadius: 7,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: currentIndex > 0
                              ? () {
                                  setState(() {
                                    currentIndex = currentIndex - 1;
                                  });
                                  init(widget.events[currentIndex].walkUuid!);
                                }
                              : null,
                          icon: Icon(
                            Icons.chevron_left,
                            color: currentIndex > 0 ? kTextBodyColor : kNeutralColor500,
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              "${DateFormat('yyyy-MM-dd EEE', 'ko_KR').format(DateTime.parse(widget.events[currentIndex].startDate!))}",
                              style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: kNeutralColor200,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
                                        child: Text(
                                          "시작",
                                          style: kBadge10MediumStyle.copyWith(color: kTextBodyColor),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      "${DateFormat('a h:mm', 'ko_KR').format(DateTime.parse(widget.events[currentIndex].startDate!))}",
                                      style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: kNeutralColor200,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
                                        child: Text(
                                          "종료",
                                          style: kBadge10MediumStyle.copyWith(color: kTextBodyColor),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      "${DateFormat('a h:mm', 'ko_KR').format(DateTime.parse(widget.events[currentIndex].endDate!))}",
                                      style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: currentIndex < widget.events.length - 1
                              ? () {
                                  setState(() {
                                    currentIndex = currentIndex + 1;
                                  });
                                  init(widget.events[currentIndex].walkUuid!);
                                }
                              : null,
                          icon: Icon(
                            Icons.chevron_right,
                            color: currentIndex < widget.events.length - 1 ? kTextBodyColor : kNeutralColor500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 78,
                          decoration: const BoxDecoration(
                            color: kNeutralColor200,
                            borderRadius: BorderRadius.all(
                              Radius.circular(6.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            child: Column(
                              children: [
                                Icon(
                                  Puppycat_social.icon_comment,
                                  size: 32,
                                  color: kTextBodyColor,
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  formatDuration(
                                    DateTime.parse(ref.watch(walkResultDetailStateProvider).data[0].endDate!).difference(
                                      DateTime.parse(ref.watch(walkResultDetailStateProvider).data[0].startDate!),
                                    ),
                                  ),
                                  style: kBody16BoldStyle.copyWith(color: kTextSubTitleColor),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "시간",
                                  style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 78,
                          decoration: const BoxDecoration(
                            color: kNeutralColor200,
                            borderRadius: BorderRadius.all(
                              Radius.circular(6.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            child: Column(
                              children: [
                                Icon(
                                  Puppycat_social.icon_comment,
                                  size: 32,
                                  color: kTextBodyColor,
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  "${ref.watch(walkResultDetailStateProvider).data[0].stepText!.replaceAll("걸음", "")}",
                                  style: kBody16BoldStyle.copyWith(color: kTextSubTitleColor),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "걸음",
                                  style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 78,
                          decoration: const BoxDecoration(
                            color: kNeutralColor200,
                            borderRadius: BorderRadius.all(
                              Radius.circular(6.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            child: Column(
                              children: [
                                Icon(
                                  Puppycat_social.icon_comment,
                                  size: 32,
                                  color: kTextBodyColor,
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  "${ref.watch(walkResultDetailStateProvider).data[0].distanceText!.replaceAll("km", "")}",
                                  style: kBody16BoldStyle.copyWith(color: kTextSubTitleColor),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "km",
                                  style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 78,
                          decoration: const BoxDecoration(
                            color: kNeutralColor200,
                            borderRadius: BorderRadius.all(
                              Radius.circular(6.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            child: Column(
                              children: [
                                Icon(
                                  Puppycat_social.icon_comment,
                                  size: 32,
                                  color: kTextBodyColor,
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  "${ref.watch(walkResultDetailStateProvider).data[0].calorieText!.replaceAll("kcal", "")}",
                                  style: kBody16BoldStyle.copyWith(color: kTextSubTitleColor),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "kcal",
                                  style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 32, left: 12.0, bottom: 8),
                    child: Text(
                      "산책 파트너",
                      style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor),
                    ),
                  ),
                  TabBar(
                    isScrollable: true,
                    controller: tabController,
                    indicatorWeight: 3,
                    labelColor: kPrimaryColor,
                    indicatorColor: kPrimaryColor,
                    unselectedLabelColor: kNeutralColor500,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelPadding: EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    tabs: ref
                        .watch(walkResultDetailStateProvider)
                        .data[0]
                        .walkPetList!
                        .map(
                          (tab) => Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              tab.name!,
                              style: kBody14BoldStyle,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(
                    height: selectedButton == 0 ? 270 : 310,
                    child: TabBarView(
                      controller: tabController,
                      children: petStates.map((tab) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: kNeutralColor400),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20.0, bottom: 22.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedButton = 0;
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(100),
                                                color: selectedButton == 0 ? kNeutralColor300 : kNeutralColor100,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Puppycat_social.icon_comment,
                                                      color: selectedButton == 0 ? kTextTitleColor : kTextBodyColor,
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                      "소변",
                                                      style: kBody12SemiBoldStyle.copyWith(color: selectedButton == 0 ? kTextTitleColor : kTextBodyColor),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedButton = 1;
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(100),
                                                color: selectedButton == 1 ? kNeutralColor300 : kNeutralColor100,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Puppycat_social.icon_comment,
                                                      color: selectedButton == 1 ? kTextTitleColor : kTextBodyColor,
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                      "대변",
                                                      style: kBody12SemiBoldStyle.copyWith(color: selectedButton == 1 ? kTextTitleColor : kTextBodyColor),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (selectedButton == 0)
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "횟수",
                                                  style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      InkWell(
                                                        onTap: tab.peeCount > 0
                                                            ? () {
                                                                setState(() {
                                                                  tab.peeCount -= 1;
                                                                });
                                                              }
                                                            : null,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(color: kNeutralColor400),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
                                                            child: Text(
                                                              "-",
                                                              style: kButton14MediumStyle.copyWith(color: tab.peeCount > 0 ? kTextBodyColor : kNeutralColor500),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Puppycat_social.icon_comment,
                                                              color: kTextTitleColor,
                                                            ),
                                                            SizedBox(
                                                              width: 8,
                                                            ),
                                                            Text(
                                                              "${tab.peeCount}",
                                                              style: kBody12SemiBoldStyle.copyWith(color: kTextTitleColor),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: tab.peeCount < 99
                                                            ? () {
                                                                setState(() {
                                                                  tab.peeCount += 1;
                                                                });
                                                              }
                                                            : null,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(color: kNeutralColor400),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
                                                            child: Text(
                                                              "+",
                                                              style: kButton14MediumStyle.copyWith(color: tab.peeCount < 99 ? kTextBodyColor : kNeutralColor500),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                            child: Divider(
                                              thickness: 1,
                                              height: 1,
                                              color: kNeutralColor300,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 20.0),
                                                  child: Text(
                                                    "양",
                                                    style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      for (var i = 0; i < peeAmountList.length; i++)
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              tab.peeAmount = i;
                                                            });
                                                          },
                                                          child: Container(
                                                            decoration: tab.peeAmount == i
                                                                ? BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(100),
                                                                    color: kPrimaryLightColor,
                                                                  )
                                                                : null,
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                                              child: Text(
                                                                peeAmountList[i],
                                                                style: kBody13RegularStyle.copyWith(
                                                                  color: tab.peeAmount == i ? kPrimaryColor : kTextBodyColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                            child: Divider(
                                              thickness: 1,
                                              height: 1,
                                              color: kNeutralColor300,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 20.0),
                                                  child: Text(
                                                    "색",
                                                    style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      for (var i = 0; i < peeColorList.length; i++)
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              tab.peeColor = i;
                                                            });
                                                          },
                                                          child: Container(
                                                            decoration: tab.peeColor == i
                                                                ? BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(100),
                                                                    color: kPrimaryLightColor,
                                                                  )
                                                                : null,
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                                              child: Text(
                                                                peeColorList[i],
                                                                style: kBody13RegularStyle.copyWith(
                                                                  color: tab.peeColor == i ? kPrimaryColor : kTextBodyColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                          ),
                                        ],
                                      ),
                                    if (selectedButton == 1)
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "횟수",
                                                  style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      InkWell(
                                                        onTap: tab.poopCount > 0
                                                            ? () {
                                                                setState(() {
                                                                  tab.poopCount -= 1;
                                                                });
                                                              }
                                                            : null,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(color: kNeutralColor400),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
                                                            child: Text(
                                                              "-",
                                                              style: kButton14MediumStyle.copyWith(color: tab.poopCount > 0 ? kTextBodyColor : kNeutralColor500),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Puppycat_social.icon_comment,
                                                              color: kTextTitleColor,
                                                            ),
                                                            SizedBox(
                                                              width: 8,
                                                            ),
                                                            Text(
                                                              "${tab.poopCount}",
                                                              style: kBody12SemiBoldStyle.copyWith(color: kTextTitleColor),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: tab.poopCount < 99
                                                            ? () {
                                                                setState(() {
                                                                  tab.poopCount += 1;
                                                                });
                                                              }
                                                            : null,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(color: kNeutralColor400),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
                                                            child: Text(
                                                              "+",
                                                              style: kButton14MediumStyle.copyWith(color: tab.poopCount < 99 ? kTextBodyColor : kNeutralColor500),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                            child: Divider(
                                              thickness: 1,
                                              height: 1,
                                              color: kNeutralColor300,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 20.0),
                                                  child: Text(
                                                    "양",
                                                    style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      for (var i = 0; i < poopAmountList.length; i++)
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              tab.poopAmount = i;
                                                            });
                                                          },
                                                          child: Container(
                                                            decoration: tab.poopAmount == i
                                                                ? BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(100),
                                                                    color: kPrimaryLightColor,
                                                                  )
                                                                : null,
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                                              child: Text(
                                                                poopAmountList[i],
                                                                style: kBody13RegularStyle.copyWith(
                                                                  color: tab.poopAmount == i ? kPrimaryColor : kTextBodyColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                            child: Divider(
                                              thickness: 1,
                                              height: 1,
                                              color: kNeutralColor300,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 20.0),
                                                  child: Text(
                                                    "색",
                                                    style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      for (var i = 0; i < poopColorList.length; i++)
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              tab.poopColor = i;
                                                            });
                                                          },
                                                          child: Container(
                                                            decoration: tab.poopColor == i
                                                                ? BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(100),
                                                                    color: kPrimaryLightColor,
                                                                  )
                                                                : null,
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                                              child: Text(
                                                                poopColorList[i],
                                                                style: kBody13RegularStyle.copyWith(
                                                                  color: tab.poopColor == i ? kPrimaryColor : kTextBodyColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                            child: Divider(
                                              thickness: 1,
                                              height: 1,
                                              color: kNeutralColor300,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 10.0),
                                                  child: Text(
                                                    "형태",
                                                    style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      for (var i = 0; i < poopFormList.length; i++)
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              tab.poopForm = i;
                                                            });
                                                          },
                                                          child: Container(
                                                            decoration: tab.poopForm == i
                                                                ? BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(100),
                                                                    color: kPrimaryLightColor,
                                                                  )
                                                                : null,
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                                              child: Text(
                                                                poopFormList[i],
                                                                style: kBody13RegularStyle.copyWith(
                                                                  color: tab.poopForm == i ? kPrimaryColor : kTextBodyColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 12.0, bottom: 16),
                    child: Text(
                      "산책 내용",
                      style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      height: 100,
                      child: ListView.builder(
                        itemCount: ref.watch(walkResultDetailStateProvider).data[0].imgList!.length - 1,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("$imgDomain${ref.watch(walkResultDetailStateProvider).data[0].imgList![index + 1].url}").toUrl(),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                      child: MultiTriggerAutocomplete(
                        optionsAlignment: OptionsAlignment.topStart,
                        autocompleteTriggers: [
                          AutocompleteTrigger(
                            trigger: '@',
                            optionsViewBuilder: (context, autocompleteQuery, controller) {
                              return MentionAutocompleteOptions(
                                query: autocompleteQuery.query,
                                onMentionUserTap: (user) {
                                  final autocomplete = MultiTriggerAutocomplete.of(context);
                                  return autocomplete.acceptAutocompleteOption(user.nick!);
                                },
                              );
                            },
                          ),
                        ],
                        fieldViewBuilder: (context, controller, focusNode) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ref.watch(walkLogContentProvider.notifier).state = controller;
                          });

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: FormBuilderTextField(
                                focusNode: focusNode,
                                controller: controller,
                                onChanged: (text) {
                                  int cursorPos = ref.watch(walkLogContentProvider).selection.baseOffset;
                                  if (cursorPos > 0) {
                                    int from = text!.lastIndexOf('@', cursorPos);
                                    if (from != -1) {
                                      int prevCharPos = from - 1;
                                      if (prevCharPos >= 0 && text[prevCharPos] != ' ') {
                                        return;
                                      }

                                      int nextSpace = text.indexOf(' ', from);
                                      if (nextSpace == -1 || nextSpace >= cursorPos) {
                                        String toSearch = text.substring(from + 1, cursorPos);
                                        toSearch = toSearch.trim();

                                        if (toSearch.isNotEmpty) {
                                          if (toSearch.length >= 1) {
                                            ref.watch(searchStateProvider.notifier).searchQuery.add(toSearch);
                                          }
                                        } else {
                                          ref.watch(searchStateProvider.notifier).getMentionRecommendList(initPage: 1);
                                        }
                                      }
                                    }
                                  }
                                },
                                scrollPhysics: const ClampingScrollPhysics(),
                                scrollController: _scrollController,
                                maxLength: 500,
                                scrollPadding: EdgeInsets.only(bottom: 500),
                                maxLines: 6,
                                decoration: InputDecoration(
                                    counterText: "",
                                    hintText: '내용을 입력해 주세요.\n\n작성한 글에 대한 책임은 본인에게 있습니다.\n운영 정책에 위반되는(폭력성, 선정성, 욕설 등) 게시물은 당사자의 동의 없이 삭제될 수 있습니다.',
                                    hintStyle: kBody12RegularStyle.copyWith(color: kNeutralColor500),
                                    contentPadding: const EdgeInsets.all(16)),
                                name: 'content',
                                style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
                                keyboardType: TextInputType.multiline,
                                textAlignVertical: TextAlignVertical.center,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class PetState {
  String petUuid;
  int peeCount;
  int peeAmount;
  int peeColor;
  int poopCount;
  int poopAmount;
  int poopColor;
  int poopForm;

  PetState({
    required this.petUuid,
    required this.peeCount,
    required this.peeAmount,
    required this.peeColor,
    required this.poopCount,
    required this.poopAmount,
    required this.poopColor,
    required this.poopForm,
  });
}
