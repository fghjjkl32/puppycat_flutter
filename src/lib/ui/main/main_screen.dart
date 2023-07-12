import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pet_mobile_social_flutter/common/library/insta_assets_picker/assets_picker.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/sheets/feed_write_show_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/bottom_sheet_button_item_widget.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/components/comment/comment_deatil_list_widget.dart';
import 'package:pet_mobile_social_flutter/components/dialog/custom_dialog.dart';
import 'package:pet_mobile_social_flutter/components/feed/feed_best_post_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/feed_detail_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/feed_follow_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/feed_main_widget.dart';
import 'package:pet_mobile_social_flutter/components/toast/toast.dart';
import 'package:pet_mobile_social_flutter/components/user_list/favorite_list_widget.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/theme_data.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/feed_write/feed_write_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/my_page_main_screen.dart';
import 'package:widget_mask/widget_mask.dart';

// class PuppyCatMain extends ConsumerWidget {
//   const PuppyCatMain({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     var userProvider = ref.watch(userModelProvider);
//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             children: [
//               Text('$userProvider'),
//               ElevatedButton(
//                   onPressed: () {
//                     if (userProvider == null) {
//                       print('aa');
//                       return;
//                     }
//                     ref
//                         .read(loginStateProvider.notifier)
//                         .logout(userProvider.simpleType, userProvider.appKey);
//                   },
//                   child: const Text('logout')),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class PuppyCatMain extends ConsumerStatefulWidget {
  const PuppyCatMain({Key? key}) : super(key: key);

  @override
  PuppyCatMainState createState() => PuppyCatMainState();
}

class PuppyCatMainState extends ConsumerState<PuppyCatMain> {
  final List<Story> stories = [
    Story(
      name: 'User 1',
      imageUrl: 'https://via.placeholder.com/150/f66b97',
    ),
    Story(
      name: 'User 2',
      imageUrl: 'https://via.placeholder.com/150/f66b97',
    ),
    Story(
      name: 'User 3',
      imageUrl: 'https://via.placeholder.com/150/f66b97',
    ),
    Story(
      name: 'User 4',
      imageUrl: 'https://via.placeholder.com/150/f66b97',
    ),
    Story(
      name: 'User 5',
      imageUrl: 'https://via.placeholder.com/150/f66b97',
    ),
    Story(
      name: 'User 5',
      imageUrl: 'https://via.placeholder.com/150/f66b97',
    ),
    Story(
      name: 'User 5',
      imageUrl: 'https://via.placeholder.com/150/f66b97',
    ),
    Story(
      name: 'User 5',
      imageUrl: 'https://via.placeholder.com/150/f66b97',
    ),
    Story(
      name: 'User 5',
      imageUrl: 'https://via.placeholder.com/150/f66b97',
    ),
    Story(
      name: 'User 5',
      imageUrl: 'https://via.placeholder.com/150/f66b97',
    ),
  ];

  late ScrollController _scrollController;
  bool _showIcon = false;

  List<Widget> getTabs() {
    final loginState = ref.watch(loginStateProvider);

    List<Widget> tabs = [
      Text(
        "최신",
        style: kBody16MediumStyle,
      ),
      Text(
        "산책",
        style: kBody16MediumStyle,
      ),
    ];

    if (loginState == LoginStatus.success) {
      tabs.addAll([
        Text(
          "팔로잉",
          style: kBody16MediumStyle,
        ),
        Text(
          "작성글",
          style: kBody16MediumStyle,
        ),
      ]);
    }

    return tabs;
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _showIcon = _scrollController.offset > 100.h;
        });
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isBigDevice = MediaQuery.of(context).size.width >= 320;
    final loginState = ref.watch(loginStateProvider);

    return Scaffold(
      appBar: isBigDevice
          ? null
          : PreferredSize(
              preferredSize: Size.fromHeight(30.0),
              child: AppBar(
                automaticallyImplyLeading: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "PUUPYCAT",
                      style: kTitle18BoldStyle,
                    ),
                    _buttonWidget(),
                  ],
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ),
      body: SafeArea(
        child: DefaultTabController(
          length: loginState == LoginStatus.success ? 4 : 2,
          child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                isBigDevice
                    ? SliverAppBar(
                        pinned: true,
                        snap: false,
                        floating: true,
                        expandedHeight: 220.0,
                        centerTitle: false,
                        leading: null,
                        titleSpacing: 0,
                        backgroundColor: kNeutralColor100,
                        automaticallyImplyLeading: false,
                        title: Row(
                          children: [
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: _buttonWidget(),
                            ),
                          ],
                        ),
                        flexibleSpace: FlexibleSpaceBar(
                          titlePadding: EdgeInsets.zero,
                          expandedTitleScale: 1.0,
                          centerTitle: false,
                          collapseMode: CollapseMode.pin,
                          title: _buildTabbar(innerBoxIsScrolled),
                          background: Container(
                            color: kNeutralColor100,
                            child: Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 16.0.h,
                                    left: 10.w,
                                  ),
                                  child: Text(
                                    "PUUPYCAT",
                                    style: kTitle18BoldStyle,
                                  ),
                                ),
                                _buildBackGround(),
                              ],
                            ),
                          ),
                        ),
                      )
                    : SliverAppBar(
                        pinned: true,
                        snap: false,
                        floating: true,
                        expandedHeight: 180.0,
                        centerTitle: false,
                        leading: null,
                        titleSpacing: 0,
                        backgroundColor: kNeutralColor100,
                        automaticallyImplyLeading: false,
                        flexibleSpace: FlexibleSpaceBar(
                          titlePadding: EdgeInsets.zero,
                          expandedTitleScale: 1.0,
                          centerTitle: false,
                          collapseMode: CollapseMode.pin,
                          title: _buildTabbar(innerBoxIsScrolled),
                          background: Container(
                            color: kNeutralColor100,
                            child: Stack(
                              children: [
                                _buildBackGround(),
                              ],
                            ),
                          ),
                        ),
                      ),
              ];
            },
            body: TabBarView(
              children: [
                _firstTab(),
                if (loginState == LoginStatus.success) ...[
                  _secondTab(),
                ],
                Container(
                  color: Colors.blue,
                ),
                if (loginState == LoginStatus.success) ...[
                  _fourthTab(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () async {
            final theme =
                InstaAssetPicker.themeData(Theme.of(context).primaryColor);

            final ImagePicker picker = ImagePicker();

            final pickedFile =
                await picker.pickImage(source: ImageSource.camera);

            if (pickedFile != null) {
              await ImageGallerySaver.saveFile(pickedFile.path);

              // ignore: use_build_context_synchronously
              InstaAssetPicker.pickAssets(
                context,
                maxAssets: 12,
                // ignore: use_build_context_synchronously
                pickerTheme: themeData(context).copyWith(
                  canvasColor: kNeutralColor100,
                  colorScheme: theme.colorScheme.copyWith(
                    background: kNeutralColor100,
                  ),
                  appBarTheme: theme.appBarTheme.copyWith(
                    backgroundColor: kNeutralColor100,
                  ),
                ),
                onCompleted: (cropStream) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FeedWriteScreen(
                        cropStream: cropStream,
                      ),
                    ),
                  );
                },
              );
            }
          },
          child: Image.asset(
            'assets/image/header/icon/large_size/icon_camera.png',
            height: 26.h,
          ),
        ),
        GestureDetector(
          onTap: () {
            feedWriteShowBottomSheet(
              context: context,
            );
          },
          child: Image.asset(
            'assets/image/header/icon/large_size/icon_feed.png',
            height: 26.h,
          ),
        ),
        PopupMenuButton(
          padding: EdgeInsets.zero,
          icon: Image.asset(
            'assets/image/header/icon/large_size/icon_more_h.png',
            height: 26.h,
          ),
          onSelected: (id) {
            if (id == 'notification') {
              context.go("/home/notification");
            }
            if (id == 'search') {}
            if (id == 'message') {
              context.push('/chatMain');
            }
            if (id == 'setting') {
              context.push("/home/myPage/setting");
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
                'notification',
                '알림',
                const Icon(Icons.notifications),
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
                'search',
                '검색',
                const Icon(Icons.search),
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
                'message',
                '메시지',
                const Icon(Icons.message),
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
        GestureDetector(
          onTap: () {
            context.go("/home/myPage");
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _showIcon ? 36.0 : 0.0,
            child: Opacity(
              opacity: _showIcon ? 1.0 : 0.0,
              child: WidgetMask(
                blendMode: BlendMode.srcATop,
                childSaveLayer: true,
                mask: Center(
                  child: Image.asset(
                    'assets/image/feed/icon/large_size/icon_taguser.png',
                    height: 22.h,
                    fit: BoxFit.fill,
                  ),
                ),
                child: SvgPicture.asset(
                  'assets/image/feed/image/squircle.svg',
                  height: 22.h,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _firstTab() {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 16.0.h),
          child: const FeedMainWidget(),
        ),
        const FeedMainWidget(),
        const FeedMainWidget(),
        const FeedMainWidget(),
        const FeedBestPostWidget(),
        const FeedMainWidget(),
        const FeedMainWidget(),
        const FeedMainWidget(),
        const FeedMainWidget(),
      ],
    );
  }

  Widget _secondTab() {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 16.0.h, left: 12.w, bottom: 14.h),
          child: Text(
            "인기있는 펫 집사들",
            style: kTitle16ExtraBoldStyle.copyWith(color: kNeutralColor600),
          ),
        ),
        const FeedFollowWidget(),
        const FeedMainWidget(),
        const FeedMainWidget(),
        const FeedMainWidget(),
        const FeedMainWidget(),
        const FeedBestPostWidget(),
        const FeedMainWidget(),
      ],
    );
  }

  Widget _fourthTab() {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 16.0.h),
          child: const FeedMainWidget(),
        ),
        const FeedMainWidget(),
        const FeedMainWidget(),
        const FeedMainWidget(),
        Padding(
          padding: EdgeInsets.only(
            left: 20.0.w,
            right: 20.0.w,
            bottom: 20.0.h,
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: kNeutralColor400,
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                feedWriteShowBottomSheet(
                  context: context,
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  '게시글 등록하기',
                  style: kBody14BoldStyle.copyWith(
                    color: kNeutralColor100,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackGround() {
    bool isBigDevice = MediaQuery.of(context).size.width >= 320;

    final loginState = ref.watch(loginStateProvider);

    return Padding(
      padding: EdgeInsets.only(
        top: isBigDevice ? 50 : 5,
      ),
      child: loginState == LoginStatus.success
          ? ListView.builder(
              itemCount: stories.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      index == 0
                          ? GestureDetector(
                              onTap: () {
                                context.go("/home/myPage");
                              },
                              child: buildWidgetMask(stories[index]),
                            )
                          : buildWidgetMask(stories[index]),
                      const SizedBox(height: 4.0),
                      Text(
                        index == 0 ? "my" : stories[index].name,
                        style: kBody12RegularStyle.copyWith(
                            color: kTextTitleColor),
                      ),
                    ],
                  ),
                );
              },
            )
          : GestureDetector(
              onTap: () {
                context.pushReplacement("/loginScreen");
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 16.h,
                  ),
                  Image.asset(
                    'assets/image/feed_write/image/corgi-2 1.png',
                    height: 36.h,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Center(
                    child: Text(
                      "로그인 하고 나랑 딱! 맞는 친구 보기",
                      style:
                          kBody13RegularStyle.copyWith(color: kTextBodyColor),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildWidgetMask(Story story) {
    return WidgetMask(
      blendMode: BlendMode.srcATop,
      childSaveLayer: true,
      mask: Center(
        child: Image.network(
          story.imageUrl,
          height: 46.h,
          fit: BoxFit.fill,
        ),
      ),
      child: SvgPicture.asset(
        'assets/image/feed/image/squircle.svg',
        height: 46.h,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _buildTabbar(bool innerBoxIsScrolled) {
    bool isBigDevice = MediaQuery.of(context).size.width >= 320;

    return Container(
      decoration: innerBoxIsScrolled
          ? const BoxDecoration(
              color: Colors.white,
            )
          : BoxDecoration(
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
            ),
      child: Row(
        children: [
          Flexible(
            flex: isBigDevice ? 1 : 2,
            child: TabBar(
              indicatorWeight: 3,
              labelColor: kNeutralColor600,
              indicatorColor: kNeutralColor600,
              unselectedLabelColor: kNeutralColor500,
              indicatorSize: TabBarIndicatorSize.tab,
              labelPadding: EdgeInsets.only(
                top: 10.h,
                bottom: 10.h,
              ),
              tabs: getTabs(),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class Story {
  final String name;
  final String imageUrl;

  Story({required this.name, required this.imageUrl});
}
