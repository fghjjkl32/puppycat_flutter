import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:go_router/go_router.dart';
import 'package:group_button/group_button.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/components/toast/toast.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/controller/permission/permissions.dart';
import 'package:pet_mobile_social_flutter/models/notification/notification_list_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/feed_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/first_feed_detail_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/follow/follow_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/setting/notice_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/setting/setting_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/notification/notification_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/notification/component/notification_comment_item.dart';
import 'package:pet_mobile_social_flutter/ui/notification/component/notification_follow_item.dart';
import 'package:pet_mobile_social_flutter/ui/notification/component/notification_notice_item.dart';
import 'package:pet_mobile_social_flutter/ui/notification/component/notification_post_item.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends ConsumerState<NotificationScreen> with SingleTickerProviderStateMixin {
  late PagingController<int, NotificationListItemModel> _notiListPagingController;
  final GroupButtonController _tapButtonController = GroupButtonController();

  @override
  void initState() {
    _notiListPagingController = ref.read(notificationListStateProvider);
    _tapButtonController.selectIndex(0);
    Future(() {
      ref.read(settingStateProvider.notifier).initSetting();
    });

    super.initState();

    _notiListPagingController.refresh();
  }

  Future<void> _onTap(String key, bool value) async {
    int newValue = value ? 1 : 0;

    ref.read(settingStateProvider.notifier).updateSwitchState(key, newValue);

    Map<String, dynamic> data = {};

    Map<String, int> newSwitchState = Map.from(ref.watch(settingStateProvider).switchState);

    data.addAll(newSwitchState);

    await ref.read(settingStateProvider.notifier).putSetting(
          body: data,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(notificationFirstVisitProvider, (previous, next) {
      if (next) {
        Permissions.requestNotificationPermission();
      }
    });

    final switchState = ref.watch(settingStateProvider).switchState;

    final myInfo = ref.read(myInfoStateProvider);
    final isLogined = ref.read(loginStatementProvider);

    return Material(
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
            icon: const Icon(
              Puppycat_social.icon_back,
              size: 40,
            ),
          ),
        ),
        body: Column(
          children: [
            switchState['main_2'] != 1
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kPreviousNeutralColor300,
                      ),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "필수 혜택 정보를 알려 드릴까요?",
                                  style: kBody11RegularStyle.copyWith(color: kPreviousTextSubTitleColor, height: 1.4, letterSpacing: 0.2),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  "'${myInfo.nick!.length > 8 ? '${myInfo.nick?.substring(0, 8)}...' : myInfo.nick}'님에게 꼭 필요한 정보만 보내 드릴게요.",
                                  style: kBody11RegularStyle.copyWith(color: kPreviousTextSubTitleColor, height: 1.4, letterSpacing: 0.2),
                                ),
                              ],
                            ),
                            FlutterSwitch(
                              padding: 4,
                              width: 38,
                              height: 20,
                              activeColor: Theme.of(context).primaryColor,
                              inactiveColor: kPreviousNeutralColor500,
                              toggleSize: 12.0,
                              value: switchState['main_2'] == 1,
                              borderRadius: 50.0,
                              onToggle: (value) async {
                                if (value) {
                                  toast(context: context, text: '광고성 정보 수신을 ‘동의’했어요.', type: ToastType.purple, secondText: "수신 동의일: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}");
                                } else {
                                  toast(context: context, text: '광고성 정보 수신을 ‘거부’했어요.', type: ToastType.grey, secondText: "수신 거부일: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}");
                                }

                                _onTap('main_2', value);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GroupButton<NotificationType>(
                  isRadio: true,
                  controller: _tapButtonController,
                  options: const GroupButtonOptions(
                    elevation: 0,
                    spacing: 24,
                  ),
                  onSelected: (type, index, isSelected) => ref.read(notificationListStateProvider.notifier).setNotificationType(type),
                  // buttons: ['알림함.전체'.tr(), '알림함.활동'.tr(), '알림함.산책'.tr(), '알림함.공지/이벤트'.tr(),],
                  buttons: const [
                    NotificationType.all,
                    NotificationType.activity,

                    ///NOTE
                    ///2023.11.14.
                    ///산책하기 보류로 주석 처리
                    // NotificationType.walk,
                    ///산책하기 보류로 주석 처리 완료
                    NotificationType.notice,
                  ],
                  buttonBuilder: (selected, type, context) {
                    var itemTitle = '';

                    switch (type) {
                      case NotificationType.all:
                        itemTitle = '알림함.전체'.tr();
                      case NotificationType.activity:
                        itemTitle = '알림함.활동'.tr();

                      ///NOTE
                      ///2023.11.14.
                      ///산책하기 보류로 주석 처리
                      //   case NotificationType.walk:
                      //     itemTitle = '알림함.산책'.tr();
                      ///산책하기 보류로 주석 처리 완료
                      case NotificationType.notice:
                        itemTitle = '알림함.공지/이벤트'.tr();
                    }

                    return Container(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      decoration: selected
                          ? const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                              ),
                            )
                          : const BoxDecoration(),
                      child: Text(
                        itemTitle,
                        style: kButton14BoldStyle.copyWith(
                          color: selected ? kPreviousTextTitleColor : kPreviousNeutralColor500,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: PagedListView<int, NotificationListItemModel>(
                      pagingController: _notiListPagingController,
                      builderDelegate: PagedChildBuilderDelegate<NotificationListItemModel>(
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
                                      '알림이 없어요.',
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
                          if (item.subType == describeEnum(NotiSubType.follow)) {
                            return NotificationFollowItem(
                              name: item.senderInfo?.first.nick ?? 'unknown',
                              regDate: item.regDate,
                              isRead: item.isShow == 1 ? true : false,
                              profileImgUrl: (item.senderInfo?.isNotEmpty ?? false) ? item.senderInfo!.first.profileImgUrl : '',
                              isFollowed: item.followState == 1 ? true : false,
                              onTapFollowButton: (isFollowed) {
                                if (!ref.watch(followApiIsLoadingStateProvider)) {
                                  if (isFollowed) {
                                    ref.read(notificationListStateProvider.notifier).unSetFollow(item.senderUuid);
                                  } else {
                                    ref.read(notificationListStateProvider.notifier).setFollow(item.senderUuid);
                                  }
                                }
                              },
                              onTapProfileButton: () {
                                myInfo.uuid == item.senderUuid
                                    ? context.push("/home/myPage")
                                    : context.push("/home/myPage/followList/${item.senderUuid}/userPage/${item.senderInfo?.first.nick ?? 'unknown'}/${item.senderUuid}/${item.senderUuid}");
                              },
                            );
                          } else if (item.subType == describeEnum(NotiSubType.new_contents) ||
                              item.subType == describeEnum(NotiSubType.mention_contents) ||
                              item.subType == describeEnum(NotiSubType.img_tag) ||
                              item.subType == describeEnum(NotiSubType.like_contents)) {
                            return NotificationPostItem(
                              name: item.senderInfo?.first.nick ?? 'unknown',
                              regDate: item.regDate,
                              isRead: item.isShow == 1 ? true : false,
                              notificationType: item.title,
                              content: item.body,
                              profileImgUrl: (item.senderInfo?.isNotEmpty ?? false) ? item.senderInfo!.first.profileImgUrl : '',
                              imgUrl: item.img ?? '',
                              isLiked: item.contentsLikeState == 1 ? true : false,
                              onTap: () async {
                                ///TODO
                                ///route 정리 필요

                                Map<String, dynamic> extraMap = {
                                  'firstTitle': 'null',
                                  'secondTitle': '피드',
                                  'memberUuid': myInfo.uuid,
                                  'contentIdx': '${item.contentsIdx}',
                                  'contentType': 'notificationContent',
                                };

                                await ref.read(firstFeedDetailStateProvider.notifier).getFirstFeedState('notificationContent', item.contentsIdx).then((value) {
                                  if (value == null) {
                                    return;
                                  }
                                  // context.push("/home/myPage/detail/null/피드/$loginMemberIdx/${item.contentsIdx}/notificationContent");
                                  context.push('/home/myPage/detail', extra: extraMap);
                                });
                              },
                              onLikeTap: (isLiked) {
                                if (!ref.watch(likeApiIsLoadingStateProvider)) {
                                  if (isLiked) {
                                    ref.read(notificationListStateProvider.notifier).unSetFeedLike(item.contentsIdx);
                                  } else {
                                    ref.read(notificationListStateProvider.notifier).setFeedLike(item.contentsIdx);
                                  }
                                }
                              },
                              onCommentTap: () async {
                                ///TODO
                                ///route 정리 필요
                                Map<String, dynamic> extraMap = {
                                  'firstTitle': 'nickname',
                                  'secondTitle': '피드',
                                  'memberUuid': myInfo.uuid,
                                  'contentIdx': '${item.contentsIdx}',
                                  'contentType': 'notificationContent',
                                  'isRouteComment': true,
                                };
                                await ref.read(firstFeedDetailStateProvider.notifier).getFirstFeedState('notificationContent', item.contentsIdx).then((value) {
                                  if (value == null) {
                                    return;
                                  }
                                  // context.push("/home/myPage/detail/nickname/피드/$loginMemberIdx/${item.contentsIdx}/notificationContent", extra: {
                                  //   "isRouteComment": true,
                                  // });
                                  context.push('/home/myPage/detail', extra: extraMap);
                                });
                              },
                              onTapProfileButton: () {
                                myInfo.uuid == item.senderUuid
                                    ? context.push("/home/myPage")
                                    : context.push("/home/myPage/followList/${item.senderUuid}/userPage/${item.senderInfo?.first.nick ?? 'unknown'}/${item.senderUuid}/${item.senderUuid}");
                              },
                            );
                          } else if (item.subType == describeEnum(NotiSubType.new_comment) ||
                              item.subType == describeEnum(NotiSubType.new_reply) ||
                              item.subType == describeEnum(NotiSubType.mention_comment) ||
                              item.subType == describeEnum(NotiSubType.like_comment)) {
                            return NotificationCommentItem(
                              name: item.senderInfo?.first.nick ?? 'unknown',
                              regDate: item.regDate,
                              isRead: item.isShow == 1 ? true : false,
                              notificationType: item.title,
                              content: item.body,
                              comment: item.contents ?? '',
                              mentionList: (item.mentionMemberInfo?.isNotEmpty ?? false) ? item.mentionMemberInfo!.first : {},
                              profileImgUrl: (item.senderInfo?.isNotEmpty ?? false) ? item.senderInfo!.first.profileImgUrl : '',
                              imgUrl: item.img ?? '',
                              onTap: () async {
                                Map<String, dynamic> extraMap = {
                                  'firstTitle': 'nickname',
                                  'secondTitle': '피드',
                                  'memberUuid': myInfo.uuid,
                                  'contentIdx': '${item.contentsIdx}',
                                  'contentType': 'notificationContent',
                                  'isRouteComment': true,
                                  'focusIdx': item.commentIdx,
                                };
                                await ref.read(firstFeedDetailStateProvider.notifier).getFirstFeedState('notificationContent', item.contentsIdx).then((value) {
                                  // context.push("/home/myPage/detail/nickname/피드/$loginMemberIdx/${item.contentsIdx}/notificationContent", extra: {
                                  //   "isRouteComment": true,
                                  //   "focusIdx": item.commentIdx,
                                  // });
                                  if (value == null) {
                                    return;
                                  }
                                  context.push('/home/myPage/detail', extra: extraMap);
                                });
                              },
                              onTapProfileButton: () {
                                myInfo.uuid == item.senderUuid
                                    ? context.push("/home/myPage")
                                    : context.push("/home/myPage/followList/${item.senderUuid}/userPage/${item.senderInfo?.first.nick ?? 'unknown'}/${item.senderUuid}/${item.senderUuid}");
                              },
                            );
                          } else if (item.subType == describeEnum(NotiSubType.notice) || item.subType == describeEnum(NotiSubType.event)) {
                            return NotificationNoticeItem(
                              content: item.body,
                              regDate: item.regDate,
                              isRead: item.isShow == 1 ? true : false,
                              profileImgUrl: (item.senderInfo?.isNotEmpty ?? false) ? item.senderInfo!.first.profileImgUrl : '',
                              onTap: () {
                                print('item.commentIdx ${item.commentIdx} / ${item.contentsIdx}');
                                ref.read(noticeFocusIdxStateProvider.notifier).state = item.contentsIdx;
                                ref.read(noticeExpansionIdxStateProvider.notifier).state = item.contentsIdx;
                                context.push("/home/myPage/setting/notice", extra: {
                                  "contentsIdx": item.contentsIdx,
                                });
                              },
                              onTapProfileButton: () {
                                myInfo.uuid == item.senderUuid
                                    ? context.push("/home/myPage")
                                    : context.push("/home/myPage/followList/${item.senderUuid}/userPage/${item.senderInfo?.first.nick ?? 'unknown'}/${item.senderUuid}/0");
                              },
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                  ),
                  // const Text('asdsadad'),
                  Container(
                    color: kPreviousNeutralColor100,
                    height: 70,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 10.h),
                          child: const Divider(),
                        ),
                        Text(
                          "최근 30일간의 알림만 볼 수 있어요.",
                          style: kBody12SemiBoldStyle.copyWith(color: kPreviousTextBodyColor),
                        ),
                      ],
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
