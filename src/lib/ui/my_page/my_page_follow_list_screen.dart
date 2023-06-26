import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_mobile_social_flutter/components/user_list/widget/follower_item_widget.dart';
import 'package:pet_mobile_social_flutter/components/user_list/widget/following_item_widget.dart';
import 'package:pet_mobile_social_flutter/components/user_list/widget/tag_user_item_widget.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/my_page_follower_user_search_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/my_page_following_user_search_provider.dart';
import 'package:widget_mask/widget_mask.dart';

class MyPageFollowListScreen extends ConsumerStatefulWidget {
  const MyPageFollowListScreen({super.key});

  @override
  MyPageFollowListScreenState createState() => MyPageFollowListScreenState();
}

class MyPageFollowListScreenState extends ConsumerState<MyPageFollowListScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    super.initState();
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
              title: const Text(
                "친구",
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back),
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
                    Text(
                      "팔로워",
                      style: kBody14BoldStyle,
                    ),
                    Text(
                      "팔로잉",
                      style: kBody14BoldStyle,
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
      ),
    );
  }

  Widget _firstTabBody() {
    final userFollowerSearchController =
        ref.watch(myPageFollowerUserSearchProvider.notifier);
    return Column(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: FormBuilderTextField(
                  name: 'follower',
                  initialValue: ref.watch(myPageFollowerUserSearchProvider),
                  style:
                      kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
                  onChanged: (value) => ref
                      .read(myPageFollowerUserSearchProvider.notifier)
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
                    suffixIcon: userFollowerSearchController.state.isEmpty
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
                                      myPageFollowerUserSearchProvider.notifier)
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
                    hintText: "닉네임을 입력해 주세요.",
                    hintStyle:
                        kBody11RegularStyle.copyWith(color: kNeutralColor500),
                  ),
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Expanded(
                child: userFollowerSearchController.searchResult.isEmpty
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
                        itemCount:
                            userFollowerSearchController.searchResult.length,
                        itemBuilder: (context, index) {
                          return FollowerItemWidget(
                            profileImage:
                                'assets/image/feed/image/sample_image1.png',
                            userName: userFollowerSearchController
                                .searchResult[index],
                            content: '사용자가 설정한 소개글',
                            isSpecialUser: true,
                            isFollow: true,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _secondTabBody() {
    final userFollowingSearchController =
        ref.watch(myPageFollowingUserSearchProvider.notifier);
    return Column(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: FormBuilderTextField(
                  name: 'follower',
                  initialValue: ref.watch(myPageFollowingUserSearchProvider),
                  style:
                      kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
                  onChanged: (value) => ref
                      .read(myPageFollowingUserSearchProvider.notifier)
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
                    suffixIcon: userFollowingSearchController.state.isEmpty
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
                                      myPageFollowerUserSearchProvider.notifier)
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
                    hintText: "닉네임을 입력해 주세요.",
                    hintStyle:
                        kBody11RegularStyle.copyWith(color: kNeutralColor500),
                  ),
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Expanded(
                child: userFollowingSearchController.searchResult.isEmpty
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
                        itemCount:
                            userFollowingSearchController.searchResult.length,
                        itemBuilder: (context, index) {
                          return FollowingItemWidget(
                            profileImage:
                                'assets/image/feed/image/sample_image1.png',
                            userName: userFollowingSearchController
                                .searchResult[index],
                            content: '사용자가 설정한 소개글',
                            isSpecialUser: true,
                            isFollow: true,
                            isNewUser: true,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
