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
import 'package:pet_mobile_social_flutter/ui/my_page/walk_log/walk_log_result_edit_screen.dart';
import 'package:thumbor/thumbor.dart';

class WalkLogResultViewScreen extends ConsumerStatefulWidget {
  final List<WalkResultItemModel> events;
  final int initialIndex;

  const WalkLogResultViewScreen({
    Key? key,
    required this.events,
    required this.initialIndex,
  }) : super(key: key);

  @override
  WalkLogResultViewScreenState createState() => WalkLogResultViewScreenState();
}

class WalkLogResultViewScreenState extends ConsumerState<WalkLogResultViewScreen> with TickerProviderStateMixin {
  late int currentIndex;
  late TabController tabController = TabController(
    initialIndex: 0,
    length: 1,
    vsync: this,
  );
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
          peeAmount: pet.peeAmountText!,
          peeColor: pet.peeColorText!,
          poopCount: pet.poopCount!,
          poopAmount: pet.poopAmountText!,
          poopColor: pet.poopColorText!,
          poopForm: pet.poopFormText!,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 4.0, left: 12.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              disabledBackgroundColor: kNeutralColor400,
                              backgroundColor: kPrimaryLightColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            onPressed: () async {},
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 18.0),
                              child: Text(
                                '새로운 산책하기',
                                style: kBody14BoldStyle.copyWith(color: kPrimaryColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 4.0, right: 12.0),
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
                              padding: const EdgeInsets.symmetric(vertical: 18.0),
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
                    height: 220,
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
                                      padding: const EdgeInsets.only(top: 24.0, left: 20.0, right: 20.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: kNeutralColor200,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: Icon(
                                                    Puppycat_social.icon_comment,
                                                    size: 24,
                                                    color: kTextBodyColor,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                "소변",
                                                style: kBody12SemiBoldStyle.copyWith(color: kTextTitleColor),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 40,
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 120,
                                                child: Column(
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
                                                              "횟수",
                                                              style: kBadge10MediumStyle.copyWith(color: kTextBodyColor),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                          "${tab.peeCount}회",
                                                          style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 8,
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
                                                            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 9.2),
                                                            child: Text(
                                                              "색",
                                                              style: kBadge10MediumStyle.copyWith(color: kTextBodyColor),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                          "${tab.peeColor}",
                                                          style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
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
                                                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 9.2),
                                                      child: Text(
                                                        "양",
                                                        style: kBadge10MediumStyle.copyWith(color: kTextBodyColor),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    "${tab.peeAmount}",
                                                    style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Divider(
                                        thickness: 1,
                                        height: 1,
                                        color: kNeutralColor300,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 24.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: kNeutralColor200,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: Icon(
                                                    Puppycat_social.icon_comment,
                                                    size: 24,
                                                    color: kTextBodyColor,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                "대변",
                                                style: kBody12SemiBoldStyle.copyWith(color: kTextTitleColor),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 40,
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 120,
                                                child: Column(
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
                                                              "횟수",
                                                              style: kBadge10MediumStyle.copyWith(color: kTextBodyColor),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                          "${tab.poopCount}회",
                                                          style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 8,
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
                                                            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 9.2),
                                                            child: Text(
                                                              "색",
                                                              style: kBadge10MediumStyle.copyWith(color: kTextBodyColor),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                          "${tab.poopColor}",
                                                          style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                                          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 9.2),
                                                          child: Text(
                                                            "양",
                                                            style: kBadge10MediumStyle.copyWith(color: kTextBodyColor),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text(
                                                        "${tab.poopAmount}",
                                                        style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 8,
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
                                                            "형태",
                                                            style: kBadge10MediumStyle.copyWith(color: kTextBodyColor),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text(
                                                        "${tab.poopForm}회",
                                                        style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
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
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, left: 12, right: 12, bottom: 20),
                    child: Text(
                      ref.watch(walkLogContentProvider.notifier).state.text,
                      style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
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
  String peeAmount;
  String peeColor;
  int poopCount;
  String poopAmount;
  String poopColor;
  String poopForm;

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
