import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pet_mobile_social_flutter/common/library/insta_assets_picker/assets_picker.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/bottom_sheet_button_item_widget.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/components/comment/comment_deatil_list_widget.dart';
import 'package:pet_mobile_social_flutter/components/dialog/custom_dialog.dart';
import 'package:pet_mobile_social_flutter/components/feed/feed_detail_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/feed_follow_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/feed_main_widget.dart';
import 'package:pet_mobile_social_flutter/components/toast/toast.dart';
import 'package:pet_mobile_social_flutter/components/user_list/favorite_list_widget.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/theme_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/feed_write/feed_write_screen.dart';
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
                    Row(
                      children: [
                        Image.asset(
                          'assets/image/header/icon/large_size/icon_camera.png',
                          height: 26.h,
                        ),
                        Image.asset(
                          'assets/image/header/icon/large_size/icon_feed.png',
                          height: 26.h,
                        ),
                        Image.asset(
                          'assets/image/header/icon/large_size/icon_more_h.png',
                          height: 26.h,
                        ),
                        AnimatedContainer(
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
                      ],
                    ),
                  ],
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ),
      body: SafeArea(
        child: DefaultTabController(
          length: 4,
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.start, // 변경된 부분
                                mainAxisSize: MainAxisSize.min, // 변경된 부분
                                children: [
                                  Image.asset(
                                    'assets/image/header/icon/large_size/icon_camera.png',
                                    height: 26.h,
                                  ),
                                  Image.asset(
                                    'assets/image/header/icon/large_size/icon_feed.png',
                                    height: 26.h,
                                  ),
                                  Image.asset(
                                    'assets/image/header/icon/large_size/icon_more_h.png',
                                    height: 26.h,
                                  ),
                                  AnimatedContainer(
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
                                ],
                              ),
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
                Container(
                  color: Colors.redAccent,
                ),
                Container(
                  color: Colors.blue,
                ),
                Container(
                  color: Colors.yellow,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _firstTab() {
    final theme = InstaAssetPicker.themeData(Theme.of(context).primaryColor);

    return ListView(
      children: <Widget>[
        const FeedFollowWidget(),
        const FeedDetailWidget(),
        const FeedMainWidget(),
        const FavoriteListWidget(),
        const CommentDetailListWidget(),
        TextButton(
          onPressed: () {
            showCustomModalBottomSheet(
              context: context,
              widget: Column(
                children: [
                  BottomSheetButtonItem(
                    iconImage:
                        'assets/image/feed/icon/small_size/icon_user_de.png',
                    title: '숨기기',
                    titleStyle:
                        kButton14BoldStyle.copyWith(color: kTextSubTitleColor),
                    onTap: () {},
                  ),
                  BottomSheetButtonItem(
                    iconImage:
                        'assets/image/feed/icon/small_size/icon_user_block_on.png',
                    title: '차단하기',
                    titleStyle:
                        kButton14BoldStyle.copyWith(color: kTextSubTitleColor),
                    onTap: () {},
                  ),
                  BottomSheetButtonItem(
                    iconImage:
                        'assets/image/feed/icon/small_size/icon_report.png',
                    title: '신고하기',
                    titleStyle: kButton14BoldStyle.copyWith(color: kBadgeColor),
                    onTap: () {},
                  ),
                ],
              ),
            );
          },
          child: const Text("feed bottom sheet button"),
        ),
        TextButton(
          onPressed: () {
            showCustomModalBottomSheet(
              context: context,
              widget: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Text(
                      "태그된 대상",
                      style:
                          kBody16BoldStyle.copyWith(color: kTextSubTitleColor),
                    ),
                  ),
                  const FavoriteListWidget(),
                ],
              ),
            );
          },
          child: const Text("태그된 대상"),
        ),
        TextButton(
          onPressed: () {
            toast(
                context: context,
                text: '광고성 정보 수신 여부가 ‘동의’로 변경되었습니다.',
                type: ToastType.purple,
                secondText:
                    "수신 동의일: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}");
          },
          child: const Text("수신 동의 토스트"),
        ),
        TextButton(
          onPressed: () {
            toast(
              context: context,
              text: '광고성 정보 수신 여부가 ‘거부’로 변경되었습니다.',
              type: ToastType.red,
            );
          },
          child: const Text("수신 거부 토스트"),
        ),
        TextButton(
          onPressed: () => InstaAssetPicker.pickAssets(
            context,
            maxAssets: 12,
            pickerTheme: themeData(context).copyWith(
              canvasColor: kNeutralColor100, // body background color
              colorScheme: theme.colorScheme.copyWith(
                background: kNeutralColor100, // albums list background color
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
          ),
          child: const Text(
            '이미지 선택',
          ),
        ),
        TextButton(
          onPressed: () async {
            final ImagePicker picker = ImagePicker();

            await picker.pickImage(source: ImageSource.camera);
          },
          child: const Text(
            '카메라 연결',
          ),
        ),
        TextButton(
          onPressed: () async {
            context.go("/test/myPage");
          },
          child: const Text(
            '마이페이지 이동',
          ),
        ),
        TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomDialog(
                    content: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.0.h),
                      child: Text(
                        "캐시를 삭제하시겠습니까?",
                        style:
                            kBody16BoldStyle.copyWith(color: kTextTitleColor),
                      ),
                    ),
                    confirmTap: () {
                      context.pop();
                    },
                    cancelTap: () {
                      context.pop();
                    },
                    confirmWidget: Text(
                      "삭제",
                      style: kButton14MediumStyle.copyWith(color: kBadgeColor),
                    ));
              },
            );
          },
          child: Text('팝업 버튼'),
        ),
        TextButton(
          onPressed: () async {
            context.go("/test/notification");
          },
          child: const Text(
            '알림함 이동',
          ),
        ),
      ],
    );
  }

  Widget _buildBackGround() {
    bool isBigDevice = MediaQuery.of(context).size.width >= 320;

    return Padding(
      padding: EdgeInsets.only(
        top: isBigDevice ? 50 : 5,
      ), // 50
      child: ListView.builder(
        itemCount: stories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                WidgetMask(
                  blendMode: BlendMode.srcATop,
                  childSaveLayer: true,
                  mask: Center(
                    child: Image.network(
                      stories[index].imageUrl,
                      height: 46.h,
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: SvgPicture.asset(
                    'assets/image/feed/image/squircle.svg',
                    height: 46.h,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  stories[index].name,
                  style: kBody12RegularStyle.copyWith(color: kTextTitleColor),
                ),
              ],
            ),
          );
        },
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
                  offset: Offset(0, -6),
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
                tabs: [
                  Text(
                    "최신",
                    style: kBody16MediumStyle,
                  ),
                  Text(
                    "작성글",
                    style: kBody16MediumStyle,
                  ),
                  Text(
                    "산책",
                    style: kBody16MediumStyle,
                  ),
                  Text(
                    "작성글",
                    style: kBody16MediumStyle,
                  ),
                ]),
          ),
          Spacer(),
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
