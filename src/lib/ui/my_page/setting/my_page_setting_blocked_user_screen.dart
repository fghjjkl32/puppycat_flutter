import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/components/user_list/widget/blocked_user_item_widget.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/block/block_state_provider.dart';

class MyPageSettingBlockedUserScreen extends ConsumerStatefulWidget {
  const MyPageSettingBlockedUserScreen({super.key});

  @override
  MyPageSettingBlockedUserScreenState createState() => MyPageSettingBlockedUserScreenState();
}

class MyPageSettingBlockedUserScreenState extends ConsumerState<MyPageSettingBlockedUserScreen> {
  ScrollController blockController = ScrollController();
  final TextEditingController blockSearchController = TextEditingController();

  int blockOldLength = 0;

  @override
  void initState() {
    super.initState();

    Future(() {
      ref.watch(blockStateProvider.notifier).userMemberIdx = ref.watch(userInfoProvider).userModel!.idx;
      ref.read(blockStateProvider.notifier).initBlockList(ref.watch(userInfoProvider).userModel!.idx, 1);
    });

    blockController.addListener(_blockScrollListener);
    blockSearchController.addListener(() {
      ref.watch(blockStateProvider.notifier).blockSearchQuery.add(blockSearchController.text);
    });
  }

  void _blockScrollListener() {
    if (blockController.position.pixels > blockController.position.maxScrollExtent - MediaQuery.of(context).size.height) {
      if (blockOldLength == ref.read(blockStateProvider).list.length) {
        ref.read(blockStateProvider.notifier).loadMoreBlockList(ref.watch(userInfoProvider).userModel!.idx);
      }
    }
  }

  @override
  void dispose() {
    blockController.removeListener(_blockScrollListener);
    blockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text(
            "차단 유저 관리",
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
          final blockState = ref.watch(blockStateProvider);
          final isLoadMoreError = blockState.isLoadMoreError;
          final isLoadMoreDone = blockState.isLoadMoreDone;
          final isLoading = blockState.isLoading;
          final lists = blockState.list;

          blockOldLength = lists.length ?? 0;
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
                        controller: blockSearchController,
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
                          suffixIcon: blockSearchController.text.isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                  child: Icon(
                                    Puppycat_social.icon_search_medium,
                                    color: kPreviousNeutralColor600,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    blockSearchController.text = "";
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
                    SizedBox(
                      height: 4.h,
                    ),
                    Expanded(
                      child: lists.isEmpty
                          ? Container(
                              color: kPreviousNeutralColor100,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    blockSearchController.text == ""
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
                                      blockSearchController.text == "" ? '차단한 유저가 없어요.' : '유저를 찾을 수 없어요.\n닉네임을 다시 확인해 주세요.',
                                      textAlign: TextAlign.center,
                                      style: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor, height: 1.4, letterSpacing: 0.2),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : ListView.builder(
                              controller: blockController,
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
                                return BlockUserItemWidget(
                                  profileImage: lists[index].profileImgUrl,
                                  userName: lists[index].nick!,
                                  content: lists[index].intro! == "" ? "소개글이 없어요." : lists[index].intro!,
                                  isSpecialUser: lists[index].isBadge == null ? false : lists[index].isBadge! == 1,
                                  memberIdx: lists[index].memberIdx!,
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
      ),
    );
  }
}
