import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/library/insta_assets_picker/assets_picker.dart';
import 'package:pet_mobile_social_flutter/components/feed/feed_main_widget.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/theme_data.dart';
import 'package:pet_mobile_social_flutter/controller/permission/permissions.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/follow_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/my_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/popular_hour_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/popular_week_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/recent_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/user_list/favorite_user_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/user_list/popular_user_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/follow/follow_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/restrain/restrain_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/feed_write/feed_write_screen.dart';
import 'package:pet_mobile_social_flutter/ui/main/popupmenu_with_reddot_widget.dart';
import 'package:thumbor/thumbor.dart';
import 'package:widget_mask/widget_mask.dart';

class PuppyCatMain extends ConsumerStatefulWidget {
  final int initialTabIndex;

  const PuppyCatMain({Key? key, this.initialTabIndex = 0}) : super(key: key);

  @override
  PuppyCatMainState createState() => PuppyCatMainState();
}

class PuppyCatMainState extends ConsumerState<PuppyCatMain> with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  late TabController tabController;
  bool _showIcon = false;

  late final PagingController<int, FeedData> _myFeedListPagingController = ref.watch(myFeedStateProvider);
  late final PagingController<int, FeedData> _recentFeedListPagingController = ref.watch(recentFeedStateProvider);
  late final PagingController<int, FeedData> _followFeedListPagingController = ref.watch(followFeedStateProvider);
  late final PagingController<int, FeedData> _popularWeekFeedListPagingController = ref.watch(popularWeekFeedStateProvider);

  // bool showLottieAnimation = false;
  bool _isWidgetVisible = true;

  List<Widget> getTabs() {
    final loginState = ref.read(loginStateProvider);

    List<Widget> tabs = [
      Text(
        "전체",
        style: kBody16MediumStyle,
      ),
      // Text(
      //   "산책",
      //   style: kBody16MediumStyle,
      // ),
    ];

    if (loginState == LoginStatus.success) {
      tabs.addAll([
        Text(
          "팔로잉",
          style: kBody16MediumStyle,
        ),
        Text(
          "내 피드",
          style: kBody16MediumStyle,
        ),
      ]);
    }

    return tabs;
  }

  List<Widget> getTabSpacer() {
    final loginState = ref.read(loginStateProvider);

    if (loginState == LoginStatus.success) {
      return [const SizedBox.shrink()];
    } else {
      return [
        const Spacer(),
        const Spacer(),
        const Spacer(),
      ];
    }
  }

  void _handleStatusBarTap() {
    scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.linearToEaseOut,
    );
  }

  @override
  void initState() {
    super.initState();

    print('aaaaaaaaaaaaaaaaaaaaa');

    Permissions.requestNotificationPermission();

    tabController = TabController(vsync: this, length: getTabs().length);
    tabController.index = widget.initialTabIndex;

    Future(() async {
      ref.read(followUserStateProvider.notifier).resetState();

      final loginState = ref.watch(loginStateProvider);

      // ref.read(recentFeedStateProvider.notifier).lastPage = 0;
      print('not run????');
      _recentFeedListPagingController.refresh();

      ref.read(popularUserListStateProvider.notifier).getInitUserList();

      ref.read(popularHourFeedStateProvider.notifier).initPosts();

      scrollController.addListener(_myPostScrollListener);

      if (loginState == LoginStatus.success) {
        ///NOTE
        ///2023.11.14.
        ///산책하기 보류로 주석 처리
        // await ref.read(walkStateProvider.notifier).getWalkResultState(ref.read(userInfoProvider).userModel!.uuid);
        ///산책하기 보류로 주석 처리 완료

        _myFeedListPagingController.refresh();

        _popularWeekFeedListPagingController.refresh();

        _followFeedListPagingController.refresh();

        ref.read(favoriteUserListStateProvider.notifier).getInitUserList();
      }

      ///NOTE
      ///2023.11.14.
      ///산책하기 보류로 주석 처리
      // if (ref.read(walkStatusStateProvider) == WalkStatus.walking && !ref.read(isNavigatedFromMapProvider)) {
      //   context.push('/map');
      // } else if (ref.read(walkStatusStateProvider) == WalkStatus.walkEndedWithoutLog) {
      //   toast(
      //     context: context,
      //     text: '',
      //     type: ToastType.white,
      //     toastDuration: Duration(days: 1000),
      //     toastWidget: Row(
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         Row(
      //           children: [
      //             SizedBox(
      //               width: 14,
      //             ),
      //             Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Text(
      //                   "산책이 종료되었습니다.",
      //                   style: kBody13BoldStyle.copyWith(color: kTextSubTitleColor),
      //                 ),
      //                 Padding(
      //                   padding: const EdgeInsets.only(top: 2.0),
      //                   child: Text(
      //                     "'확인' 클릭 시 산책 결과 페이지로 이동합니다.",
      //                     style: kBody11RegularStyle.copyWith(color: kTextSubTitleColor),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ],
      //         ),
      //         InkWell(
      //           onTap: () {
      //             FToast().removeCustomToast();
      //             context.push('/writeWalkLog');
      //           },
      //           child: Container(
      //             decoration: const BoxDecoration(
      //               color: kPrimaryLightColor,
      //               borderRadius: BorderRadius.all(
      //                 Radius.circular(100.0),
      //               ),
      //             ),
      //             child: Padding(
      //               padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10),
      //               child: Text(
      //                 "확인",
      //                 style: kBody11SemiBoldStyle.copyWith(color: kPrimaryColor),
      //               ),
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   );
      // }
      // else if(ref.read(walkStatusStateProvider) == WalkStatus.walkEndedForce) {
      //   toast(
      //     context: context,
      //     text: '',
      //     type: ToastType.white,
      //     toastDuration: Duration(days: 1000),
      //     toastWidget: Row(
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         Row(
      //           children: [
      //             SizedBox(
      //               width: 14,
      //             ),
      //             Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Text(
      //                   "산책이 강제 종료되었습니다.",
      //                   style: kBody13BoldStyle.copyWith(color: kTextSubTitleColor),
      //                 ),
      //                 Padding(
      //                   padding: const EdgeInsets.only(top: 2.0),
      //                   child: Text(
      //                     "'확인' 클릭 시 산책 결과 페이지로 이동합니다.",
      //                     style: kBody11RegularStyle.copyWith(color: kTextSubTitleColor),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ],
      //         ),
      //         InkWell(
      //           onTap: () {
      //             FToast().removeCustomToast();
      //             context.push('/writeWalkLog');
      //           },
      //           child: Container(
      //             decoration: const BoxDecoration(
      //               color: kPrimaryLightColor,
      //               borderRadius: BorderRadius.all(
      //                 Radius.circular(100.0),
      //               ),
      //             ),
      //             child: Padding(
      //               padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10),
      //               child: Text(
      //                 "확인",
      //                 style: kBody11SemiBoldStyle.copyWith(color: kPrimaryColor),
      //               ),
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   );
      // }
      ///산책하기 보류로 주석 처리 완료
    });
  }

  void _myPostScrollListener() {
    setState(() {
      ref.read(loginStatementProvider) == false ? _showIcon = false : _showIcon = scrollController.offset > 100.h;
    });
    if (scrollController.position.userScrollDirection != ScrollDirection.idle) {
      setState(() {
        _isWidgetVisible = false;
      });
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_myPostScrollListener);
    scrollController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isBigDevice = MediaQuery.of(context).size.width >= 345;
    final loginState = ref.watch(loginStateProvider);

    return WillPopScope(
      onWillPop: () async {
        bool backResult = onBackPressed();
        return await Future.value(backResult);
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: isBigDevice
                ? null
                : PreferredSize(
                    preferredSize: const Size.fromHeight(30.0),
                    child: AppBar(
                      automaticallyImplyLeading: false,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'assets/image/logo/logo.png',
                            width: 107,
                            height: 39,
                          ),
                          _buttonWidget(),
                        ],
                      ),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                  ),
            body: SafeArea(
              child: Consumer(builder: (context, ref, _) {
                return DefaultTabController(
                  length: loginState == LoginStatus.success ? 4 : 2,
                  child: NestedScrollView(
                    controller: scrollController,
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        isBigDevice
                            ? SliverAppBar(
                                pinned: true,
                                snap: false,
                                floating: true,
                                expandedHeight: 200.0,
                                centerTitle: false,
                                leading: null,
                                titleSpacing: 0,
                                backgroundColor: kPreviousNeutralColor100,
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
                                    color: kPreviousNeutralColor100,
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 12,
                                            left: 16,
                                          ),
                                          child: Image.asset(
                                            'assets/image/logo/logo.png',
                                            width: 107,
                                            height: 39,
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
                                expandedHeight: 160.0,
                                centerTitle: false,
                                leading: null,
                                titleSpacing: 0,
                                backgroundColor: kPreviousNeutralColor100,
                                automaticallyImplyLeading: false,
                                flexibleSpace: FlexibleSpaceBar(
                                  titlePadding: EdgeInsets.zero,
                                  expandedTitleScale: 1.0,
                                  centerTitle: false,
                                  collapseMode: CollapseMode.pin,
                                  title: _buildTabbar(innerBoxIsScrolled),
                                  background: Container(
                                    color: kPreviousNeutralColor100,
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
                    body: InkWell(
                      onTap: () {
                        setState(() {
                          _isWidgetVisible = false;
                        });
                      },
                      child: Stack(
                        children: [
                          TabBarView(
                            controller: tabController,
                            children: [
                              _firstTab(),
                              // Container(
                              //   color: Colors.blue,
                              // ),

                              if (loginState == LoginStatus.success) ...[
                                _thirdTab(),
                              ],
                              if (loginState == LoginStatus.success) ...[
                                _fourthTab(),
                              ],
                            ],
                          ),

                          ///NOTE
                          ///2023.11.14.
                          ///산책하기 보류로 주석 처리
                          // Visibility(
                          //   visible: _isWidgetVisible && ref.read(walkStatusStateProvider) == WalkStatus.walking,
                          //   child: Positioned.fill(
                          //     bottom: 10,
                          //     child: Align(
                          //       alignment: Alignment.bottomCenter,
                          //       child: Padding(
                          //         padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 24.0),
                          //         child: WalkInfoWidget(
                          //           walkStateModel: ref.watch(singleWalkStateProvider).isEmpty ? null : ref.watch(singleWalkStateProvider).last,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // )
                          ///산책하기 보류로 주석 처리 완료
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),

            ///NOTE
            ///2023.11.14.
            ///산책하기 보류로 주석 처리
            // floatingActionButton: Consumer(builder: (context, ref, _) {
            //   return !_isWidgetVisible && ref.read(walkStatusStateProvider) == WalkStatus.walking
            //       ? FloatingActionButton(
            //           backgroundColor: kNeutralColor100,
            //           child: Lottie.asset(
            //             'assets/lottie/character_03_walking_floating.json',
            //             repeat: true,
            //           ),
            //           onPressed: () {
            //             setState(() {
            //               _isWidgetVisible = true;
            //             });
            //           },
            //         )
            //       : Container();
            // }),
            ///산책하기 보류로 주석 처리 완료
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).padding.top,
            child: GestureDetector(
              excludeFromSemantics: true,
              onTap: _handleStatusBarTap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonWidget() {
    final myInfo = ref.watch(myInfoStateProvider);
    final isLogined = ref.watch(loginStatementProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () async {
            ///NOTE
            ///2023.11.14.
            ///산책하기 보류로 주석 처리
            // if (ref.read(userInfoProvider).userModel != null && !(ref.read(walkStatusStateProvider) == WalkStatus.walking)) {
            //   await ref.watch(restrainWriteStateProvider.notifier).getWriteRestrain(ref.read(userInfoProvider).userModel!.idx);
            // }
            ///TODO
            ///제재 상태 체크
            ///로직 변경으로 수정 필요
            // if (!isLogined) {
            //   await ref.watch(restrainWriteStateProvider.notifier).getWriteRestrain(ref.read(userInfoProvider).userModel!.idx);
            // }

            ///위 코드로 변경
            ///산책하기 보류로 주석 처리 완료

            if (!isLogined) {
              if (mounted) {
                context.pushReplacement("/loginScreen");
              }
            }

            ///NOTE
            ///2023.11.14.
            ///산책하기 보류로 주석 처리
            // else if (ref.read(walkStatusStateProvider) == WalkStatus.walking) {
            //   return;
            // }
            ///산책하기 보류로 주석 처리 완료
            // else if (ref.watch(restrainWriteStateProvider).restrain.state == null) {
            else {
              final theme = InstaAssetPicker.themeData(Theme.of(context).primaryColor);

              final ImagePicker picker = ImagePicker();

              final pickedFile = await picker.pickImage(source: ImageSource.camera);

              if (pickedFile != null) {
                await ImageGallerySaver.saveFile(pickedFile.path);

                // ignore: use_build_context_synchronously
                InstaAssetPicker.pickAssets(
                  context,
                  maxAssets: 12,
                  // ignore: use_build_context_synchronously
                  pickerTheme: themeData(context).copyWith(
                    canvasColor: kPreviousNeutralColor100,
                    colorScheme: theme.colorScheme.copyWith(
                      background: kPreviousNeutralColor100,
                    ),
                    appBarTheme: theme.appBarTheme.copyWith(
                      backgroundColor: kPreviousNeutralColor100,
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
            }
            // else {
            //   showDialog(
            //     barrierDismissible: false,
            //     context: context,
            //     builder: (context) => RestrictionDialog(
            //       isForever: false,
            //       date: ref.watch(restrainWriteStateProvider).restrain.date,
            //       restrainName: ref.watch(restrainWriteStateProvider).restrain.restrainName,
            //       startDate: ref.watch(restrainWriteStateProvider).restrain.startDate,
            //       endDate: ref.watch(restrainWriteStateProvider).restrain.endDate,
            //     ),
            //   );
            // }
          },
          child: Consumer(builder: (context, ref, _) {
            return const Icon(
              Puppycat_social.icon_camera,

              ///NOTE
              ///2023.11.14.
              ///산책하기 보류로 주석 처리
              // color: ref.watch(walkStatusStateProvider) == WalkStatus.walking ? kTextBodyColor : kNeutralColor600,
              ///산책하기 보류로 주석 처리 완료
              color: kPreviousNeutralColor600,

              ///주석 대신 위 코드로 변경
              ///const도 추가
              size: 40,
            );
          }),
        ),
        GestureDetector(
          onTap: () async {
            ///NOTE
            ///2023.11.14.
            ///산책하기 보류로 주석 처리
            // if (ref.read(userInfoProvider).userModel != null && !(ref.read(walkStatusStateProvider) == WalkStatus.walking)) {
            //   await ref.watch(restrainWriteStateProvider.notifier).getWriteRestrain(ref.read(userInfoProvider).userModel!.idx);
            // }
            ///
            // if (ref.read(userInfoProvider).userModel != null) {
            //   await ref.watch(restrainWriteStateProvider.notifier).getWriteRestrain(ref.read(userInfoProvider).userModel!.idx);
            // }
            //
            // ///위 코드로 변경
            // ///산책하기 보류로 주석 처리 완료
            // if (mounted) {
            //   ref.read(userInfoProvider).userModel == null
            //       ? context.pushReplacement("/loginScreen")
            //
            //       ///NOTE
            //       ///2023.11.14.
            //       ///산책하기 보류로 주석 처리
            //       //     : ref.read(walkStatusStateProvider) == WalkStatus.walking
            //       //         ? null
            //       //         : ref.watch(restrainWriteStateProvider).restrain.state == null
            //       ///
            //       : ref.watch(restrainWriteStateProvider).restrain.state == null
            //
            //           ///위 코드로 변경
            //           ///산책하기 보류로 주석 처리 완료
            //           ? feedWriteShowBottomSheet(
            //               context: context,
            //               onClose: () {
            //                 setState(() {
            //                   showLottieAnimation = false;
            //                 });
            //               },
            //             )
            //           : showDialog(
            //               barrierDismissible: false,
            //               context: context,
            //               builder: (context) => RestrictionDialog(
            //                 isForever: false,
            //                 date: ref.watch(restrainWriteStateProvider).restrain.date,
            //                 restrainName: ref.watch(restrainWriteStateProvider).restrain.restrainName,
            //                 startDate: ref.watch(restrainWriteStateProvider).restrain.startDate,
            //                 endDate: ref.watch(restrainWriteStateProvider).restrain.endDate,
            //               ),
            //             );
            // }
            ///TODO
            ///제재 상태 체크
            ///로직 변경으로 수정 필요
            // if (ref.read(userInfoProvider).userModel != null) {
            //   await ref.watch(restrainWriteStateProvider.notifier).getWriteRestrain(ref.read(userInfoProvider).userModel!.idx);
            // }

            if (mounted) {
              if (!isLogined) {
                context.pushReplacement("/loginScreen");
                // } else if (ref.watch(restrainWriteStateProvider).restrain.state == null) {
              } else {
                final restrain = await ref.read(restrainStateProvider.notifier).checkRestrainStatus(RestrainCheckType.writeFeed);

                if (restrain) {
                  final theme = InstaAssetPicker.themeData(Theme.of(context).primaryColor);

                  InstaAssetPicker.pickAssets(
                    context,
                    maxAssets: 12,
                    pickerTheme: themeData(context).copyWith(
                      canvasColor: kPreviousNeutralColor100,
                      colorScheme: theme.colorScheme.copyWith(
                        background: kPreviousNeutralColor100,
                      ),
                      appBarTheme: theme.appBarTheme.copyWith(
                        backgroundColor: kPreviousNeutralColor100,
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
              }
              // else {
              //   showDialog(
              //     barrierDismissible: false,
              //     context: context,
              //     builder: (context) => RestrictionDialog(
              //       isForever: false,
              //       date: ref.watch(restrainWriteStateProvider).restrain.date,
              //       restrainName: ref.watch(restrainWriteStateProvider).restrain.restrainName,
              //       startDate: ref.watch(restrainWriteStateProvider).restrain.startDate,
              //       endDate: ref.watch(restrainWriteStateProvider).restrain.endDate,
              //     ),
              //   );
              // }
            }
            // setState(() {
            //   showLottieAnimation = true;
            // });
          },
          child:
              // showLottieAnimation
              //     ? Lottie.asset(
              //         'assets/lottie/icon_feed.json',
              //         repeat: false,
              //       )
              //     :
              Consumer(builder: (context, ref, _) {
            return const Icon(
              Puppycat_social.icon_feed,

              ///NOTE
              ///2023.11.14.
              ///산책하기 보류로 주석 처리
              // color: ref.watch(walkStatusStateProvider) == WalkStatus.walking ? kTextBodyColor : kNeutralColor600,
              ///
              color: kPreviousNeutralColor600,

              ///위 코드로 변경
              ///const 추가
              ///산책하기 보류로 주석 처리 완료
              size: 40,
            );
          }),
        ),
        const PopupMenuWithReddot(),
        GestureDetector(
          onTap: () {
            context.go("/home/myPage");
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _showIcon ? 36.0 : 0.0,
            child: Opacity(
              opacity: _showIcon ? 1.0 : 0.0,
              child: myInfo.profileImgUrl == null || myInfo.profileImgUrl!.isEmpty
                  ? WidgetMask(
                      blendMode: BlendMode.srcATop,
                      childSaveLayer: true,
                      mask: const Center(
                        child: Icon(
                          Puppycat_social.icon_profile_small,
                          size: 22,
                          color: kPreviousNeutralColor400,
                        ),
                      ),
                      child: SvgPicture.asset(
                        'assets/image/feed/image/squircle.svg',
                        height: 22.h,
                      ),
                    )
                  : WidgetMask(
                      blendMode: BlendMode.srcATop,
                      childSaveLayer: true,
                      mask: Center(
                        child: Image.network(
                          Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("${myInfo.profileImgUrl}").toUrl(),
                          height: 22.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
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
    final myInfo = ref.read(myInfoStateProvider);
    final isLogined = ref.read(loginStatementProvider);

    return RefreshIndicator(
      onRefresh: () {
        return Future(() {
          ref.read(followUserStateProvider.notifier).resetState();

          final loginState = ref.watch(loginStateProvider);

          _recentFeedListPagingController.refresh();

          ref.read(popularUserListStateProvider.notifier).getInitUserList();

          ref.read(popularHourFeedStateProvider.notifier).initPosts();

          scrollController.addListener(_myPostScrollListener);

          if (loginState == LoginStatus.success) {
            _myFeedListPagingController.refresh();

            _popularWeekFeedListPagingController.refresh();

            _followFeedListPagingController.refresh();

            ref.read(favoriteUserListStateProvider.notifier).getInitUserList();
          }
        });
      },
      child: CustomScrollView(
        slivers: <Widget>[
          PagedSliverList<int, FeedData>(
            // shrinkWrap: true,
            shrinkWrapFirstPageIndicators: true,
            pagingController: _recentFeedListPagingController,
            builderDelegate: PagedChildBuilderDelegate<FeedData>(
              newPageProgressIndicatorBuilder: (context) {
                return Column(
                  children: [
                    Lottie.asset(
                      'assets/lottie/icon_loading.json',
                      fit: BoxFit.fill,
                      width: 80,
                      height: 80,
                    ),
                  ],
                );
              },
              firstPageProgressIndicatorBuilder: (context) {
                return Column(
                  children: [
                    Lottie.asset(
                      'assets/lottie/icon_loading.json',
                      fit: BoxFit.fill,
                      width: 80,
                      height: 80,
                    ),
                  ],
                );
              },
              noItemsFoundIndicatorBuilder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 100.0),
                      child: Column(
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
                            '피드가 없어요.',
                            textAlign: TextAlign.center,
                            style: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor, height: 1.4, letterSpacing: 0.2),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              itemBuilder: (context, item, index) {
                return FeedMainWidget(
                  feedData: item,
                  contentType: 'userContent',
                  userName: item.memberInfo?.nick ?? '',
                  profileImage: item.memberInfo?.profileImgUrl ?? "",
                  oldMemberUuid: myInfo.uuid ?? '',
                  firstTitle: item.memberInfo?.nick ?? 'unknown',
                  secondTitle: '피드',
                  // imageDomain: ref.read(recentFeedStateProvider.notifier).imgDomain!,
                  index: index,
                  feedType: 'recent',
                  isSpecialUser: item.memberInfo?.isBadge == 1,
                  onTapHideButton: () async {
                    onTapHide(
                      context: context,
                      ref: ref,
                      contentType: 'userContent',
                      contentIdx: item.idx,
                      memberUuid: item.memberUuid ?? '',
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _thirdTab() {
    final myInfo = ref.read(myInfoStateProvider);
    final isLogined = ref.read(loginStatementProvider);

    return RefreshIndicator(
      onRefresh: () {
        return Future(() {
          ref.read(followUserStateProvider.notifier).resetState();

          final loginState = ref.watch(loginStateProvider);
          print('aaaaaaaaaaaaaaaaaaaaa44444');

          _recentFeedListPagingController.refresh();

          ref.read(popularUserListStateProvider.notifier).getInitUserList();

          ref.read(popularHourFeedStateProvider.notifier).initPosts();

          scrollController.addListener(_myPostScrollListener);

          if (loginState == LoginStatus.success) {
            _myFeedListPagingController.refresh();

            _popularWeekFeedListPagingController.refresh();

            _followFeedListPagingController.refresh();

            ref.read(favoriteUserListStateProvider.notifier).getInitUserList();
          }
        });
      },
      child: CustomScrollView(
        slivers: <Widget>[
          PagedSliverList<int, FeedData>(
            shrinkWrapFirstPageIndicators: true,
            pagingController: _followFeedListPagingController,
            builderDelegate: PagedChildBuilderDelegate<FeedData>(
              noItemsFoundIndicatorBuilder: (context) {
                return const SizedBox.shrink();
              },
              newPageProgressIndicatorBuilder: (context) {
                return Container();
              },
              firstPageProgressIndicatorBuilder: (context) {
                return Column(
                  children: [
                    Lottie.asset(
                      'assets/lottie/icon_loading.json',
                      fit: BoxFit.fill,
                      width: 80,
                      height: 80,
                    ),
                  ],
                );
              },
              itemBuilder: (context, item, index) {
                return FeedMainWidget(
                  feedData: item,
                  contentType: 'userContent',
                  userName: ref.read(followFeedStateProvider.notifier).memberInfo?.nick ?? item.memberInfo!.nick!,
                  profileImage: ref.read(followFeedStateProvider.notifier).memberInfo?.profileImgUrl ?? item.memberInfo!.profileImgUrl! ?? "",
                  oldMemberUuid: myInfo.uuid ?? '',
                  firstTitle: ref.read(followFeedStateProvider.notifier).memberInfo?.nick ?? item.memberInfo!.nick!,
                  secondTitle: '피드',
                  index: index,
                  feedType: 'follow',
                  isSpecialUser: ref.read(followFeedStateProvider.notifier).memberInfo?.isBadge == 1,
                  onTapHideButton: () async {
                    onTapHide(
                      context: context,
                      ref: ref,
                      contentType: 'userContent',
                      contentIdx: item.idx,
                      memberUuid: item.memberUuid!,
                    );
                  },
                );
              },
            ),
          ),
          PagedSliverList<int, FeedData>(
            shrinkWrapFirstPageIndicators: true,
            pagingController: _popularWeekFeedListPagingController,
            builderDelegate: PagedChildBuilderDelegate<FeedData>(
              noItemsFoundIndicatorBuilder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 100.0),
                      child: Column(
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
                            '피드가 없어요.',
                            textAlign: TextAlign.center,
                            style: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor, height: 1.4, letterSpacing: 0.2),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              newPageProgressIndicatorBuilder: (context) {
                return Column(
                  children: [
                    Lottie.asset(
                      'assets/lottie/icon_loading.json',
                      fit: BoxFit.fill,
                      width: 80,
                      height: 80,
                    ),
                  ],
                );
              },
              firstPageProgressIndicatorBuilder: (context) {
                return Container();
              },
              itemBuilder: (context, item, index) {
                return FeedMainWidget(
                  feedData: item,
                  // contentType: 'popularWeekContent',
                  contentType: 'userContent',
                  userName: item.memberInfo!.nick!,
                  profileImage: item.memberInfo!.profileImgUrl! ?? "",
                  oldMemberUuid: myInfo.uuid ?? '',
                  // firstTitle: "null",
                  firstTitle: ref.read(followFeedStateProvider.notifier).memberInfo?.nick ?? item.memberInfo!.nick!,
                  // secondTitle: '인기 급상승',
                  secondTitle: '피드',
                  index: index,
                  feedType: 'popular',
                  isSpecialUser: item.memberInfo?.isBadge == 1,
                  onTapHideButton: () async {
                    onTapHide(
                      context: context,
                      ref: ref,
                      contentType: 'userContent',
                      contentIdx: item.idx,
                      memberUuid: item.memberUuid!,
                    );
                  },
                  // feedType: 'follow',
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _fourthTab() {
    final myInfo = ref.read(myInfoStateProvider);
    final isLogined = ref.read(loginStatementProvider);

    return RefreshIndicator(
      onRefresh: () {
        return Future(() {
          ref.read(followUserStateProvider.notifier).resetState();

          final loginState = ref.watch(loginStateProvider);
          print('aaaaaaaaaaaaaaaaaaaaa 5555');

          _recentFeedListPagingController.refresh();

          ref.read(popularUserListStateProvider.notifier).getInitUserList();

          ref.read(popularHourFeedStateProvider.notifier).initPosts();

          scrollController.addListener(_myPostScrollListener);

          if (loginState == LoginStatus.success) {
            _myFeedListPagingController.refresh();

            _popularWeekFeedListPagingController.refresh();

            _followFeedListPagingController.refresh();

            ref.read(favoriteUserListStateProvider.notifier).getInitUserList();
          }
        });
      },
      child: CustomScrollView(
        slivers: <Widget>[
          PagedSliverList<int, FeedData>(
            shrinkWrapFirstPageIndicators: true,
            pagingController: _myFeedListPagingController,
            builderDelegate: PagedChildBuilderDelegate<FeedData>(
              noItemsFoundIndicatorBuilder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 100.0),
                      child: Column(
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
                            '피드가 없어요.\n피드를 올려 볼까요?',
                            textAlign: TextAlign.center,
                            style: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor, height: 1.4, letterSpacing: 0.2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: 320,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              !isLogined
                                  ? context.pushReplacement("/loginScreen")
                                  : InstaAssetPicker.pickAssets(
                                      context,
                                      maxAssets: 12,
                                      pickerTheme: themeData(context).copyWith(
                                        canvasColor: kPreviousNeutralColor100,
                                        colorScheme: InstaAssetPicker.themeData(Theme.of(context).primaryColor).colorScheme.copyWith(
                                              background: kPreviousNeutralColor100,
                                            ),
                                        appBarTheme: InstaAssetPicker.themeData(Theme.of(context).primaryColor).appBarTheme.copyWith(
                                              backgroundColor: kPreviousNeutralColor100,
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
                              // : showDialog(
                              //     barrierDismissible: false,
                              //     context: context,
                              //     builder: (context) => RestrictionDialog(
                              //       isForever: false,
                              //       date: ref.watch(restrainWriteStateProvider).restrain.date,
                              //       restrainName: ref.watch(restrainWriteStateProvider).restrain.restrainName,
                              //       startDate: ref.watch(restrainWriteStateProvider).restrain.startDate,
                              //       endDate: ref.watch(restrainWriteStateProvider).restrain.endDate,
                              //     ),
                              //   );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPreviousPrimaryColor,
                              disabledBackgroundColor: kPreviousNeutralColor400,
                              disabledForegroundColor: kPreviousTextBodyColor,
                              elevation: 0,
                            ),
                            child: Text(
                              '피드 올리기',
                              style: kButton14MediumStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              newPageProgressIndicatorBuilder: (context) {
                return Column(
                  children: [
                    Lottie.asset(
                      'assets/lottie/icon_loading.json',
                      fit: BoxFit.fill,
                      width: 80,
                      height: 80,
                    ),
                  ],
                );
              },
              firstPageProgressIndicatorBuilder: (context) {
                return Column(
                  children: [
                    Lottie.asset(
                      'assets/lottie/icon_loading.json',
                      fit: BoxFit.fill,
                      width: 80,
                      height: 80,
                    ),
                  ],
                );
              },
              itemBuilder: (context, item, index) {
                return FeedMainWidget(
                  feedData: item,
                  contentType: 'myContent',
                  userName: ref.read(myFeedStateProvider.notifier).memberInfo!.nick!,
                  profileImage: ref.read(myFeedStateProvider.notifier).memberInfo!.profileImgUrl ?? "",
                  oldMemberUuid: myInfo.uuid ?? '',
                  firstTitle: ref.read(myFeedStateProvider.notifier).memberInfo!.nick!,
                  secondTitle: '피드',
                  index: index,
                  feedType: 'my',
                  isSpecialUser: ref.read(myFeedStateProvider.notifier).memberInfo!.isBadge == 1,
                  onTapHideButton: () async {
                    onTapHide(
                      context: context,
                      ref: ref,
                      contentType: 'myContent',
                      contentIdx: item.idx,
                      memberUuid: item.memberUuid!,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackGround() {
    bool isBigDevice = MediaQuery.of(context).size.width >= 345;

    // final loginState = ref.watch(loginStateProvider);
    final myInfo = ref.read(myInfoStateProvider);
    final isLogined = ref.watch(loginStatementProvider);

    return isLogined
        ? Padding(
            padding: EdgeInsets.only(
              top: isBigDevice ? 50 : 5,
            ),
            child: Consumer(builder: (context, ref, child) {
              final userListState = ref.watch(favoriteUserListStateProvider);
              final userListLists = userListState.memberList;

              return Row(
                children: [
                  Padding(
                    key: ValueKey(myInfo.profileImgUrl),
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        context.go("/home/myPage");
                      },
                      child: Column(
                        children: [
                          // buildWidgetMask(myInfo.profileImgUrl ?? "", myInfo.isBadge, null),
                          getProfileAvatarWithBadge(myInfo.profileImgUrl ?? '', myInfo.isBadge == 1, 54, 54),
                          const SizedBox(height: 4.0),
                          Text(
                            "my",
                            style: kBody12RegularStyle.copyWith(color: kPreviousTextTitleColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: userListLists.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              myInfo.uuid == userListLists[index].uuid
                                  ? context.push("/home/myPage")
                                  : context
                                      .push("/home/myPage/followList/${userListLists[index].uuid}/userPage/${userListLists[index].nick}/${userListLists[index].uuid}/${userListLists[index].uuid}");
                            },
                            child: Column(
                              children: [
                                // buildWidgetMask(userListLists[index].profileImgUrl, userListLists[index].isBadge, userListLists[index].redDotState),
                                getProfileAvatarWithBadge(myInfo.profileImgUrl ?? '', myInfo.isBadge == 1, 54, 54),
                                const SizedBox(height: 4.0),
                                Stack(
                                  children: [
                                    userListLists[index].redDotState == 1
                                        ? const Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Icon(
                                              Icons.circle,
                                              color: Colors.red,
                                              size: 6,
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                    SizedBox(
                                      width: 60,
                                      child: Text(
                                        userListLists[index].nick!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: kBody12RegularStyle.copyWith(color: kPreviousTextTitleColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
          )
        : Center(
            child: GestureDetector(
              onTap: () {
                context.pushReplacement("/loginScreen");
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/image/character/character_01_not_loginpage.png',
                    width: 56,
                    height: 56,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    "로그인하고 일상 공유하기",
                    style: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor),
                  ),
                ],
              ),
            ),
          );
  }

  // Widget buildWidgetMask(String? profileImgUrl, int? isBadge, int? isRedDot) {
  //   return Stack(
  //     children: [
  //       WidgetMask(
  //         blendMode: BlendMode.srcATop,
  //         childSaveLayer: true,
  //         mask: Center(
  //           child: Image.network(
  //             Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("$profileImgUrl").toUrl(),
  //             height: 46,
  //             fit: BoxFit.cover,
  //             width: double.infinity,
  //             errorBuilder: (context, exception, stackTrace) {
  //               return const Icon(
  //                 Puppycat_social.icon_profile_small,
  //                 size: 46,
  //                 color: kPreviousNeutralColor400,
  //               );
  //             },
  //           ),
  //         ),
  //         child: SvgPicture.asset(
  //           'assets/image/feed/image/squircle.svg',
  //           height: 46,
  //           fit: BoxFit.fill,
  //         ),
  //       ),
  //       isBadge == 1
  //           ? Positioned(
  //               right: 0,
  //               top: 0,
  //               child: Image.asset(
  //                 'assets/image/feed/icon/small_size/icon_special.png',
  //                 height: 13,
  //               ),
  //             )
  //           : Container(),
  //     ],
  //   );
  // }

  Widget _buildTabbar(bool innerBoxIsScrolled) {
    bool isBigDevice = MediaQuery.of(context).size.width >= 345;

    return Container(
      decoration: innerBoxIsScrolled
          ? const BoxDecoration(
              color: Colors.white,
            )
          : const BoxDecoration(
              color: kWhiteColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x0A000000),
                  offset: Offset(0, -6),
                  blurRadius: 10.0,
                ),
              ],
            ),
      child: Row(
        children: [
          Flexible(
            flex: isBigDevice ? 1 : 2,
            child: TabBar(
              controller: tabController,
              indicatorWeight: 2.4,
              labelColor: kPreviousNeutralColor600,
              indicatorColor: kPreviousNeutralColor600,
              unselectedLabelColor: kPreviousNeutralColor500,
              indicatorSize: TabBarIndicatorSize.label,
              labelPadding: EdgeInsets.only(
                top: 10.h,
                bottom: 6.h,
              ),
              tabs: getTabs(),
            ),
          ),
          const Spacer(),
          ...getTabSpacer(),
        ],
      ),
    );
  }
}
