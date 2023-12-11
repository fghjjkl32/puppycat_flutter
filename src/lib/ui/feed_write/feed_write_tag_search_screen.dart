import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/components/user_list/widget/tag_user_item_widget.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/post_feed/tag.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_user_search_provider.dart';

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
      ref.read(feedWriteImageTagSearchProvider.notifier).initImageTagUserList(1);
    });

    userScrollController.addListener(_scrollListener);
    userSearchController.addListener(() {
      ref.watch(feedWriteImageTagSearchProvider.notifier).userSearchQuery.add(userSearchController.text);
    });
  }

  void _scrollListener() {
    if (userScrollController.position.pixels > userScrollController.position.maxScrollExtent - MediaQuery.of(context).size.height) {
      if (userOldLength == ref.read(feedWriteImageTagSearchProvider).list.length) {
        ref.read(feedWriteImageTagSearchProvider.notifier).loadMoreUserList();
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
                        suffixIcon: userSearchController.text.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                child: Icon(
                                  Puppycat_social.icon_search_medium,
                                  color: kPreviousNeutralColor600,
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
                                    color: kPreviousNeutralColor600,
                                  ),
                                ),
                              ),
                        hintText: "닉네임으로 검색해 보세요.",
                        hintStyle: kBody11RegularStyle.copyWith(color: kPreviousNeutralColor500),
                      ),
                    ),
                  ),
                  Expanded(
                    child: lists.isEmpty
                        ? Container(
                            color: kPreviousNeutralColor100,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  userSearchController.text == ""
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
                                    userSearchController.text == "" ? '태그한 유저가 없어요.\n유저를 검색해서 태그해 보세요.' : '유저를 찾을 수 없어요.\n닉네임을 다시 확인해 주세요.',
                                    textAlign: TextAlign.center,
                                    style: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor, height: 1.4, letterSpacing: 0.2),
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
                                          memberUuid: lists[index].memberUuid!,
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
                                  content: lists[index].intro! == "" ? "소개글이 없어요." : lists[index].intro!,
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
