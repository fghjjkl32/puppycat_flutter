import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/components/comment/widget/comment_detail_item_widget.dart';
import 'package:pet_mobile_social_flutter/components/user_list/widget/favorite_item_widget.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_information/my_information_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/my_information/my_information_state_provider.dart';
import 'package:widget_mask/widget_mask.dart';

class MyPageMainScreen extends ConsumerStatefulWidget {
  const MyPageMainScreen({super.key});

  @override
  MyPageMainState createState() => MyPageMainState();
}

class MyPageMainState extends ConsumerState<MyPageMainScreen>
    with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  late TabController tabController;
  Color appBarColor = Colors.transparent;

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    ref.read(myInformationStateProvider.notifier).getMyInformation(
          ref.read(userModelProvider)!.idx,
        );
    super.initState();
  }

  void _scrollListener() {
    if (scrollController.offset >= 128.h && appBarColor != kNeutralColor100) {
      setState(() {
        appBarColor = kNeutralColor100;
      });
    } else if (scrollController.offset < 128.h &&
        appBarColor != Colors.transparent) {
      setState(() {
        appBarColor = Colors.transparent;
      });
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();

        return false;
      },
      child: Material(
        child: SafeArea(
            child: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            controller: scrollController,
            physics: const ClampingScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                Consumer(builder: (context, ref, _) {
                  AsyncValue<List<MyInformationItemModel>> myInfo =
                      ref.watch(myInformationFutureProvider);

                  return myInfo.when(
                    data: (data) {
                      return SliverAppBar(
                          pinned: true,
                          floating: false,
                          backgroundColor: appBarColor,
                          title: const Text('마이페이지'),
                          leading: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.arrow_back),
                          ),
                          forceElevated: innerBoxIsScrolled,
                          actions: [
                            PopupMenuButton(
                              icon: const Icon(Icons.more_horiz),
                              onSelected: (id) {
                                if (id == 'myActivity') {
                                  context.go("/home/myPage/myActivity");
                                }
                                if (id == 'postsManagement') {
                                  context.go("/home/myPage/myPost");
                                }
                                if (id == 'setting') {
                                  context.go("/home/myPage/setting");
                                }
                              },
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16.0),
                                  bottomRight: Radius.circular(16.0),
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                ),
                              ),
                              itemBuilder: (context) {
                                final list = <PopupMenuEntry>[];
                                list.add(
                                  diaryPopUpMenuItem(
                                    'myActivity',
                                    '내 활동',
                                    const Icon(Icons.person),
                                    context,
                                  ),
                                );
                                list.add(
                                  const PopupMenuDivider(
                                    height: 5,
                                  ),
                                );
                                list.add(
                                  diaryPopUpMenuItem(
                                    'postsManagement',
                                    '내 글 관리',
                                    const Icon(Icons.post_add_outlined),
                                    context,
                                  ),
                                );
                                list.add(
                                  const PopupMenuDivider(
                                    height: 5,
                                  ),
                                );
                                list.add(
                                  diaryPopUpMenuItem(
                                    'setting',
                                    '설정',
                                    const Icon(Icons.settings),
                                    context,
                                  ),
                                );
                                return list;
                              },
                            ),
                          ],
                          expandedHeight: 130.h,
                          flexibleSpace: _myPageSuccessProfile(data[0]));
                    },
                    loading: () {
                      return SliverAppBar(
                          pinned: true,
                          floating: false,
                          backgroundColor: appBarColor,
                          title: const Text('마이페이지'),
                          leading: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.arrow_back),
                          ),
                          forceElevated: innerBoxIsScrolled,
                          actions: [
                            PopupMenuButton(
                              icon: const Icon(Icons.more_horiz),
                              onSelected: (id) {
                                if (id == 'myActivity') {
                                  context.go("/home/myPage/myActivity");
                                }
                                if (id == 'postsManagement') {
                                  context.go("/home/myPage/myPost");
                                }
                                if (id == 'setting') {
                                  context.go("/home/myPage/setting");
                                }
                              },
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16.0),
                                  bottomRight: Radius.circular(16.0),
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                ),
                              ),
                              itemBuilder: (context) {
                                final list = <PopupMenuEntry>[];
                                list.add(
                                  diaryPopUpMenuItem(
                                    'myActivity',
                                    '내 활동',
                                    const Icon(Icons.person),
                                    context,
                                  ),
                                );
                                list.add(
                                  const PopupMenuDivider(
                                    height: 5,
                                  ),
                                );
                                list.add(
                                  diaryPopUpMenuItem(
                                    'postsManagement',
                                    '내 글 관리',
                                    const Icon(Icons.post_add_outlined),
                                    context,
                                  ),
                                );
                                list.add(
                                  const PopupMenuDivider(
                                    height: 5,
                                  ),
                                );
                                list.add(
                                  diaryPopUpMenuItem(
                                    'setting',
                                    '설정',
                                    const Icon(Icons.settings),
                                    context,
                                  ),
                                );
                                return list;
                              },
                            ),
                          ],
                          expandedHeight: 130.h,
                          flexibleSpace: _myPageProfile());
                    },
                    error: (error, stackTrace) {
                      return SliverAppBar(
                          pinned: true,
                          floating: false,
                          backgroundColor: appBarColor,
                          title: const Text('마이페이지'),
                          leading: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.arrow_back),
                          ),
                          forceElevated: innerBoxIsScrolled,
                          actions: [
                            PopupMenuButton(
                              icon: const Icon(Icons.more_horiz),
                              onSelected: (id) {
                                if (id == 'myActivity') {
                                  context.go("/home/myPage/myActivity");
                                }
                                if (id == 'postsManagement') {
                                  context.go("/home/myPage/myPost");
                                }
                                if (id == 'setting') {
                                  context.go("/home/myPage/setting");
                                }
                              },
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16.0),
                                  bottomRight: Radius.circular(16.0),
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                ),
                              ),
                              itemBuilder: (context) {
                                final list = <PopupMenuEntry>[];
                                list.add(
                                  diaryPopUpMenuItem(
                                    'myActivity',
                                    '내 활동',
                                    const Icon(Icons.person),
                                    context,
                                  ),
                                );
                                list.add(
                                  const PopupMenuDivider(
                                    height: 5,
                                  ),
                                );
                                list.add(
                                  diaryPopUpMenuItem(
                                    'postsManagement',
                                    '내 글 관리',
                                    const Icon(Icons.post_add_outlined),
                                    context,
                                  ),
                                );
                                list.add(
                                  const PopupMenuDivider(
                                    height: 5,
                                  ),
                                );
                                list.add(
                                  diaryPopUpMenuItem(
                                    'setting',
                                    '설정',
                                    const Icon(Icons.settings),
                                    context,
                                  ),
                                );
                                return list;
                              },
                            ),
                          ],
                          expandedHeight: 130.h,
                          flexibleSpace: _myPageProfile());
                    },
                  );
                }),
                const SliverPersistentHeader(
                  delegate: TabBarDelegate(),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
              children: [
                _firstTabBody(),
                _secondTabBody(),
              ],
            ),
          ),
        )),
      ),
    );
  }

  Widget _firstTabBody() {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(10, (index) {
        return Container(
          margin: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () {
              context.go("/home/myPage/detail/왕티즈왕왕/게시물");
            },
            child: Center(
              child: Stack(
                children: [
                  Image.asset(
                    'assets/image/feed/image/sample_image5.png',
                    fit: BoxFit.fill,
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.5),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 6.0.w, top: 2.h, right: 2.w),
                          child: InkWell(
                            onTap: () {
                              showCustomModalBottomSheet(
                                context: context,
                                widget: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 8.0.h,
                                        bottom: 10.0.h,
                                      ),
                                      child: Text(
                                        "좋아요",
                                        style: kTitle16ExtraBoldStyle.copyWith(
                                            color: kTextSubTitleColor),
                                      ),
                                    ),
                                    const FavoriteItemWidget(
                                      profileImage:
                                          'assets/image/feed/image/sample_image1.png',
                                      userName: '말티푸달콩',
                                      content: '사용자가 설정한 소개글',
                                      isSpecialUser: false,
                                      isFollow: true,
                                    ),
                                    const FavoriteItemWidget(
                                      profileImage:
                                          'assets/image/feed/image/sample_image1.png',
                                      userName: '말티푸달콩',
                                      content: '사용자가 설정한 소개글',
                                      isSpecialUser: false,
                                      isFollow: true,
                                    ),
                                    const FavoriteItemWidget(
                                      profileImage:
                                          'assets/image/feed/image/sample_image1.png',
                                      userName: '말티푸달콩',
                                      content: '사용자가 설정한 소개글',
                                      isSpecialUser: false,
                                      isFollow: true,
                                    ),
                                    const FavoriteItemWidget(
                                      profileImage:
                                          'assets/image/feed/image/sample_image1.png',
                                      userName: '말티푸달콩',
                                      content: '사용자가 설정한 소개글',
                                      isSpecialUser: false,
                                      isFollow: true,
                                    ),
                                    const FavoriteItemWidget(
                                      profileImage:
                                          'assets/image/feed/image/sample_image1.png',
                                      userName: '말티푸달콩',
                                      content: '사용자가 설정한 소개글',
                                      isSpecialUser: false,
                                      isFollow: true,
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Image.asset(
                              'assets/image/feed/icon/small_size/icon_comment_like_off.png',
                              height: 26.w,
                            ),
                          ),
                        ),
                        Text(
                          '21',
                          style: kBadge10MediumStyle.copyWith(
                              color: kNeutralColor100),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 6.0.w, top: 2.h, right: 2.w),
                          child: InkWell(
                            onTap: () {
                              showCustomModalBottomSheet(
                                context: context,
                                widget: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 8.0.h,
                                        bottom: 10.0.h,
                                      ),
                                      child: Text(
                                        "댓글",
                                        style: kTitle16ExtraBoldStyle.copyWith(
                                            color: kTextSubTitleColor),
                                      ),
                                    ),
                                    CommentDetailItemWidget(
                                      profileImage:
                                          'assets/image/feed/image/sample_image1.png',
                                      name: 'bichon_딩동',
                                      comment:
                                          '헤엑😍 넘 귀엽자농~ 모자 쓴거야? 귀여미!!! 너무 행복해...',
                                      isSpecialUser: true,
                                      time: DateTime(2023, 5, 28),
                                      isReply: false,
                                      likeCount: 42,
                                    ),
                                    CommentDetailItemWidget(
                                      profileImage:
                                          'assets/image/feed/image/sample_image2.png',
                                      name: 'baejji',
                                      comment: '사장님 저희 백설기 안시켰는데여??',
                                      isSpecialUser: false,
                                      time: DateTime(2023, 5, 28),
                                      isReply: false,
                                      likeCount: 32,
                                    ),
                                    CommentDetailItemWidget(
                                      profileImage:
                                          'assets/image/feed/image/sample_image2.png',
                                      name: 'bichon_딩동',
                                      comment: '@baejji 시켜쨔나욧❕❕🐶',
                                      isSpecialUser: true,
                                      time: DateTime(2023, 5, 28),
                                      isReply: true,
                                      likeCount: 32,
                                    ),
                                    // const CommentCustomTextField(),
                                  ],
                                ),
                              );
                            },
                            child: Image.asset(
                              'assets/image/feed/icon/small_size/icon_comment_comment.png',
                              height: 24.w,
                            ),
                          ),
                        ),
                        Text(
                          '3',
                          style: kBadge10MediumStyle.copyWith(
                              color: kNeutralColor100),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 6.w,
                    top: 6.w,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff414348).withOpacity(0.75),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5.0)),
                      ),
                      width: 18.w,
                      height: 14.w,
                      child: Center(
                        child: Text(
                          "3",
                          style: kBadge9RegularStyle.copyWith(
                              color: kNeutralColor100),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _secondTabBody() {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(10, (index) {
        return Container(
          margin: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () {
              context.go("/home/myPage/detail/왕티즈왕왕/태그됨");
            },
            child: Center(
              child: Stack(
                children: [
                  Image.asset(
                    'assets/image/feed/image/sample_image5.png',
                    fit: BoxFit.fill,
                  ),
                  Positioned(
                    right: 6.w,
                    top: 6.w,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff414348).withOpacity(0.75),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5.0)),
                      ),
                      width: 18.w,
                      height: 14.w,
                      child: Center(
                        child: Text(
                          "3",
                          style: kBadge9RegularStyle.copyWith(
                              color: kNeutralColor100),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _myPageSuccessProfile(MyInformationItemModel data) {
    return FlexibleSpaceBar(
      centerTitle: true,
      expandedTitleScale: 1.0,
      background: Padding(
        padding: const EdgeInsets.only(top: kToolbarHeight),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: WidgetMask(
                blendMode: BlendMode.srcATop,
                childSaveLayer: true,
                mask: data.profileImgUrl == null
                    ? Center(
                        child: Image.asset(
                          'assets/image/feed/image/sample_image3.png',
                          height: 48.h,
                          fit: BoxFit.fill,
                        ),
                      )
                    : Center(
                        child: Image.asset(
                          data.profileImgUrl!,
                          height: 48.h,
                          fit: BoxFit.fill,
                        ),
                      ),
                child: SvgPicture.asset(
                  'assets/image/feed/image/squircle.svg',
                  height: 48.h,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/image/feed/icon/small_size/icon_special.png',
                      height: 13.h,
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    Text(
                      "${data.nick}",
                      style: kTitle16ExtraBoldStyle.copyWith(
                          color: kTextTitleColor),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.go("/home/myPage/profileEdit");
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.edit,
                          color: kNeutralColor500,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  data.intro == null ? "소개글이 없습니다." : "${data.intro}",
                  style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
                ),
                GestureDetector(
                  onTap: () {
                    context.go("/home/myPage/followList");
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0.h),
                    child: Row(
                      children: [
                        Text(
                          "팔로워 ",
                          style: kBody11RegularStyle.copyWith(
                              color: kTextBodyColor),
                        ),
                        Text(
                          "265",
                          style: kBody11SemiBoldStyle.copyWith(
                              color: kTextSubTitleColor),
                        ),
                        Text(
                          "  ·  ",
                          style: kBody11RegularStyle.copyWith(
                              color: kTextBodyColor),
                        ),
                        Text(
                          "팔로잉 ",
                          style: kBody11RegularStyle.copyWith(
                              color: kTextBodyColor),
                        ),
                        Text(
                          "165",
                          style: kBody11SemiBoldStyle.copyWith(
                              color: kTextSubTitleColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _myPageProfile() {
    return FlexibleSpaceBar(
      centerTitle: true,
      expandedTitleScale: 1.0,
      background: Padding(
        padding: const EdgeInsets.only(top: kToolbarHeight),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: WidgetMask(
                blendMode: BlendMode.srcATop,
                childSaveLayer: true,
                mask: Center(
                  child: Image.asset(
                    'assets/image/feed/image/sample_image3.png',
                    height: 48.h,
                    fit: BoxFit.fill,
                  ),
                ),
                child: SvgPicture.asset(
                  'assets/image/feed/image/squircle.svg',
                  height: 48.h,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/image/feed/icon/small_size/icon_special.png',
                      height: 13.h,
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    Text(
                      "왕티즈왕왕",
                      style: kTitle16ExtraBoldStyle.copyWith(
                          color: kTextTitleColor),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.go("/home/myPage/profileEdit");
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.edit,
                          color: kNeutralColor500,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  "딸기🍓를 좋아하는 왕큰 말티즈🐶 왕왕이💛🤍 ",
                  style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
                ),
                GestureDetector(
                  onTap: () {
                    context.go("/home/myPage/followList");
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0.h),
                    child: Row(
                      children: [
                        Text(
                          "팔로워 ",
                          style: kBody11RegularStyle.copyWith(
                              color: kTextBodyColor),
                        ),
                        Text(
                          "265",
                          style: kBody11SemiBoldStyle.copyWith(
                              color: kTextSubTitleColor),
                        ),
                        Text(
                          "  ·  ",
                          style: kBody11RegularStyle.copyWith(
                              color: kTextBodyColor),
                        ),
                        Text(
                          "팔로잉 ",
                          style: kBody11RegularStyle.copyWith(
                              color: kTextBodyColor),
                        ),
                        Text(
                          "165",
                          style: kBody11SemiBoldStyle.copyWith(
                              color: kTextSubTitleColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

PopupMenuItem diaryPopUpMenuItem(
  String title,
  String value,
  Widget icon,
  BuildContext context,
) {
  return PopupMenuItem(
    value: title,
    child: Center(
      child: Row(
        children: [
          icon,
          SizedBox(
            width: 10.w,
          ),
          Text(
            value,
            style: kButton12BoldStyle.copyWith(color: kTextSubTitleColor),
          ),
        ],
      ),
    ),
  );
}

class TabBarDelegate extends SliverPersistentHeaderDelegate {
  const TabBarDelegate();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: shrinkOffset == 0
          ? BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: -5,
                  blurRadius: 7,
                  offset: const Offset(0, -6),
                ),
              ],
            )
          : const BoxDecoration(
              color: Colors.white,
            ),
      child: Row(
        children: [
          Expanded(
            child: TabBar(
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
                    "일상글",
                    style: kBody14BoldStyle,
                  ),
                  Text(
                    "태그됨",
                    style: kBody14BoldStyle,
                  ),
                ]),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 46;

  @override
  double get minExtent => 46;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
