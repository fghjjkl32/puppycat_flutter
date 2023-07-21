import 'dart:math';

import 'package:bubble/bubble.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_msg_model.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_room_state_provider.dart';
import 'package:swipe_to_action/swipe_to_action.dart';
import 'package:widget_mask/widget_mask.dart';
import 'package:pet_mobile_social_flutter/common/util/extensions/date_time_extension.dart';

enum ContextMenuType {
  reply,
  edit,
  copy,
  delete,
  reaction,
  resend,
}

class ChatMessageItem extends ConsumerWidget {
  final ChatMessageModel chatMessageModel;
  final ValueKey _sliderKey = const ValueKey('slider');
  Offset? _lastPointerDownPosition;
  final ValueChanged<bool>? onSlide;
  final void Function()? onTap;
  final void Function(Offset?)? onLongPress;
  final void Function()? onCopy;
  final void Function(ChatMessageModel)? onLeave;
  final void Function(ChatMessageModel)? onReply;
  final void Function(ChatMessageModel)? onEdit;
  final void Function(ChatMessageModel)? onDelete;
  final void Function(ChatMessageModel, String reactionKey)? onReaction;
  final void Function(ChatMessageModel)? onError;
  final bool isError;
  final bool isSending;
  final bool isRedacted;
  final String redactedMsg;

  ChatMessageItem({
    Key? key,
    required this.chatMessageModel,
    this.onSlide,
    this.onTap,
    this.onLongPress,
    this.onCopy,
    this.onLeave,
    this.onReply,
    this.onEdit,
    this.onDelete,
    this.onReaction,
    this.onError,
    required this.isError,
    required this.isSending,
    required this.isRedacted,
    this.redactedMsg = '',
  }) : super(key: key);

  Widget _getAvatar(String avatarUrl) {
    return WidgetMask(
      blendMode: BlendMode.srcATop,
      childSaveLayer: true,
      mask: Center(
        child: Image.asset(
          'assets/image/feed/image/sample_image3.png',
          // avatarUrl != '' ? 'assets/image/feed/image/sample_image3.png' : 'https://via.placeholder.com/150/f66b97',
          // width: 42,
          height: 28,
          fit: BoxFit.fill,
        ),
      ),
      // Image.network(
      //     avatarUrl != '' ? avatarUrl : 'https://via.placeholder.com/150/f66b97',
      //     // avatarUrl != '' ? 'assets/image/feed/image/sample_image3.png' : 'https://via.placeholder.com/150/f66b97',
      //     // width: 42.w,
      //     height: 41.h,
      //     fit: BoxFit.fill,
      //   ),
      // ),
      child: SvgPicture.asset(
        'assets/image/feed/image/squircle.svg',
        // width: 28,
        height: 28,
        fit: BoxFit.fill,
      ),
    );
  }

  ///NOTE
  ///GPT Code
  void _showMenu(BuildContext context, WidgetRef ref, Offset position) {
    final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final screenHeight = overlay.size.height;

    selectedItemBuilder(BuildContext context) {
      return <PopupMenuEntry<ContextMenuType>>[
        PopupMenuItem<ContextMenuType>(
          value: ContextMenuType.reply,
          child: SizedBox(
            width: 212.w,
            child: Padding(
              padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 8.h),
              child: Row(
                children: [
                  Text(
                    '메시지.답장'.tr(),
                    style: kBody12SemiBoldStyle.copyWith(color: kTextSubTitleColor),
                  ),
                  Spacer(),
                  Image.asset(
                    'assets/image/chat/icon_re-comment.png',
                    color: kTextSubTitleColor,
                    width: 20.w,
                    height: 20.h,
                  ),
                ],
              ),
            ),
          ),
        ),
        PopupMenuItem<ContextMenuType>(
          value: ContextMenuType.reply,
          child: SizedBox(
            width: 212.w,
            child: Padding(
              padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 8.h),
              child: Row(
                children: [
                  Text(
                    '메시지.수정'.tr(),
                    style: kBody12SemiBoldStyle.copyWith(color: kTextSubTitleColor),
                  ),
                  Spacer(),
                  Image.asset(
                    'assets/image/chat/icon_modify.png',
                    color: kTextSubTitleColor,
                    width: 20.w,
                    height: 20.h,
                  ),
                ],
              ),
            ),
          ),
        ),
        PopupMenuItem<ContextMenuType>(
          value: ContextMenuType.reply,
          child: SizedBox(
            width: 212.w,
            child: Padding(
              padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 8.h),
              child: Row(
                children: [
                  Text(
                    '메시지.복사'.tr(),
                    style: kBody12SemiBoldStyle.copyWith(color: kTextSubTitleColor),
                  ),
                  Spacer(),
                  Image.asset(
                    'assets/image/chat/icon_copy.png',
                    color: kTextSubTitleColor,
                    width: 20.w,
                    height: 20.h,
                  ),
                ],
              ),
            ),
          ),
        ),
        PopupMenuItem<ContextMenuType>(
          value: ContextMenuType.reply,
          child: SizedBox(
            width: 212.w,
            child: Padding(
              padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 8.h),
              child: Row(
                children: [
                  Text(
                    '메시지.삭제'.tr(),
                    style: kBody12SemiBoldStyle.copyWith(color: kBadgeColor),
                  ),
                  Spacer(),
                  Image.asset(
                    'assets/image/chat/icon_delete_s.png',
                    color: kBadgeColor,
                    width: 20.w,
                    height: 20.h,
                  ),
                ],
              ),
            ),
          ),
        ),
        PopupMenuItem<ContextMenuType>(
          value: ContextMenuType.reaction,
          child: Padding(
            padding: EdgeInsets.fromLTRB(14.w, 0.h, 14.w, 0.h),
            child: Column(
              children: [
                const Divider(),
                Padding(
                  padding: EdgeInsets.only(top: 8.0.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        child: Text('😀'),
                        onTap: () {
                          _reaction('😀');
                          Navigator.pop(context);
                        },
                      ),
                      InkWell(
                        child: Text('😃'),
                        onTap: () {
                          _reaction('😃');
                          Navigator.pop(context);
                        },
                      ),
                      InkWell(
                        child: Text('😄'),
                        onTap: () {
                          _reaction('😀');
                          Navigator.pop(context);
                        },
                      ),
                      InkWell(
                        child: Text('😁'),
                        onTap: () {
                          _reaction('😁');
                          Navigator.pop(context);
                        },
                      ),
                      InkWell(
                        child: Text('😆'),
                        onTap: () {
                          _reaction('😆');
                          Navigator.pop(context);
                        },
                      ),
                      InkWell(
                        child: Text('😅'),
                        onTap: () {
                          _reaction('😅');
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ];
    }

    // Get height of single menu item
    final menuItemHeight = 48.0; // Standard Material Design menu item height
    // Calculate estimated menu height
    final menuHeight = selectedItemBuilder(context).length * menuItemHeight;

    // Calculate top of the menu
    final double menuTop = position.dy < screenHeight / 2 ? position.dy : max(0, position.dy - menuHeight);

    showMenu(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      items: selectedItemBuilder(context),
      position: RelativeRect.fromLTRB(position.dx, menuTop, overlay.size.width - position.dx, overlay.size.height - menuTop),
      elevation: 8.0,
    ).then<void>((ContextMenuType? newValue) {
      if (newValue == null) return;
      switch (newValue) {
        case ContextMenuType.reply:
          _reply();
        case ContextMenuType.edit:
          _edit();
        case ContextMenuType.copy:
          Clipboard.setData(ClipboardData(text: chatMessageModel.msg));
        case ContextMenuType.delete:
          _delete();
        case ContextMenuType.resend:
          _resend();
        case ContextMenuType.reaction:
      }
    });
  }

  ///TODO
  ///얘네는 나중에 다 밖에서 함수 받기
  void _reply() {
    // ref
    //     .read(chatReplyProvider.notifier)
    //     .state = chatMessageModel;
    if (onReply != null) {
      onReply!(chatMessageModel);
    }
  }

  void _edit() {
    // ref
    //     .read(chatEditProvider.notifier)
    //     .state = chatMessageModel;
    if (onEdit != null) {
      onEdit!(chatMessageModel);
    }
  }

  void _delete() {
    if (!chatMessageModel.isMine) {
      return;
    }
    // ref
    //     .read(chatDeleteProvider.notifier)
    //     .state = chatMessageModel;
    if (onDelete != null) {
      onDelete!(chatMessageModel);
    }
  }

  void _reaction(String reactionKey) {
    if (onReaction != null) {
      onReaction!(chatMessageModel, reactionKey);
    }
  }

  void _resend() {
    if (onError != null) {
      onError!(chatMessageModel);
    }
  }

  Widget _hashTagText(String text, bool isRedacted) {
    return DetectableText(
      text: text,
      detectionRegExp: detectionRegExp(atSign: false) ??
          RegExp(
            "(?!\\n)(?:^|\\s)([#]([$detectionContentLetters]+))|$urlRegexContent",
            multiLine: true,
          ),
      detectedStyle: kBody13RegularStyle.copyWith(color: kSecondaryColor),
      basicStyle: kBody13RegularStyle.copyWith(color: isRedacted ? kTextBodyColor : kTextSubTitleColor),
      onTap: (tappedText) {
        ///TODO
        /// 해시태그 검색 페이지 이동
        /// 밖에서 함수 받아오기
      },
    );
  }

  Widget _buildDateTimeArea(bool isRead, bool isEdit, bool isMine) {
    Widget rows;

    if (isMine && isSending) {
      return SpinKitCircle(
        size: 10.w,
        color: kNeutralColor500,
      );
    }

    if (isMine) {
      rows = Row(
        children: [
          isMine
              ? isRead
                  ? const ImageIcon(
                      AssetImage('assets/image/chat/icon_check_pair.png'),
                      // size: 10.w,
                      color: kNeutralColor500,
                    )
                  : const ImageIcon(
                      AssetImage('assets/image/chat/icon_check_single.png'),
                      // size: 10.w,
                      color: kNeutralColor500,
                    )
              : const SizedBox.shrink(),
          chatMessageModel.isViewTime
              ? Text(
                  DateTime.parse(chatMessageModel.dateTime).timeOfDay(),
                  style: kBadge10MediumStyle.copyWith(color: kNeutralColor500),
                )
              : const SizedBox.shrink(),
          SizedBox(width: 4.w,),
          isEdit ? Text('메시지.수정됨'.tr(), style: kBadge10MediumStyle.copyWith(color: kNeutralColor500)) : const SizedBox.shrink(),
        ],
      );
    } else {
      rows = Row(
        children: [
          isEdit ? Text('메시지.수정됨'.tr(), style: kBadge10MediumStyle.copyWith(color: kNeutralColor500)) : const SizedBox.shrink(),
          SizedBox(width: 4.w,),
          chatMessageModel.isViewTime
              ? Text(
                  DateTime.parse(chatMessageModel.dateTime).timeOfDay(),
                  style: kBadge10MediumStyle.copyWith(color: kNeutralColor500),
                )
              : const SizedBox.shrink(),
        ],
      );
    }

    return rows;
  }

  Widget _buildErrorArea() {
    return Container(
      width: 45.w,
      height: 20.h,
      decoration: const BoxDecoration(
        color: kBadgeColor,
        borderRadius: BorderRadius.all(
          Radius.circular(7),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                _resend();
              },
              child: const ImageIcon(
                AssetImage('assets/image/chat/icon_rt.png'),
                // size: 7.w,
                color: kNeutralColor100,
              ),
            ),
            // IconButton(
            //     onPressed: () {},
            //     icon: ImageIcon(
            //       const AssetImage('assets/image/chat/icon_rt_small.png'),
            //       size: 7.w,
            //       color: kNeutralColor100,
            //     )),
            Padding(
              padding: EdgeInsets.only(top: 4.0.h, bottom: 4.0.h),
              child: VerticalDivider(
                thickness: 2,
                width: 1,
                color: kNeutralColor100.withOpacity(0.2),
              ),
            ),
            InkWell(
              onTap: () {
                // print('remove');
                _delete();
              },
              child: const ImageIcon(
                AssetImage('assets/image/chat/icon_close_s.png'),
                // size: 7.w,
                color: kNeutralColor100,
              ),
            )
            // IconButton(
            //     onPressed: () {},
            //     icon: ImageIcon(
            //       const AssetImage('assets/image/chat/icon_close_small.png'),
            //       size: 7.w,
            //       color: kNeutralColor100,
            //     )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isMine = chatMessageModel.isMine;
    final bool isMineXorReply = isMine ^ chatMessageModel.isReply;
    final bool isAvatarCondition = !chatMessageModel.isConsecutively && !isMineXorReply;
    final bool hasReaction = chatMessageModel.reactions.isEmpty ? false : true;
    final String msg = isRedacted ? redactedMsg : chatMessageModel.msg;

    return Listener(
      onPointerDown: (details) => _lastPointerDownPosition = details.position,
      child: InkWell(
        onLongPress: () {
          if (onLongPress != null) {
            onLongPress!(_lastPointerDownPosition);
          } else {
            _showMenu(context, ref, _lastPointerDownPosition!);
          }
        },
        child: Swipeable(
          key: const ValueKey(0),
          direction: SwipeDirection.endToStart,
          onSwipe: (direction) {
            if (direction == SwipeDirection.startToEnd) {
              // do something
              print('start to end');
            } else {
              // do something else
              print('end to start');
              // ref
              //     .read(chatReplyProvider.notifier)
              //     .state = chatMessageModel;
              if (onReply != null) {
                onReply!(chatMessageModel);
              }
            }
          },
          background: const Center(
            child: Icon(
              Icons.reply,
              color: kNeutralColor600,
            ),
          ),
          secondaryBackground: const Center(
            child: Icon(
              Icons.reply,
              color: kNeutralColor600,
            ),
          ),
          confirmSwipe: (direction) async {
            return true;
          },
          child: Padding(
            padding: EdgeInsets.only(top: 4.0.h),
            child: Row(
              mainAxisAlignment: isMineXorReply ? MainAxisAlignment.end : MainAxisAlignment.start,
              // crossAxisAlignment: isMineXorReply ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 6.0.h),
                  child: InkWell(
                    onTap: () {
                      print('move user page');
                    },
                    child: SizedBox(
                      // color: Colors.red,
                      width: isAvatarCondition ? 28 : 35,
                      height: 28,
                      child: isAvatarCondition ? _getAvatar(chatMessageModel.avatarUrl) : const SizedBox.shrink(),
                    ),
                  ),
                ),
                // _buildMsgWidget(chatMessageModel.msg, chatMessageModel.isRead, isMineXorReply),
                // chatMessageModel.isRead && isMineXorReply ? Text('read') : const SizedBox.shrink(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: isMineXorReply && chatMessageModel.isConsecutively ? 8.0.w : 0),
                    // child: _buildMsgWidget(chatMessageModel.msg, chatMessageModel.isRead, isMineXorReply),
                    child: Column(
                      children: [
                        Bubble(
                          color: isMineXorReply ? kPrimaryLightColor : kNeutralColor200,
                          borderColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          // margin: BubbleEdges.only(top: 8, right: 50),
                          margin: BubbleEdges.only(top: 2.h),
                          alignment: isMineXorReply ? Alignment.topRight : Alignment.topLeft,
                          nip: chatMessageModel.isConsecutively
                              ? BubbleNip.no
                              : isMineXorReply
                                  // ? BubbleNip.rightTop
                                  // : BubbleNip.leftTop,
                                  ? BubbleNip.rightCenter
                                  : BubbleNip.leftCenter,
                          leftChild: isMineXorReply
                              ? [
                                  isError ? _buildErrorArea() : _buildDateTimeArea(chatMessageModel.isRead, chatMessageModel.isEdited, isMineXorReply),
                                  // _buildErrorArea(),
                                ]
                              : [],
                          rightChild: !isMineXorReply
                              ? [
                                  _buildDateTimeArea(chatMessageModel.isRead, chatMessageModel.isEdited, isMineXorReply),
                                ]
                              : [],
                          // sideChild: _buildErrorArea(),
                          // isLeftSideChild: isMineXorReply,
                          mainAxisAlignment: isMineXorReply ? MainAxisAlignment.end : MainAxisAlignment.start,
                          child: chatMessageModel.isReply
                              ? Text('${chatMessageModel.replyTargetNick}에게 답장\n${chatMessageModel.replyTargetMsg}\n${chatMessageModel.msg}')
                              : Container(
                                  constraints: BoxConstraints(
                                    maxWidth: isMineXorReply ? 230.w : 210.w, // Maximum width for the Bubble widget.
                                  ),
                                  child: _hashTagText(msg, isRedacted)),
                        ),
                        hasReaction
                            ? Padding(
                                padding: EdgeInsets.only(top: 2.0.h, left: 6.w, right: 6.w),
                                child: Align(alignment: isMineXorReply ? Alignment.centerRight : Alignment.centerLeft, child: Text(chatMessageModel.reactions.first)),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),

                // isError ? Text('error') : const SizedBox.shrink(),
                // isSending ? const CircularProgressIndicator() : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
