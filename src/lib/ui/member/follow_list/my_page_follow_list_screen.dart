import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/follow/follow_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/tag_contents/user_tag_contents_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user_contents/user_contents_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user_information/user_information_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/components/appbar/defalut_on_will_pop_scope.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/ui/member/follow_list/widget/follower_item_widget.dart';
import 'package:pet_mobile_social_flutter/ui/member/follow_list/widget/following_item_widget.dart';

class MyPageFollowListScreen extends ConsumerStatefulWidget {
  const MyPageFollowListScreen({super.key, required this.memberUuid});

  final String memberUuid;

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

  String memberUuid = '';

  @override
  void initState() {
    memberUuid = widget.memberUuid;

    followerController.addListener(_followerScrollListener);
    followController.addListener(_followScrollListener);
    followerSearchController.addListener(() {
      ref.watch(followStateProvider.notifier).followerSearchQuery.add((memberUuid, followerSearchController.text));
    });

    followSearchController.addListener(() {
      ref.watch(followStateProvider.notifier).followSearchQuery.add((memberUuid, followSearchController.text));
    });

    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    super.initState();

    ref.read(followStateProvider.notifier).initFollowerList(memberUuid: memberUuid, initPage: 1);
    ref.read(followStateProvider.notifier).initFollowList(memberUuid: memberUuid, initPage: 1);
  }

  void _followerScrollListener() {
    if (followerController.position.pixels > followerController.position.maxScrollExtent - MediaQuery.of(context).size.height) {
      if (followerOldLength == ref.read(followStateProvider).followerListState.list.length) {
        ref.read(followStateProvider.notifier).loadMoreFollowerList(memberUuid);
      }
    }
  }

  void _followScrollListener() {
    if (followController.position.pixels > followController.position.maxScrollExtent - MediaQuery.of(context).size.height) {
      if (followOldLength == ref.read(followStateProvider).followListState.list.length) {
        ref.read(followStateProvider.notifier).loadMoreFollowList(memberUuid);
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
      child: DefaultOnWillPopScope(
        onWillPop: () {
          ref.read(userInformationStateProvider.notifier).getStateForUserInformation(widget.memberUuid);

          ref.read(userContentsStateProvider.notifier).getStateForUserContent(widget.memberUuid);

          ref.read(userTagContentsStateProvider.notifier).getStateForUserTagContent(widget.memberUuid);

          return Future.value(true);
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text(
              "팔로우",
            ),
            leading: IconButton(
              onPressed: () {
                ref.read(userInformationStateProvider.notifier).getStateForUserInformation(widget.memberUuid);

                ref.read(userContentsStateProvider.notifier).getStateForUserContent(widget.memberUuid);

                ref.read(userTagContentsStateProvider.notifier).getStateForUserTagContent(widget.memberUuid);

                context.pop();
              },
              icon: const Icon(
                Puppycat_social.icon_back,
                size: 40,
              ),
            ),
            bottom: TabBar(
                controller: tabController,
                indicatorWeight: 2.4,
                labelColor: kPreviousNeutralColor600,
                indicatorColor: kPreviousNeutralColor600,
                unselectedLabelColor: kPreviousNeutralColor500,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  Tab(
                    child: Consumer(builder: (context, ref, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "팔로워",
                            style: kTitle16BoldStyle,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            "${ref.watch(followStateProvider).followerListState.totalCount}",
                            style: kBody13RegularStyle.copyWith(color: kTextTertiary),
                          ),
                        ],
                      );
                    }),
                  ),
                  Tab(
                    child: Consumer(builder: (context, ref, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "팔로잉",
                            style: kTitle16BoldStyle,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            "${ref.watch(followStateProvider).followListState.totalCount}",
                            style: kBody13RegularStyle.copyWith(color: kTextTertiary),
                          ),
                        ],
                      );
                    }),
                  ),
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

      // final myInfo = ref.read(myInfoStateProvider);
      // final isLogined = ref.read(loginStatementProvider);

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
                    style: kBody13RegularStyle.copyWith(color: kPreviousTextSubTitleColor),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: kPreviousNeutralColor200,
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
                                color: kPreviousNeutralColor600,
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
                                  color: kPreviousNeutralColor600,
                                ),
                              ),
                            ),
                      hintText: "닉네임으로 검색해 보세요.",
                      hintStyle: kBody14RegularStyle.copyWith(color: kTextTertiary),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Expanded(
                  child: lists.isEmpty
                      ? Container(
                          color: kPreviousNeutralColor100,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                followerSearchController.text == ""
                                    ? Image.asset(
                                        'assets/image/chat/empty_character_01_nopost_88_x2.png',
                                        width: 88,
                                        height: 88,
                                      )
                                    : Image.asset(
                                        'assets/image/character/character_08_user_notfound_100.png',
                                        width: 88,
                                        height: 88,
                                      ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  followerSearchController.text == "" ? '팔로워가 없어요.' : '유저를 찾을 수 없어요.\n닉네임을 다시 확인해 주세요.',
                                  textAlign: TextAlign.center,
                                  style: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor, height: 1.4, letterSpacing: 0.2),
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
                              profileImage: "${lists[index].profileImgUrl}",
                              userName: lists[index].followerNick!,
                              content: lists[index].intro == "" ? '소개글이 없어요.' : lists[index].intro!,
                              isSpecialUser: lists[index].isBadge! == 1,
                              isFollow: lists[index].isFollow == 1,
                              followerUuid: lists[index].followerUuid!,
                              memberUuid: lists[index].memberUuid!,
                              oldMemberUuid: widget.memberUuid,
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
      // final isLoading = followState.followListState.isLoading;
      final lists = followState.followListState.list;
      // final myInfo = ref.read(myInfoStateProvider);
      // final isLogined = ref.read(loginStatementProvider);

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
                    style: kBody13RegularStyle.copyWith(color: kPreviousTextSubTitleColor),
                    controller: followSearchController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: kPreviousNeutralColor200,
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
                                color: kPreviousNeutralColor600,
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
                                  color: kPreviousNeutralColor600,
                                ),
                              ),
                            ),
                      hintText: "닉네임으로 검색해 보세요.",
                      hintStyle: kBody14RegularStyle.copyWith(color: kTextTertiary),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Expanded(
                  child: lists.isEmpty
                      ? Container(
                          color: kPreviousNeutralColor100,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                followSearchController.text == ""
                                    ? Image.asset(
                                        'assets/image/chat/empty_character_01_nopost_88_x2.png',
                                        width: 88,
                                        height: 88,
                                      )
                                    : Image.asset(
                                        'assets/image/character/character_08_user_notfound_100.png',
                                        width: 88,
                                        height: 88,
                                      ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  followSearchController.text == "" ? '팔로잉이 없어요.' : '유저를 찾을 수 없어요.\n닉네임을 다시 확인해 주세요.',
                                  textAlign: TextAlign.center,
                                  style: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor, height: 1.4, letterSpacing: 0.2),
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
                              profileImage: "${lists[index].profileImgUrl}",
                              userName: lists[index].followNick!,
                              content: lists[index].intro == "" || lists[index].intro == null ? '소개글이 없어요.' : lists[index].intro!,
                              isSpecialUser: lists[index].isBadge! == 1,
                              isFollow: lists[index].isFollow == 1,
                              isNewUser: lists[index].newState! == 1,
                              followUuid: lists[index].followUuid!,
                              memberUuid: lists[index].memberUuid!,
                              oldMemberUuid: widget.memberUuid,
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
