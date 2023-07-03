import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pet_mobile_social_flutter/components/toast/toast.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/ui/notification/component/notification_comment_item.dart';
import 'package:pet_mobile_social_flutter/ui/notification/component/notification_follow_item.dart';
import 'package:pet_mobile_social_flutter/ui/notification/component/notification_notice_item.dart';
import 'package:pet_mobile_social_flutter/ui/notification/component/notification_post_item.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends ConsumerState<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 4,
      vsync: this,
    );
  }

  void onTap() {
    setState(() {
      testValue = !testValue;
    });
  }

  bool testValue = false;

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
              "알림함",
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kNeutralColor300,
                  ),
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 14.0.h, horizontal: 14.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "혜택 알림이 꺼져 있어요.",
                              style: kBody11RegularStyle.copyWith(
                                  color: kTextSubTitleColor),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              "프로모션 및 이벤트 혜택 정보를 받으려면 ON!",
                              style: kBody11RegularStyle.copyWith(
                                  color: kTextSubTitleColor),
                            ),
                          ],
                        ),
                        FlutterSwitch(
                          padding: 4,
                          width: 34.w,
                          height: 16.h,
                          activeColor: Theme.of(context).primaryColor,
                          inactiveColor: kNeutralColor500,
                          toggleSize: 12.0.w,
                          value: testValue,
                          borderRadius: 50.0.w,
                          onToggle: (value) async {
                            if (value) {
                              toast(
                                  context: context,
                                  text: '광고성 정보 수신 여부가 ‘동의’로 변경되었습니다.',
                                  type: ToastType.purple,
                                  secondText:
                                      "수신 동의일: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}");
                            } else {
                              toast(
                                  context: context,
                                  text: '광고성 정보 수신 여부가 ‘거부’로 변경되었습니다.',
                                  type: ToastType.grey,
                                  secondText:
                                      "수신 동의일: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}");
                            }

                            onTap();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              TabBar(
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
                      "전체",
                      style: kBody14BoldStyle,
                    ),
                    Text(
                      "활동",
                      style: kBody14BoldStyle,
                    ),
                    Text(
                      "산책",
                      style: kBody14BoldStyle,
                    ),
                    Text(
                      "공지/이벤트",
                      style: kBody14BoldStyle,
                    ),
                  ]),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    Stack(
                      children: [
                        ListView(
                          padding: const EdgeInsets.only(bottom: 100),
                          children: [
                            NotificationNoticeItem(
                              content: "안녕하세요. 포레스트 담당자입니다. 메뉴 개편 안내드립니다.",
                              time: DateTime.now(),
                              isRead: false,
                            ),
                            NotificationFollowItem(
                              name: "일이삼사오육칠팔구십일이삼사",
                              time: DateTime.now(),
                              isRead: true,
                            ),
                            NotificationCommentItem(
                              name: '일이삼사오육칠팔구십일이삼사',
                              time: DateTime.now(),
                              isRead: true,
                              notificationType: '좋아요',
                              content: '님이 내댓글을 좋아합니다.',
                              comment: '댓글 내용은 1줄만 보여주고 말줄임 처리..',
                            ),
                            NotificationPostItem(
                              name: '일이삼사오육칠팔구십일이삼사',
                              time: DateTime.now(),
                              isRead: true,
                              notificationType: '좋아요',
                              content: '님이 내게시물을 좋아합니다.',
                            ),
                            NotificationCommentItem(
                              name: '일이삼사오육칠팔구십일이삼사',
                              time: DateTime.now(),
                              isRead: true,
                              notificationType: '멘션',
                              content: '님이 내댓글을 좋아합니다.',
                              comment: '@dhkdxlwm_dhkddhkd 여기에 같이 출근을 했거든',
                            ),
                            NotificationPostItem(
                              name: '일이삼사오육칠팔구십일이삼사',
                              time: DateTime.now(),
                              isRead: true,
                              notificationType: '멘션',
                              content: '님이 내게시물에서 나를 멘션했습니다.',
                            ),
                            NotificationPostItem(
                              name: '일이삼사오육칠팔구십일이삼사',
                              time: DateTime.now(),
                              isRead: true,
                              notificationType: '태그',
                              content: '님이 내게시물에서 나를 태그했습니다.',
                            ),
                            NotificationPostItem(
                              name: '일이삼사오육칠팔구십일이삼사',
                              time: DateTime.now(),
                              isRead: true,
                              notificationType: '새 글',
                              content: '님이 새 게시물을 올렸습니다.',
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: kNeutralColor100,
                            height: 70,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(16.w, 0, 16.w, 10.h),
                                  child: const Divider(),
                                ),
                                Text(
                                  "최근 30일 간의 알림만 확인할 수 있습니다.",
                                  style: kBody12SemiBoldStyle.copyWith(
                                      color: kTextBodyColor),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 6.0.h),
                                  child: Text(
                                    "수신 거부 : 마이페이지 → 설정 → 알림",
                                    style: kBody11RegularStyle.copyWith(
                                        color: kTextBodyColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        ListView(
                          children: const [
                            Text("DSA"),
                            Text("DSA"),
                            Text("DSA"),
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: SizedBox(
                            height: 80,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.0.w, vertical: 10.h),
                                  child: const Divider(),
                                ),
                                Text(
                                  "최근 30일 간의 알림만 확인할 수 있습니다.",
                                  style: kBody12SemiBoldStyle.copyWith(
                                      color: kTextBodyColor),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 6.0.h),
                                  child: Text(
                                    "수신 거부 : 마이페이지 → 설정 → 알림",
                                    style: kBody11RegularStyle.copyWith(
                                        color: kTextBodyColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        ListView(
                          children: const [
                            Text("DSA"),
                            Text("DSA"),
                            Text("DSA"),
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: SizedBox(
                            height: 80,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.0.w, vertical: 10.h),
                                  child: const Divider(),
                                ),
                                Text(
                                  "최근 30일 간의 알림만 확인할 수 있습니다.",
                                  style: kBody12SemiBoldStyle.copyWith(
                                      color: kTextBodyColor),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 6.0.h),
                                  child: Text(
                                    "수신 거부 : 마이페이지 → 설정 → 알림",
                                    style: kBody11RegularStyle.copyWith(
                                        color: kTextBodyColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        ListView(
                          children: const [
                            Text("DSA"),
                            Text("DSA"),
                            Text("DSA"),
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: SizedBox(
                            height: 80,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.0.w, vertical: 10.h),
                                  child: const Divider(),
                                ),
                                Text(
                                  "최근 30일 간의 알림만 확인할 수 있습니다.",
                                  style: kBody12SemiBoldStyle.copyWith(
                                      color: kTextBodyColor),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 6.0.h),
                                  child: Text(
                                    "수신 거부 : 마이페이지 → 설정 → 알림",
                                    style: kBody11RegularStyle.copyWith(
                                        color: kTextBodyColor),
                                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}
