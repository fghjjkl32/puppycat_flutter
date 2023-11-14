import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_result_detail/walk_result_detail_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/walk/walk_pet_bowel_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/walk_log/walk_log_result_edit_screen.dart';

class WriteWalkLogBowelWidget extends ConsumerStatefulWidget {
  const WriteWalkLogBowelWidget({
    super.key,
    required this.petList,
  });

  final List<WalkPetList> petList;

  @override
  WriteWalkLogBowelWidgetState createState() => WriteWalkLogBowelWidgetState();
}

class WriteWalkLogBowelWidgetState extends ConsumerState<WriteWalkLogBowelWidget> with TickerProviderStateMixin {
  late TabController tabController;
  int selectedButton = 0;

  @override
  void initState() {
    super.initState();
    print('widget.petList.length ${widget.petList.length}');
    ref.read(walkPetBowelStateProvider.notifier).setPetList(widget.petList);
    tabController = TabController(
      initialIndex: 0,
      length: widget.petList.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    print('petStates 111111 rebuild ?? ');
    List<PetState> petStates = ref.watch(walkPetBowelStateProvider);
    print('petStates rebuild ?? ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 8.0, left: 12),
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
          labelPadding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
          tabs: widget.petList
                  .map(
                    (tab) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        tab.name!,
                        style: kBody14BoldStyle,
                      ),
                    ),
                  )
                  .toList() ??
              [],
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
                                          const SizedBox(
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
                                          const SizedBox(
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
                                                      // setState(() {
                                                      //   tab.peeCount -= 1;
                                                      // });
                                                      ref.read(walkPetBowelStateProvider.notifier).setPeeCount(tab.petUuid, --tab.peeCount);
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
                                                  const Icon(
                                                    Puppycat_social.icon_comment,
                                                    color: kTextTitleColor,
                                                  ),
                                                  const SizedBox(
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
                                                      // setState(() {
                                                      //   tab.peeCount += 1;
                                                      // });
                                                      ref.read(walkPetBowelStateProvider.notifier).setPeeCount(tab.petUuid, ++tab.peeCount);
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
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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
                                                  // setState(() {
                                                  //   tab.peeAmount = i;
                                                  // });
                                                  ref.read(walkPetBowelStateProvider.notifier).setPeeAmount(tab.petUuid, i);
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
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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
                                                  // setState(() {
                                                  //   tab.peeColor = i;
                                                  // });
                                                  ref.read(walkPetBowelStateProvider.notifier).setPeeColor(tab.petUuid, i);
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
                                                      // setState(() {
                                                      //   tab.poopCount -= 1;
                                                      // });
                                                      ref.read(walkPetBowelStateProvider.notifier).setPoopCount(tab.petUuid, --tab.poopCount);
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
                                                  const Icon(
                                                    Puppycat_social.icon_comment,
                                                    color: kTextTitleColor,
                                                  ),
                                                  const SizedBox(
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
                                                      // setState(() {
                                                      //   tab.poopCount += 1;
                                                      // });
                                                      ref.read(walkPetBowelStateProvider.notifier).setPoopCount(tab.petUuid, ++tab.poopCount);
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
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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
                                                  // setState(() {
                                                  //   tab.poopAmount = i;
                                                  // });
                                                  ref.read(walkPetBowelStateProvider.notifier).setPoopAmount(tab.petUuid, i);
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
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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
                                                  // setState(() {
                                                  //   tab.poopColor = i;
                                                  // });
                                                  ref.read(walkPetBowelStateProvider.notifier).setPoopColor(tab.petUuid, i);
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
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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
                                                  // setState(() {
                                                  //   tab.poopForm = i;
                                                  // });
                                                  ref.read(walkPetBowelStateProvider.notifier).setPoopForm(tab.petUuid, i);
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
      ],
    );
  }
}
