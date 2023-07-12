// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:matrix/matrix.dart' hide Visibility;
// import 'package:pet_mobile_social_flutter/common/util/extensions/date_time_extension.dart';
// import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
// import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
// import 'package:pet_mobile_social_flutter/controller/chat/matrix_chat_controller.dart';
// import 'package:pet_mobile_social_flutter/providers/chat/chat_register_state_provider.dart';
// import 'package:widget_mask/widget_mask.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
//
// class ChatRoomListItem extends ConsumerWidget {
//   final Room room;
//   final void Function()? onTap;
//   final void Function()? onLongPress;
//
//   // final String avatarUrl;
//   // final String nick;
//   // final String content;
//   // final String newCount;
//
//   const ChatRoomListItem({
//     Key? key,
//     required this.room,
//     this.onTap,
//     this.onLongPress,
//     // required this.avatarUrl,
//     // required this.nick,
//     // required this.content,
//     // required this.newCount,
//   }) : super(key: key);
//
//   Widget getAvatar() {
//     return WidgetMask(
//       blendMode: BlendMode.srcATop,
//       childSaveLayer: true,
//       mask: Center(
//         child: Image.network(
//           room.avatar != null ? room.avatar.toString() : 'https://via.placeholder.com/150/f66b97',
//           // width: 42.w,
//           height: 41.h,
//           fit: BoxFit.fill,
//         ),
//       ),
//       child: SvgPicture.asset(
//         'assets/image/feed/image/squircle.svg',
//         width: 41.w,
//         height: 41.h,
//         fit: BoxFit.fill,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     MatrixChatClientController matrixChatClientController = ref.read(chatControllerProvider('matrix').notifier).state as MatrixChatClientController;
//     Client client = matrixChatClientController.client;
//
//     final isMuted = room.pushRuleState != PushRuleState.notify;
//     final typingUsers = room.typingUsers;
//     typingUsers.removeWhere((User u) => u.id == client.userID);
//     final ownMessage = room.lastEvent?.senderId == client.userID;
//     final unread = room.isUnread || room.membership == Membership.invite;
//     final unreadBubbleSize = unread || room.hasNewMessages
//         ? room.notificationCount > 0
//             ? 20.0
//             : 14.0
//         : 0.0;
//
//     if (ownMessage && unread) {
//       print('${room.id} - unread');
//     }
//
//     return Slidable(
//       key: const ValueKey(0),
//       startActionPane: ActionPane(
//         extentRatio: 0.42.w,
//         motion: const DrawerMotion(),
//         children: [
//           SlidableAction(
//             onPressed: (_) async {
//               await room.setFavourite(!room.isFavourite);
//             },
//             backgroundColor: kPrimaryLightColor,
//             foregroundColor: kPrimaryColor,
//             icon: Icons.push_pin,
//             label: '메시지.고정'.tr(),
//             labelStyle: kBody11SemiBoldStyle.copyWith(height: 1.2.h),
//           ),
//           SlidableAction(
//             onPressed: (_) async {
//               // await room.setFavourite(!room.isFavourite);
//             },
//             backgroundColor: kPrimaryColor,
//             foregroundColor: kPrimaryLightColor,
//             icon: Icons.star_border,
//             label: '메시지.즐겨찾기'.tr(),
//             labelStyle: kBody11SemiBoldStyle.copyWith(height: 1.2.h),
//           ),
//         ],
//       ),
//       endActionPane: ActionPane(
//         extentRatio: 0.21.w,
//         motion: const DrawerMotion(),
//         children: [
//           SlidableAction(
//             onPressed: (_) async {
//               await room.leave();
//             },
//             backgroundColor: kBadgeColor,
//             foregroundColor: kPrimaryLightColor,
//             icon: Icons.exit_to_app,
//             label: '메시지.나가기'.tr(),
//             labelStyle: kBody11SemiBoldStyle.copyWith(height: 1.2.h),
//           ),
//         ],
//       ),
//       child: InkWell(
//         onTap: () {
//           if (onTap != null) {
//             onTap!();
//           }
//         },
//         onLongPress: () {
//
//         },
//         child: Padding(
//           padding: EdgeInsets.fromLTRB(12.0.w, 4.0.h, 12.0.w, 4.0.h),
//           child: Row(
//             children: [
//               getAvatar(),
//               SizedBox(
//                 width: 8.0.w,
//               ),
//               Expanded(
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           room.getLocalizedDisplayname(),
//                           style: kBody13BoldStyle.copyWith(color: kTextTitleColor),
//                         ),
//                         Visibility(
//                           visible: room.isFavourite,
//                           child: Icon(Icons.push_pin),
//                         ),
//                         const Spacer(),
//                         const Icon(
//                           Icons.check,
//                           size: 15,
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(left: 4.0.w),
//                           child: Text(
//                             room.timeCreated.localizedTimeDayDiff(context),
//                             style: kBadge10MediumStyle.copyWith(color: kNeutralColor500),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             room.lastEvent!.calcUnlocalizedBody(
//                               hideReply: true,
//                               hideEdit: true,
//                               plaintextBody: true,
//                               removeMarkdown: true,
//                             ),
//                             style: unread ? kBody12ExtraBoldStyle.copyWith(color: kTextBodyColor, height: 1.3) : kBody12RegularStyle400.copyWith(color: kTextBodyColor, height: 1.3),
//                             softWrap: false,
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         SizedBox(
//                           width: 32.0.w,
//                         ),
//                         if (room.notificationCount > 0)
//                           Container(
//                             width: 20.w,
//                             height: 20.h,
//                             decoration: const BoxDecoration(color: kBadgeColor, shape: BoxShape.circle),
//                             child: Center(
//                               child: room.notificationCount > 0
//                                   ? Text(
//                                       room.notificationCount.toString(),
//                                       style: kBadge8RegularStyle.copyWith(color: kNeutralColor100),
//                                     )
//                                   : const SizedBox.shrink(),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//       // ListTile(
//       //     contentPadding: EdgeInsets.only(left: 12.0.w, right: 12.0.w),
//       //     leading: getAvatar(),
//       //     title: Row(
//       //       children: [
//       //         Text(
//       //           room.getLocalizedDisplayname(),
//       //           style: kBody13BoldStyle.copyWith(color: kTextTitleColor),
//       //         ),
//       //         Visibility(
//       //           visible: room.isFavourite,
//       //           child: Icon(Icons.push_pin),
//       //         ),
//       //         const Spacer(),
//       //         const Icon(
//       //           Icons.check,
//       //           size: 15,
//       //         ),
//       //         Padding(
//       //           padding: EdgeInsets.only(left: 4.0.w),
//       //           child: Text(
//       //             room.timeCreated.localizedTimeDayDiff(context),
//       //             style: kBadge10MediumStyle.copyWith(color: kNeutralColor500),
//       //           ),
//       //         ),
//       //       ],
//       //     ),
//       //     subtitle: Row(
//       //       children: [
//       //         Expanded(
//       //           child: Text(
//       //             room.lastEvent!.calcUnlocalizedBody(
//       //               hideReply: true,
//       //               hideEdit: true,
//       //               plaintextBody: true,
//       //               removeMarkdown: true,
//       //             ),
//       //             style: unread ? kBody12ExtraBoldStyle.copyWith(color: kTextBodyColor, height: 1.3) : kBody12RegularStyle400.copyWith(color: kTextBodyColor, height: 1.3),
//       //             softWrap: false,
//       //             maxLines: 2,
//       //             overflow: TextOverflow.ellipsis,
//       //           ),
//       //         ),
//       //         SizedBox(
//       //           width: 32.0.w,
//       //         ),
//       //         if (room.notificationCount > 0)
//       //           Container(
//       //             width: 20.w,
//       //             height: 20.h,
//       //             decoration: const BoxDecoration(color: kBadgeColor, shape: BoxShape.circle),
//       //             child: Center(
//       //               child: room.notificationCount > 0
//       //                   ? Text(
//       //                       room.notificationCount.toString(),
//       //                       style: kBadge8RegularStyle.copyWith(color: kNeutralColor100),
//       //                     )
//       //                   : const SizedBox.shrink(),
//       //             ),
//       //           ),
//       //       ],
//       //     ),
//       //     onTap: () {
//       //       if (onTap != null) {
//       //         onTap!();
//       //       }
//       //     }),
//     );
//   }
// }
