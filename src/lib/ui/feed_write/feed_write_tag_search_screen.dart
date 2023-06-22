import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/components/user_list/widget/tag_user_item_widget.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/post_feed/tag.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_user_search_provider.dart';

class FeedWriteTagSearchScreen extends ConsumerWidget {
  final Offset offset;
  final int imageIndex;

  const FeedWriteTagSearchScreen({
    Key? key,
    required this.offset,
    required this.imageIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSearchController =
        ref.watch(feedWriteUserSearchProvider.notifier);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
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
                      initialValue: ref.watch(feedWriteUserSearchProvider),
                      style: kBody13RegularStyle.copyWith(
                          color: kTextSubTitleColor),
                      onChanged: (value) => ref
                          .read(feedWriteUserSearchProvider.notifier)
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
                        suffixIcon: userSearchController.state.isEmpty
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
                                      .read(
                                          feedWriteUserSearchProvider.notifier)
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
                  userSearchController.searchResult.isEmpty
                      ? Container()
                      : Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(
                                "태그하고 싶은 사람을 검색해 보세요!",
                                style: kTitle16ExtraBoldStyle.copyWith(
                                    color: kTextTitleColor),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(
                                "닉네임 선택 시 선택한 위치에 태그가 표시됩니다.",
                                style: kBody12RegularStyle.copyWith(
                                    color: kTextBodyColor),
                              ),
                            ),
                          ],
                        ),
                  SizedBox(
                    height: 3.h,
                  ),
                  SizedBox(
                    height: 26.h,
                  ),
                  Expanded(
                    child: userSearchController.searchResult.isEmpty
                        ? Center(
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/image/feed_write/image/corgi-2 1.png',
                                  height: 68.h,
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
                            ),
                          )
                        : ListView.builder(
                            itemCount: userSearchController.searchResult.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  ref.watch(feedWriteProvider.notifier).addTag(
                                        Tag(
                                            username: userSearchController
                                                .searchResult[index],
                                            position: offset),
                                        imageIndex,
                                        context,
                                      );

                                  Navigator.of(context).pop();
                                },
                                child: TagUserItemWidget(
                                  profileImage:
                                      'assets/image/feed/image/sample_image1.png',
                                  userName:
                                      userSearchController.searchResult[index],
                                  content: '사용자가 설정한 소개글',
                                  isSpecialUser: true,
                                ),
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
    );
  }
}
