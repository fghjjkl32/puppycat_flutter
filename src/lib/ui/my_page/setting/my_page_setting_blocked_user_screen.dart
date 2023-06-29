import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/components/user_list/widget/blocked_user_item_widget.dart';
import 'package:pet_mobile_social_flutter/components/user_list/widget/tag_user_item_widget.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_user_search_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/setting/my_page_setting_blocked_user_provider.dart';

class MyPageSettingBlockedUserScreen extends ConsumerStatefulWidget {
  const MyPageSettingBlockedUserScreen({super.key});

  @override
  MyPageSettingBlockedUserScreenState createState() =>
      MyPageSettingBlockedUserScreenState();
}

class MyPageSettingBlockedUserScreenState
    extends ConsumerState<MyPageSettingBlockedUserScreen> {
  @override
  void initState() {
    super.initState();
    Future(() {
      ref.read(myPageSettingBlockUserProvider.notifier).onTextChanged("");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: WillPopScope(
        onWillPop: () async {
          context.pop();

          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text(
              "차단 친구 관리",
            ),
            leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                      child: FormBuilderTextField(
                        name: 'search',
                        initialValue: ref.watch(myPageSettingBlockUserProvider),
                        style: kBody13RegularStyle.copyWith(
                            color: kTextSubTitleColor),
                        onChanged: (value) => ref
                            .read(myPageSettingBlockUserProvider.notifier)
                            .onTextChanged(value!),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: kNeutralColor200,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
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
                          suffixIcon: ref
                                  .watch(
                                      myPageSettingBlockUserProvider.notifier)
                                  .state
                                  .isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 8.0),
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.grey[600],
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(feedWriteUserSearchProvider
                                            .notifier)
                                        .onTextChanged('');
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 8.0),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                          hintText: "검색어를 입력해 주세요.",
                          hintStyle: kBody11RegularStyle.copyWith(
                              color: kNeutralColor500),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Expanded(
                      child: ref
                              .watch(myPageSettingBlockUserProvider.notifier)
                              .searchResult
                              .isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Image.asset(
                                    'assets/image/feed_write/image/corgi-2 1.png',
                                    height: 68.h,
                                  ),
                                ),
                                SizedBox(
                                  height: 12.h,
                                ),
                                Text(
                                  "유저를 찾을 수 없습니다.",
                                  style: kBody12RegularStyle.copyWith(
                                      color: kTextBodyColor),
                                ),
                              ],
                            )
                          : ListView.builder(
                              itemCount: ref
                                  .watch(
                                      myPageSettingBlockUserProvider.notifier)
                                  .searchResult
                                  .length,
                              itemBuilder: (context, index) {
                                return BlockUserItemWidget(
                                  profileImage:
                                      'assets/image/feed/image/sample_image1.png',
                                  userName: ref
                                      .watch(myPageSettingBlockUserProvider
                                          .notifier)
                                      .searchResult[index],
                                  content: '사용자가 설정한 소개글',
                                  isSpecialUser: true,
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
