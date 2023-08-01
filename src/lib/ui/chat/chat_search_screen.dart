import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/components/user_list/widget/follower_item_widget.dart';
import 'package:pet_mobile_social_flutter/components/user_list/widget/following_item_widget.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_model.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_favorite_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/follow/follow_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/chat/chat_search_list_item.dart';
import 'package:widget_mask/widget_mask.dart';

class ChatSearchScreen extends ConsumerStatefulWidget {
  const ChatSearchScreen({super.key});

  @override
  ChatSearchScreenState createState() => ChatSearchScreenState();
}

class ChatSearchScreenState extends ConsumerState<ChatSearchScreen> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  ScrollController followController = ScrollController();
  int followOldLength = 0;
  int userMemberIdx = 0;

  @override
  void initState() {
    // var userInfoModel = ref.read(userInfoProvider);
    userMemberIdx = ref.read(userInfoProvider).userModel!.idx;
    ref.read(followStateProvider.notifier).initFollowList(userMemberIdx, 1);

    super.initState();
  }

  void _followScrollListener() {
    if (followController.position.pixels >
        followController.position.maxScrollExtent -
            MediaQuery.of(context).size.height) {
      if (followOldLength ==
          ref.read(followStateProvider).followListState.list.length) {
        ref
            .read(followStateProvider.notifier)
            .loadMoreFollowList(userMemberIdx);
      }
    }
  }

  @override
  void dispose() {
    followController.removeListener(_followScrollListener);
    followController.dispose();
    super.dispose();
  }

  Widget _buildFavorite() {
    var chatFavoriteList = ref.watch(chatFavoriteStateProvider);

    return chatFavoriteList.isEmpty
        ? const SizedBox.shrink()
        : ListView.separated(
            itemCount: chatFavoriteList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            // scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) {
              return SizedBox(
                width: 12.0.w,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return ChatSearchListItem(
                idx: chatFavoriteList[index].memberIdx,
                nick: chatFavoriteList[index].nick,
                intro: chatFavoriteList[index].introText,
                isFavorite: true,
                profileImgUrl: chatFavoriteList[index].profileImgUrl, //'assets/image/feed/image/sample_image3.png',
                chatMemberId: chatFavoriteList[index].chatMemberId,
                chatHomeServer: chatFavoriteList[index].chatHomeServer,
              );
            },
          );
  }

  Widget _buildFollow() {
    return Consumer(builder: (ctx, ref, child) {
      final followState = ref.watch(followStateProvider);
      final isLoadMoreError = followState.followListState.isLoadMoreError;
      final isLoadMoreDone = followState.followListState.isLoadMoreDone;
      final isLoading = followState.followListState.isLoading;
      final lists = followState.followListState.list;
      return ListView.builder(
        shrinkWrap: true,
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


          return ChatSearchListItem(
            idx: lists[index].memberIdx!,
            nick: lists[index].followNick ?? 'unknown',
            intro: lists[index].intro ?? '',
            isFavorite: true,
            profileImgUrl: lists[index].url ?? '', //'assets/image/feed/image/sample_image3.png',
            chatMemberId: lists[index].chatMemeberId ?? '',
            chatHomeServer: lists[index].chatHomeServer ?? '',
          );

          return FollowingItemWidget(
            profileImage: "${lists[index].url}",
            userName: lists[index].followNick!,
            content: lists[index].intro == "" ||
                lists[index].intro == null
                ? '소개글이 없습니다.'
                : lists[index].intro!,
            isSpecialUser: lists[index].isBadge! == 1,
            isFollow: lists[index].isFollow == 0,
            isNewUser: lists[index].newState! == 1,
            followIdx: lists[index].followIdx!,
            memberIdx: lists[index].memberIdx!,
          );
        },
      );
    });
  }


  Widget _buildBody() {
    var chatFavoriteList = ref.watch(chatFavoriteStateProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: FormBuilderTextField(
            name: 'follower',
            controller: searchController,
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
              suffixIcon: searchController.text.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      child: Icon(
                        Icons.search,
                        color: Colors.grey[600],
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        searchController.text = "";
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                        child: Icon(
                          Icons.close,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
              hintText: "메시지.닉네임을 검색해주세요".tr(),
              hintStyle: kBody11RegularStyle.copyWith(color: kNeutralColor500),
            ),
          ),
        ),
        SizedBox(
          height: 4.h,
        ),
        Column(
          children: [
            ExpansionTile(
              initiallyExpanded: true,
              title: Text(
                '메시지.즐겨찾기'.tr(),
                style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor, height: 1.2.h),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 12.0.w, top: 8.0.h, bottom: 12.0.h),
                  child: _buildFavorite(),
                ),
              ],
            ),
            ExpansionTile(
              initiallyExpanded: true,
              title: Text(
                '팔로잉',
                style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor, height: 1.2.h),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 12.0.w, top: 8.0.h, bottom: 12.0.h),
                  child: _buildFollow(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();

        return false;
      },
      child: Material(
        child: WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pop();
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(
                "메시지.메시지 상대 선택".tr(),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            body: SingleChildScrollView(
              controller: _scrollController,
              child: _buildBody(),
            ),
          ),
        ),
      ),
    );
  }
}
