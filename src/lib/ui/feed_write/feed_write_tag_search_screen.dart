import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/components/user_list/widget/tag_user_item_widget.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/post_feed/tag.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_user_search_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';

class FeedWriteTagSearchScreen extends ConsumerStatefulWidget {
  final Offset offset;
  final int imagePositionIndex;
  final int imageIdx;

  const FeedWriteTagSearchScreen({
    Key? key,
    required this.offset,
    required this.imagePositionIndex,
    required this.imageIdx,
  }) : super(key: key);

  @override
  FeedWriteTagSearchScreenState createState() => FeedWriteTagSearchScreenState();
}

class FeedWriteTagSearchScreenState extends ConsumerState<FeedWriteTagSearchScreen> {
  ScrollController userScrollController = ScrollController();
  final TextEditingController userSearchController = TextEditingController();

  int userOldLength = 0;

  @override
  void initState() {
    super.initState();

    Future(() {
      ref.watch(feedWriteImageTagSearchProvider.notifier).userMemberIdx = ref.watch(userInfoProvider).userModel!.idx;
      ref.read(feedWriteImageTagSearchProvider.notifier).initImageTagUserList(ref.watch(userInfoProvider).userModel!.idx, 1);
    });

    userScrollController.addListener(_scrollListener);
    userSearchController.addListener(() {
      ref.watch(feedWriteImageTagSearchProvider.notifier).userSearchQuery.add(userSearchController.text);
    });
  }

  void _scrollListener() {
    if (userScrollController.position.pixels > userScrollController.position.maxScrollExtent - MediaQuery.of(context).size.height) {
      if (userOldLength == ref.read(feedWriteImageTagSearchProvider).list.length) {
        ref.read(feedWriteImageTagSearchProvider.notifier).loadMoreUserList(ref.watch(userInfoProvider).userModel!.idx);
      }
    }
  }

  @override
  void dispose() {
    userScrollController.removeListener(_scrollListener);
    userScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "유저 태그하기",
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
      body: Consumer(builder: (ctx, ref, child) {
        final userState = ref.watch(feedWriteImageTagSearchProvider);
        final isLoadMoreError = userState.isLoadMoreError;
        final isLoadMoreDone = userState.isLoadMoreDone;
        final isLoading = userState.isLoading;
        final lists = userState.list;

        userOldLength = lists.length ?? 0;
        return Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    child: FormBuilderTextField(
                      name: 'search',
                      controller: userSearchController,
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
                        suffixIcon: userSearchController.text.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                child: Icon(
                                  Puppycat_social.icon_search_medium,
                                  color: kNeutralColor600,
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  userSearchController.text = "";
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                  child: Icon(
                                    Puppycat_social.icon_close_large,
                                    color: kNeutralColor600,
                                  ),
                                ),
                              ),
                        hintText: "검색어를 입력해 주세요.",
                        hintStyle: kBody11RegularStyle.copyWith(color: kNeutralColor500),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  userSearchController.text.isEmpty
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(
                                "태그하고 싶은 사람을 검색해 보세요!",
                                style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(
                                "닉네임 선택 시 선택한 위치에 태그가 표시됩니다.",
                                style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  SizedBox(
                    height: 3.h,
                  ),
                  SizedBox(
                    height: 26.h,
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
                            controller: userScrollController,
                            itemCount: lists.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  ref.watch(feedWriteProvider.notifier).addTag(
                                        Tag(
                                          username: lists[index].nick!,
                                          position: widget.offset,
                                          memberIdx: lists[index].memberIdx!,
                                          imageIndex: widget.imageIdx,
                                        ),
                                        widget.imagePositionIndex,
                                        context,
                                      );

                                  Navigator.of(context).pop();
                                },
                                child: TagUserItemWidget(
                                  profileImage: lists[index].profileImgUrl!,
                                  userName: lists[index].nick!,
                                  content: lists[index].intro! == "" ? "소개글이 없습니다." : lists[index].intro!,
                                  isSpecialUser: lists[index].isBadge == null ? false : lists[index].isBadge! == 1,
                                ),
                              );
                            },
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
