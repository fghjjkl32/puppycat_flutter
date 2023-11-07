import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/components/user_list/widget/follower_item_widget.dart';
import 'package:pet_mobile_social_flutter/components/user_list/widget/following_item_widget.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/follow/follow_state_provider.dart';

class MyPageFollowListScreen extends ConsumerStatefulWidget {
  const MyPageFollowListScreen({super.key, required this.memberIdx});
  final int memberIdx;

  @override
  MyPageFollowListScreenState createState() => MyPageFollowListScreenState();
}

class MyPageFollowListScreenState extends ConsumerState<MyPageFollowListScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;

  ScrollController followerController = ScrollController();
  ScrollController followController = ScrollController();
  final TextEditingController followerSearchController = TextEditingController();
  final TextEditingController followSearchController = TextEditingController();

  int followerOldLength = 0;
  int followOldLength = 0;

  int userMemberIdx = 0;

  @override
  void initState() {
    Future(() {
      ref.watch(followStateProvider.notifier).userMemberIdx = widget.memberIdx;
    });
    userMemberIdx = widget.memberIdx;

    followerController.addListener(_followerScrollListener);
    followController.addListener(_followScrollListener);
    followerSearchController.addListener(() {
      ref.watch(followStateProvider.notifier).followerSearchQuery.add(followerSearchController.text);
    });

    followSearchController.addListener(() {
      ref.watch(followStateProvider.notifier).followSearchQuery.add(followSearchController.text);
    });

    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    super.initState();

    ref.read(followStateProvider.notifier).initFollowerList(userMemberIdx, 1);
    ref.read(followStateProvider.notifier).initFollowList(userMemberIdx, 1);
  }

  void _followerScrollListener() {
    if (followerController.position.pixels > followerController.position.maxScrollExtent - MediaQuery.of(context).size.height) {
      if (followerOldLength == ref.read(followStateProvider).followerListState.list.length) {
        ref.read(followStateProvider.notifier).loadMoreFollowerList(userMemberIdx);
      }
    }
  }

  void _followScrollListener() {
    if (followController.position.pixels > followController.position.maxScrollExtent - MediaQuery.of(context).size.height) {
      if (followOldLength == ref.read(followStateProvider).followListState.list.length) {
        ref.read(followStateProvider.notifier).loadMoreFollowList(userMemberIdx);
      }
    }
  }

  @override
  void dispose() {
    followerController.removeListener(_followerScrollListener);
    followerController.dispose();
    followController.removeListener(_followScrollListener);
    followController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text(
            "친구",
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Puppycat_social.icon_back,
              size: 40,
            ),
          ),
          bottom: TabBar(
              controller: tabController,
              indicatorWeight: 3,
              labelColor: kPrimaryColor,
              indicatorColor: kPrimaryColor,
              unselectedLabelColor: kNeutralColor500,
              indicatorSize: TabBarIndicatorSize.tab,
              labelPadding: EdgeInsets.only(
                top: 10.h,
                bottom: 10.h,
              ),
              tabs: [
                Consumer(builder: (context, ref, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "팔로워",
                        style: kBody14BoldStyle,
                      ),
                      SizedBox(
                        width: 6.w,
                      ),
                      Text(
                        "${ref.watch(followStateProvider).followerListState.totalCount}",
                        style: kBadge10MediumStyle.copyWith(color: kTextBodyColor),
                      ),
                    ],
                  );
                }),
                Consumer(builder: (context, ref, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "팔로잉",
                        style: kBody14BoldStyle,
                      ),
                      SizedBox(
                        width: 6.w,
                      ),
                      Text(
                        "${ref.watch(followStateProvider).followListState.totalCount}",
                        style: kBadge10MediumStyle.copyWith(color: kTextBodyColor),
                      ),
                    ],
                  );
                }),
              ]),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            _firstTabBody(),
            _secondTabBody(),
          ],
        ),
      ),
    );
  }

  Widget _firstTabBody() {
    return Consumer(builder: (ctx, ref, child) {
      final followerState = ref.watch(followStateProvider);
      final isLoadMoreError = followerState.followerListState.isLoadMoreError;
      final isLoadMoreDone = followerState.followerListState.isLoadMoreDone;
      final isLoading = followerState.followerListState.isLoading;
      final lists = followerState.followerListState.list;

      followerOldLength = lists.length ?? 0;

      return Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  child: FormBuilderTextField(
                    name: 'follower',
                    controller: followerSearchController,
                    style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: kNeutralColor200,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(100.0),
                        gapPadding: 10.0,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(100.0),
                        gapPadding: 10.0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(100.0),
                        gapPadding: 10.0,
                      ),
                      suffixIconConstraints: const BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                      ),
                      // ignore: invalid_use_of_protected_member
                      suffixIcon: followerSearchController.text.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Icon(
                                Puppycat_social.icon_search_medium,
                                color: kNeutralColor600,
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                followerSearchController.text = "";
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                child: Icon(
                                  Puppycat_social.icon_close_large,
                                  color: kNeutralColor600,
                                ),
                              ),
                            ),
                      hintText: "닉네임을 입력해 주세요.",
                      hintStyle: kBody11RegularStyle.copyWith(color: kNeutralColor500),
                    ),
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Expanded(
                  child: lists.isEmpty
                      ? Container(
                          color: kNeutralColor100,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/image/character/character_08_user_notfound_100.png',
                                  width: 88,
                                  height: 88,
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  '유저를 찾을 수 없습니다.',
                                  textAlign: TextAlign.center,
                                  style: kBody13RegularStyle.copyWith(color: kTextBodyColor, height: 1.4, letterSpacing: 0.2),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: lists.length + 1,
                          itemBuilder: (context, index) {
                            if (index == lists.length) {
                              if (isLoadMoreError) {
                                return const Center(
                                  child: Text('Error'),
                                );
                              }
                              if (isLoadMoreDone) {
                                return Container();
                              }
                              return Container();
                            }
                            return FollowerItemWidget(
                              profileImage: "${lists[index].url}",
                              userName: lists[index].followerNick!,
                              content: lists[index].intro == "" ? '소개글이 없습니다.' : lists[index].intro!,
                              isSpecialUser: lists[index].isBadge! == 1,
                              isFollow: lists[index].isFollow == 1,
                              followerIdx: lists[index].followerIdx!,
                              memberIdx: lists[index].memberIdx!,
                              oldMemberIdx: widget.memberIdx,
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _secondTabBody() {
    return Consumer(builder: (ctx, ref, child) {
      final followState = ref.watch(followStateProvider);
      final isLoadMoreError = followState.followListState.isLoadMoreError;
      final isLoadMoreDone = followState.followListState.isLoadMoreDone;
      final isLoading = followState.followListState.isLoading;
      final lists = followState.followListState.list;
      return Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  child: FormBuilderTextField(
                    name: 'follower',
                    style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
                    controller: followSearchController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: kNeutralColor200,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(100.0),
                        gapPadding: 10.0,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(100.0),
                        gapPadding: 10.0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(100.0),
                        gapPadding: 10.0,
                      ),
                      suffixIconConstraints: const BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                      ),
                      // ignore: invalid_use_of_protected_member
                      suffixIcon: followSearchController.text.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Icon(
                                Puppycat_social.icon_search_medium,
                                color: kNeutralColor600,
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                followSearchController.text = "";
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                child: Icon(
                                  Puppycat_social.icon_close_large,
                                  color: kNeutralColor600,
                                ),
                              ),
                            ),
                      hintText: "닉네임을 입력해 주세요.",
                      hintStyle: kBody11RegularStyle.copyWith(color: kNeutralColor500),
                    ),
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Expanded(
                  child: lists.isEmpty
                      ? Container(
                          color: kNeutralColor100,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/image/character/character_08_user_notfound_100.png',
                                  width: 88,
                                  height: 88,
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  '유저를 찾을 수 없습니다.',
                                  textAlign: TextAlign.center,
                                  style: kBody13RegularStyle.copyWith(color: kTextBodyColor, height: 1.4, letterSpacing: 0.2),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: lists.length + 1,
                          itemBuilder: (context, index) {
                            if (index == lists.length) {
                              if (isLoadMoreError) {
                                return const Center(
                                  child: Text('Error'),
                                );
                              }
                              if (isLoadMoreDone) {
                                return Container();
                              }
                              return Container();
                            }
                            return FollowingItemWidget(
                              profileImage: "${lists[index].url}",
                              userName: lists[index].followNick!,
                              content: lists[index].intro == "" || lists[index].intro == null ? '소개글이 없습니다.' : lists[index].intro!,
                              isSpecialUser: lists[index].isBadge! == 1,
                              isFollow: lists[index].isFollow == 1,
                              isNewUser: lists[index].newState! == 1,
                              followIdx: lists[index].followIdx!,
                              memberIdx: lists[index].memberIdx!,
                              oldMemberIdx: widget.memberIdx,
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
