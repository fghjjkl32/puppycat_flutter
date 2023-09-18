import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/bottom_sheet_button_item_widget.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/components/dialog/custom_dialog.dart';
import 'package:pet_mobile_social_flutter/components/user_list/widget/favorite_item_widget.dart';
import 'package:pet_mobile_social_flutter/components/user_list/widget/hashtag_item_widget.dart';
import 'package:pet_mobile_social_flutter/components/user_list/widget/recent_searches_hashtag_item_widget.dart';
import 'package:pet_mobile_social_flutter/components/user_list/widget/recent_searches_user_item_widget.dart';
import 'package:pet_mobile_social_flutter/components/user_list/widget/user_item_widget.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/search/full_search_state_notifier.dart';
import 'package:pet_mobile_social_flutter/providers/search/profile_search_state_notifier.dart';
import 'package:pet_mobile_social_flutter/providers/search/search_helper_provider.dart';
import 'package:pet_mobile_social_flutter/providers/search/tag_search_state_notifier.dart';
import 'package:pet_mobile_social_flutter/services/search/search_db_helper.dart';
import 'package:widget_mask/widget_mask.dart';

final searchProvider = FutureProvider<List<Searche>>((ref) async {
  final dbHelper = ref.read(dbHelperProvider);
  return dbHelper.getAllSearches();
});

class SearchScreen extends ConsumerStatefulWidget {
  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  bool _showTabs = false;

  ScrollController tagScrollController = ScrollController();
  int tagOldLength = 0;

  ScrollController profileScrollController = ScrollController();
  int profileOldLength = 0;

  @override
  void initState() {
    super.initState();
    tagScrollController.addListener(_tagScrollListener);
    profileScrollController.addListener(_profileScrollListener);

    _searchController.addListener(() {
      ref.watch(fullSearchStateProvider.notifier).searchQuery.add(_searchController.text);
    });

    _searchController.addListener(() {
      ref.watch(tagSearchStateProvider.notifier).searchQuery.add(_searchController.text);
    });

    _searchController.addListener(() {
      ref.watch(profileSearchStateProvider.notifier).searchQuery.add(_searchController.text);
    });

    _searchController.addListener(() {
      if (_searchController.text.isNotEmpty && !_showTabs) {
        setState(() {
          _showTabs = true;
        });
      } else if (_searchController.text.isEmpty && _showTabs) {
        setState(() {
          _showTabs = false;
        });
      }
    });
  }

  void _tagScrollListener() {
    if (tagScrollController.position.pixels > tagScrollController.position.maxScrollExtent - MediaQuery.of(context).size.height) {
      if (tagOldLength == ref.read(tagSearchStateProvider).list.length) {
        ref.read(tagSearchStateProvider.notifier).loadMoreTagSearchList(ref.read(userModelProvider)!.idx);
      }
    }
  }

  void _profileScrollListener() {
    if (profileScrollController.position.pixels > profileScrollController.position.maxScrollExtent - MediaQuery.of(context).size.height) {
      if (profileOldLength == ref.read(profileSearchStateProvider).list.length) {
        ref.read(profileSearchStateProvider.notifier).loadMoreNickSearchList(ref.read(userModelProvider)!.idx);
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: FormBuilderTextField(
            onSubmitted: (name) async {
              final dbHelper = ref.read(dbHelperProvider);
              final search = SearchesCompanion(
                name: Value(name ?? ""),
                content: const Value("search"),
                created: Value(DateTime.now()),
              );

              // 검색어를 저장합니다.
              await dbHelper.insertSearch(search);

              ref.refresh(searchProvider);
            },
            name: 'search',
            controller: _searchController,
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
              suffixIcon: _searchController.text.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Icon(
                        Puppycat_social.icon_search_medium,
                        color: kNeutralColor600,
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        _searchController.text = "";
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
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Puppycat_social.icon_back,
              size: 40,
            ),
          ),
        ),
        body: Column(
          children: [
            if (_showTabs)
              TabBar(
                indicatorWeight: 3,
                labelColor: kNeutralColor600,
                indicatorColor: kNeutralColor600,
                unselectedLabelColor: kNeutralColor500,
                indicatorSize: TabBarIndicatorSize.tab,
                labelPadding: EdgeInsets.only(
                  top: 10.h,
                  bottom: 10.h,
                ),
                tabs: [
                  Text(
                    "전체",
                    style: kBody16MediumStyle,
                  ),
                  Text(
                    "프로필",
                    style: kBody16MediumStyle,
                  ),
                  Text(
                    "해시태그",
                    style: kBody16MediumStyle,
                  ),
                  Text(
                    "산책",
                    style: kBody16MediumStyle,
                  ),
                ],
              ),
            Expanded(
              child: _showTabs
                  ? TabBarView(
                      children: [
                        Consumer(builder: (ctx, ref, child) {
                          final fullSearchState = ref.watch(fullSearchStateProvider);
                          final isLoadMoreError = fullSearchState.isLoadMoreError;
                          final isLoadMoreDone = fullSearchState.isLoadMoreDone;
                          final isLoading = fullSearchState.isLoading;
                          final nickList = fullSearchState.nick_list;
                          final tagList = fullSearchState.tag_list;
                          final bestList = fullSearchState.best_list;

                          if (tagList!.isEmpty && nickList!.isEmpty) {
                            return ListView(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 80.0),
                                    child: Text(
                                      "'${_searchController.text}'에 대한\n검색 내용이 없습니다.",
                                      textAlign: TextAlign.center,
                                      style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                  child: Divider(
                                    thickness: 1.h,
                                    height: 1.h,
                                    color: kNeutralColor300,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 18,
                                        left: 12,
                                        right: 12,
                                        bottom: 6,
                                      ),
                                      child: Text(
                                        "지금 많이 찾고 있어요!",
                                        style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Wrap(
                                        spacing: 8.0,
                                        runSpacing: 8.0,
                                        children: List<Widget>.generate(
                                          bestList!.length,
                                          (int index) {
                                            return ElevatedButton(
                                              onPressed: () async {
                                                final dbHelper = ref.read(dbHelperProvider);
                                                final hashtag = SearchesCompanion(
                                                  name: Value(bestList[index].searchWord!),
                                                  content: const Value("hashtag"),
                                                  created: Value(DateTime.now()),
                                                );

                                                await dbHelper.insertSearch(hashtag);

                                                ref.refresh(searchProvider);

                                                context.push("/home/search/${bestList[index].searchWord!}/0");
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: kPrimaryLightColor,
                                                shadowColor: Colors.transparent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(60),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min, // 여기에 min을 설정
                                                children: [
                                                  Image.asset(
                                                    'assets/image/search/icon/icon_tag_large.png',
                                                    height: 20,
                                                    fit: BoxFit.fill,
                                                    color: kPrimaryColor,
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    bestList[index].searchWord!,
                                                    style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            );
                          } else {
                            return ListView(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: nickList!.length + 1,
                                  itemBuilder: (BuildContext context, int index) {
                                    if (index == 0) {
                                      return nickList.isEmpty
                                          ? Container()
                                          : Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                    top: 18,
                                                    left: 12,
                                                    right: 12,
                                                    bottom: 6,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        "프로필",
                                                        style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          DefaultTabController.of(context).animateTo(1);
                                                        },
                                                        child: Text(
                                                          "전체보기",
                                                          style: kBody11SemiBoldStyle.copyWith(color: kTextBodyColor),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                    }

                                    if (index - 1 == nickList.length - 1) {
                                      // 마지막 항목인지 확인
                                      return Column(
                                        children: [
                                          UserItemWidget(
                                            profileImage: nickList[index - 1].profileImgUrl,
                                            userName: nickList[index - 1].nick!,
                                            content: nickList[index - 1].intro!,
                                            isSpecialUser: nickList[index - 1].isBadge == 1,
                                            memberIdx: nickList[index - 1].memberIdx!,
                                            contentType: 'profile',
                                            oldMemberIdx: 0,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                            child: Divider(
                                              thickness: 1.h,
                                              height: 1.h,
                                              color: kNeutralColor300,
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return UserItemWidget(
                                        profileImage: nickList[index - 1].profileImgUrl,
                                        userName: nickList[index - 1].nick!,
                                        content: nickList[index - 1].intro!,
                                        isSpecialUser: nickList[index - 1].isBadge == 1,
                                        memberIdx: nickList[index - 1].memberIdx!,
                                        contentType: 'profile',
                                        oldMemberIdx: 0,
                                      );
                                    }
                                  },
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: tagList.length + 1,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.only(bottom: 80.h),
                                  itemBuilder: (BuildContext context, int index) {
                                    if (index == 0) {
                                      return tagList.isEmpty
                                          ? Container()
                                          : Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                    top: 18,
                                                    left: 12,
                                                    right: 12,
                                                    bottom: 6,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        "해시태그",
                                                        style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          DefaultTabController.of(context).animateTo(2);
                                                        },
                                                        child: Text(
                                                          "전체보기",
                                                          style: kBody11SemiBoldStyle.copyWith(color: kTextBodyColor),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                    }
                                    return HashTagItemWidget(
                                      hashTag: tagList[index - 1].hashTag!,
                                      hashTagCnt: tagList[index - 1].hashTagContentsCnt!,
                                    );
                                  },
                                ),
                              ],
                            );
                          }
                        }),
                        Consumer(builder: (ctx, ref, child) {
                          final profileSearchState = ref.watch(profileSearchStateProvider);
                          final isLoadMoreError = profileSearchState.isLoadMoreError;
                          final isLoadMoreDone = profileSearchState.isLoadMoreDone;
                          final isLoading = profileSearchState.isLoading;
                          final bestList = profileSearchState.best_list;
                          final profileList = profileSearchState.list;

                          profileOldLength = profileList.length ?? 0;

                          if (profileSearchState.list.isEmpty) {
                            return ListView(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 80.0),
                                    child: Text(
                                      "'${_searchController.text}'에 대한\n검색 내용이 없습니다.",
                                      textAlign: TextAlign.center,
                                      style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                  child: Divider(
                                    thickness: 1.h,
                                    height: 1.h,
                                    color: kNeutralColor300,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 18,
                                        left: 12,
                                        right: 12,
                                        bottom: 6,
                                      ),
                                      child: Text(
                                        "지금 많이 찾고 있어요!",
                                        style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Wrap(
                                        spacing: 8.0,
                                        runSpacing: 8.0,
                                        children: List<Widget>.generate(
                                          bestList!.length,
                                          (int index) {
                                            return ElevatedButton(
                                              onPressed: () async {
                                                final dbHelper = ref.read(dbHelperProvider);
                                                final hashtag = SearchesCompanion(
                                                  name: Value(bestList[index].searchWord!),
                                                  content: const Value("hashtag"),
                                                  created: Value(DateTime.now()),
                                                );

                                                await dbHelper.insertSearch(hashtag);

                                                ref.refresh(searchProvider);

                                                context.push("/home/search/${bestList[index].searchWord!}/0");
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: kPrimaryLightColor,
                                                shadowColor: Colors.transparent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(60),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min, // 여기에 min을 설정
                                                children: [
                                                  Image.asset(
                                                    'assets/image/search/icon/icon_tag_large.png',
                                                    height: 20,
                                                    fit: BoxFit.fill,
                                                    color: kPrimaryColor,
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    bestList[index].searchWord!,
                                                    style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            );
                          } else {
                            return ListView.builder(
                              controller: profileScrollController,
                              itemCount: profileList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return UserItemWidget(
                                  profileImage: profileList[index].profileImgUrl,
                                  userName: profileList[index].nick!,
                                  content: profileList[index].intro!,
                                  isSpecialUser: profileList[index].isBadge == 1,
                                  memberIdx: profileList[index].memberIdx!,
                                  contentType: 'profile',
                                  oldMemberIdx: 0,
                                );
                              },
                            );
                          }
                        }),
                        Consumer(builder: (ctx, ref, child) {
                          final tagSearchState = ref.watch(tagSearchStateProvider);
                          final isLoadMoreError = tagSearchState.isLoadMoreError;
                          final isLoadMoreDone = tagSearchState.isLoadMoreDone;
                          final isLoading = tagSearchState.isLoading;
                          final bestList = tagSearchState.best_list;
                          final tagList = tagSearchState.list;

                          tagOldLength = tagList.length ?? 0;

                          if (tagSearchState.list.isEmpty) {
                            return ListView(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 80.0),
                                    child: Text(
                                      "'${_searchController.text}'에 대한\n검색 내용이 없습니다.",
                                      textAlign: TextAlign.center,
                                      style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                  child: Divider(
                                    thickness: 1.h,
                                    height: 1.h,
                                    color: kNeutralColor300,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 18,
                                        left: 12,
                                        right: 12,
                                        bottom: 6,
                                      ),
                                      child: Text(
                                        "지금 많이 찾고 있어요!",
                                        style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Wrap(
                                        spacing: 8.0,
                                        runSpacing: 8.0,
                                        children: List<Widget>.generate(
                                          bestList!.length,
                                          (int index) {
                                            return ElevatedButton(
                                              onPressed: () async {
                                                final dbHelper = ref.read(dbHelperProvider);
                                                final hashtag = SearchesCompanion(
                                                  name: Value(bestList[index].searchWord!),
                                                  content: const Value("hashtag"),
                                                  created: Value(DateTime.now()),
                                                );

                                                await dbHelper.insertSearch(hashtag);

                                                ref.refresh(searchProvider);

                                                context.push("/home/search/${bestList[index].searchWord!}/0");
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: kPrimaryLightColor,
                                                shadowColor: Colors.transparent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(60),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min, // 여기에 min을 설정
                                                children: [
                                                  Image.asset(
                                                    'assets/image/search/icon/icon_tag_large.png',
                                                    height: 20,
                                                    fit: BoxFit.fill,
                                                    color: kPrimaryColor,
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    bestList[index].searchWord!,
                                                    style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            );
                          } else {
                            return ListView.builder(
                              controller: tagScrollController,
                              itemCount: tagList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return HashTagItemWidget(
                                  hashTag: tagList[index].hashTag!,
                                  hashTagCnt: tagList[index].hashTagContentsCnt!,
                                );
                              },
                            );
                          }
                        }),
                        Center(child: Text('Tab 4 Content')),
                      ],
                    )
                  : ref.watch(searchProvider).when(
                      data: (searches) {
                        if (searches.isEmpty) {
                          return Container(
                            color: kNeutralColor100,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/image/chat/empty_character_01_nopost_88_x2.png',
                                    width: 88,
                                    height: 88,
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    '최근 검색어가 없습니다.',
                                    textAlign: TextAlign.center,
                                    style: kBody13RegularStyle.copyWith(color: kTextBodyColor, height: 1.4, letterSpacing: 0.2),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: searches.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 18,
                                      left: 12,
                                      right: 12,
                                      bottom: 6,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "최근검색어",
                                          style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            showCustomModalBottomSheet(
                                              context: context,
                                              widget: Column(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          "최근 검색어를 모두\n삭제하시겠습니까?",
                                                          style: kBody16BoldStyle.copyWith(color: kTextTitleColor),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 10.h),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () async {
                                                          context.pop();
                                                        },
                                                        child: Container(
                                                          width: 152.w,
                                                          height: 36.h,
                                                          decoration: const BoxDecoration(
                                                            color: kNeutralColor300,
                                                            borderRadius: BorderRadius.all(
                                                              Radius.circular(8.0),
                                                            ),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              "취소",
                                                              style: kButton14BoldStyle.copyWith(color: kTextSubTitleColor),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 8.w,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          context.pop();

                                                          final dbHelper = ref.read(dbHelperProvider);
                                                          await dbHelper.deleteAllSearches();

                                                          ref.refresh(searchProvider);
                                                        },
                                                        child: Container(
                                                          width: 152.w,
                                                          height: 36.h,
                                                          decoration: const BoxDecoration(
                                                            color: kBadgeColor,
                                                            borderRadius: BorderRadius.all(
                                                              Radius.circular(8.0),
                                                            ),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              "삭제",
                                                              style: kButton14BoldStyle.copyWith(color: kNeutralColor100),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "전체 삭제",
                                            style: kBody11SemiBoldStyle.copyWith(color: kTextBodyColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }

                            final search = searches[index - 1];

                            if (search.content == "profile") {
                              return RecentSearchesUserItemWidget(
                                profileImage: search.image,
                                userName: search.name!,
                                content: search.intro!,
                                isSpecialUser: search.isBadge!,
                                memberIdx: search.contentId!,
                                search: search,
                                dateTime: search.created!,
                                oldMemberIdx: 0,
                              );
                            } else if (search.content == "hashtag" || search.content == "search") {
                              return InkWell(
                                onTap: () {
                                  search.content == "search" ? _searchController.text = search.name! : context.push("/home/search/${search.name}/0");
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(left: 12.0.w, right: 12.w, bottom: 8.h, top: 8.h),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(
                                                right: 10.w,
                                              ),
                                              child: WidgetMask(
                                                blendMode: BlendMode.srcATop,
                                                childSaveLayer: true,
                                                mask: Center(
                                                  child: search.content! == "search"
                                                      ? Image.asset(
                                                          'assets/image/header/icon/small_size/icon_search_medium.png',
                                                          height: 20.h,
                                                          fit: BoxFit.fill,
                                                        )
                                                      : Image.asset(
                                                          'assets/image/search/icon/icon_tag_large.png',
                                                          height: 20.h,
                                                          fit: BoxFit.fill,
                                                        ),
                                                ),
                                                child: SvgPicture.asset(
                                                  'assets/image/feed/image/squircle.svg',
                                                  height: 32.h,
                                                ),
                                              )),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                search.name!,
                                                style: kBody13BoldStyle.copyWith(color: kTextTitleColor),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            DateFormat('MM.dd').format(search.created!),
                                            style: kBadge10MediumStyle.copyWith(color: kTextBodyColor),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: GestureDetector(
                                                onTap: () async {
                                                  final dbHelper = ref.read(dbHelperProvider);
                                                  // 탭하면 검색 기록을 삭제합니다.
                                                  await dbHelper.deleteSearch(search);

                                                  // Refresh the provider to trigger the search again
                                                  ref.refresh(searchProvider);
                                                },
                                                child: const Icon(
                                                  Puppycat_social.icon_close_medium,
                                                  color: kTextBodyColor,
                                                  size: 26,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                      error: (err, _) {
                        return Center(child: Text('Error: $err'));
                      },
                      loading: () {
                        return Center(child: CircularProgressIndicator());
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
