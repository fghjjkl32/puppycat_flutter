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

class ChatMessageItem extends ConsumerStatefulWidget {
  final ChatMessageModel chatMessageModel;
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
  final double bottomPadding;
  final void Function()? onMoveReply;

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
    this.bottomPadding = 4.0,
    this.onMoveReply,
  }) : super(key: key);

  @override
  ChatMessageItemState createState() => ChatMessageItemState();
}

class ChatMessageItemState extends ConsumerState<ChatMessageItem> {
  Offset? _lastPointerDownPosition;
  late ChatMessageModel chatMessageModel;
  bool isMine = false;
  bool isMineXorReply = false;
  bool isAvatarCondition = false;
  bool hasReaction = false;
  String msg = '';
  Color _bubbleColor = kNeutralColor200;

  // bool isHighLight = false;

  @override
  void initState() {
    _updateData();

    // print('$isMine / $isMineXorReply / $isAvatarCondition / $hasReaction / $msg');

    // _bubbleColor = isMineXorReply ? kPrimaryLightColor : kNeutralColor200;
    _updateBubbleColor(false);

    super.initState();
  }

  void _updateData() {
    chatMessageModel = widget.chatMessageModel;

    isMine = chatMessageModel.isMine;
    isMineXorReply = isMine ^ chatMessageModel.isReply;
    isAvatarCondition = !chatMessageModel.isConsecutively && !isMineXorReply;
    hasReaction = chatMessageModel.reactions.isEmpty ? false : true;
    msg = widget.isRedacted ? widget.redactedMsg : chatMessageModel.msg;
  }

  void _updateBubbleColor(bool isHighLight) {
    setState(() {
      if (isMineXorReply) {
        _bubbleColor = isHighLight ? kPrimaryLightColor : kPrimaryLightColor;
      } else {
        _bubbleColor = isHighLight ? kNeutralColor400 : kNeutralColor200;
      }
    });
  }

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
  void _showMenu(BuildContext context, Offset position, bool isMine) {
    final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final screenHeight = overlay.size.height;

    List<PopupMenuEntry<ContextMenuType>> menuItems = [];
    menuItems.add(
      PopupMenuItem<ContextMenuType>(
        value: ContextMenuType.reply,
        child: SizedBox(
          width: 212,
          child: Row(
            children: [
              Text(
                '메시지.답장'.tr(),
                style: kBody12SemiBoldStyle.copyWith(color: kTextSubTitleColor),
              ),
              const Spacer(),
              Image.asset(
                'assets/image/chat/icon_re-comment.png',
                color: kTextSubTitleColor,
                width: 20,
                height: 20,
              ),
            ],
          ),
        ),
      ),
    ); //reply
    if (isMine) {
      menuItems.add(
        PopupMenuItem<ContextMenuType>(
          value: ContextMenuType.edit,
          child: SizedBox(
            width: 212,
            child: Row(
              children: [
                Text(
                  '메시지.수정'.tr(),
                  style: kBody12SemiBoldStyle.copyWith(color: kTextSubTitleColor),
                ),
                const Spacer(),
                Image.asset(
                  'assets/image/chat/icon_modify.png',
                  color: kTextSubTitleColor,
                  width: 20,
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ); //edit
    }
    menuItems.add(
      PopupMenuItem<ContextMenuType>(
        value: ContextMenuType.copy,
        child: SizedBox(
          width: 212,
          child: Row(
            children: [
              Text(
                '메시지.복사'.tr(),
                style: kBody12SemiBoldStyle.copyWith(color: kTextSubTitleColor),
              ),
              const Spacer(),
              Image.asset(
                'assets/image/chat/icon_copy.png',
                color: kTextSubTitleColor,
                width: 20,
                height: 20,
              ),
            ],
          ),
        ),
      ),
    ); //copy
    menuItems.add(
      PopupMenuItem<ContextMenuType>(
        value: ContextMenuType.delete,
        child: SizedBox(
          width: 212,
          child: Row(
            children: [
              Text(
                '메시지.삭제'.tr(),
                style: kBody12SemiBoldStyle.copyWith(color: kBadgeColor),
              ),
              const Spacer(),
              Image.asset(
                'assets/image/chat/icon_delete_s.png',
                color: kBadgeColor,
                width: 20,
                height: 20,
              ),
            ],
          ),
        ),
      ),
    ); //delete
    menuItems.add(
      PopupMenuItem<ContextMenuType>(
        value: ContextMenuType.reaction,
        child: SizedBox(
          width: 212,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Divider(),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
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
    ); //reactions

    // Get height of single menu item
    const menuItemHeight = 48.0; // Standard Material Design menu item height
    // Calculate estimated menu height
    final menuHeight = menuItems.length * menuItemHeight;

    // Calculate top of the menu
    final double menuTop = position.dy < screenHeight / 2 ? position.dy : max(0, position.dy - menuHeight);

    // print('position.dx ${position.dx} / menuTop : $menuTop / overlay w ${overlay.size.width} / overlay h ${overlay.size.height}');
    // print('L ${position.dx} / T : $menuTop / R ${overlay.size.width - position.dx} / B ${overlay.size.height - menuTop}');

    showMenu(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      items: menuItems,
      position: RelativeRect.fromLTRB(position.dx, menuTop, overlay.size.width - position.dx, overlay.size.height - menuTop),
      elevation: 8.0,
    ).then<void>((ContextMenuType? newValue) {
      _updateBubbleColor(false);
      if (newValue == null) return;
      switch (newValue) {
        case ContextMenuType.reply:
          _reply();
          return;
        case ContextMenuType.edit:
          _edit();
          return;
        case ContextMenuType.copy:
          Clipboard.setData(ClipboardData(text: chatMessageModel.msg));
          return;
        case ContextMenuType.delete:
          _delete();
          return;
        case ContextMenuType.resend:
          _resend();
          return;
        case ContextMenuType.reaction:
          return;
      }
    });
  }

  void _reply() {
    if (widget.onReply != null) {
      widget.onReply!(chatMessageModel);
    }
  }

  void _edit() {
    final bool isMineXorReply = chatMessageModel.isMine ^ chatMessageModel.isReply;
    if (!isMineXorReply) {
      return;
    }

    if (widget.isRedacted) {
      return;
    }

    if (widget.onEdit != null) {
      widget.onEdit!(chatMessageModel);
    }
  }

  void _delete() {
    final bool isMineXorReply = chatMessageModel.isMine ^ chatMessageModel.isReply;
    if (!isMineXorReply) {
      return;
    }
    if (widget.onDelete != null) {
      widget.onDelete!(chatMessageModel);
    }
  }

  void _reaction(String reactionKey) {
    if (widget.onReaction != null) {
      widget.onReaction!(chatMessageModel, reactionKey);
    }
  }

  void _resend() {
    if (widget.onError != null) {
      widget.onError!(chatMessageModel);
    }
  }

  Widget _hashTagText(String text) {
    return DetectableText(
      text: text,
      detectionRegExp: detectionRegExp(atSign: false) ??
          RegExp(
            "(?!\\n)(?:^|\\s)([#]([$detectionContentLetters]+))|$urlRegexContent",
            multiLine: true,
          ),
      detectedStyle: kBody13RegularStyle.copyWith(color: kSecondaryColor),
      basicStyle: kBody13RegularStyle.copyWith(color: widget.isRedacted ? kTextBodyColor : kTextSubTitleColor),
      onTap: (tappedText) {
        ///TODO
        /// 해시태그 검색 페이지 이동
        /// 밖에서 함수 받아오기
      },
    );
  }

  Widget _buildMsgArea(bool isReply, String msg, bool isMine) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: isReply,
          child: IntrinsicWidth(
            child: InkWell(
              onTap: () {
                print('run?');
                if (widget.onMoveReply != null) {
                  widget.onMoveReply!();
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${chatMessageModel.replyTargetNick}${'메시지.님에게 답장'.tr()}\n${chatMessageModel.replyTargetMsg}',
                    style: kBody11RegularStyle.copyWith(color: kTextBodyColor),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8),
                    child: Divider(
                      color: kNeutralColor300,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        _hashTagText(msg),
        // Text(msg),
      ],
    );
  }

  Widget _buildDateTimeArea(bool isRead, bool isEdit, bool isMine) {
    Widget rows;

    if (isMine && widget.isSending) {
      return const SpinKitCircle(
        size: 10,
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
          // Text(
          //   DateTime.parse(chatMessageModel.dateTime).timeOfDay(),
          //   style: kBadge10MediumStyle.copyWith(color: kNeutralColor500),
          // ),
          // SizedBox(
          //   width: 4.w,
          // ),
          isEdit
              ? Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text('메시지.수정됨'.tr(), style: kBadge10MediumStyle.copyWith(color: kNeutralColor500)),
                )
              : const SizedBox.shrink(),
        ],
      );
    } else {
      rows = Row(
        children: [
          isEdit ? Text('메시지.수정됨'.tr(), style: kBadge10MediumStyle.copyWith(color: kNeutralColor500)) : const SizedBox.shrink(),
          const SizedBox(
            width: 4,
          ),
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
      width: 45,
      height: 20,
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
              padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
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
  Widget build(BuildContext context) {
    _updateData();

    return Listener(
      onPointerDown: (details) => _lastPointerDownPosition = details.position,
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
            if (widget.onReply != null) {
              widget.onReply!(chatMessageModel);
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
          if (widget.isRedacted) {
            return false;
          }
          return true;
        },
        child: Padding(
          padding: EdgeInsets.only(bottom: widget.bottomPadding),
          child: Row(
            mainAxisAlignment: isMineXorReply ? MainAxisAlignment.end : MainAxisAlignment.start,
            // crossAxisAlignment: isMineXorReply ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isMineXorReply ? const SizedBox.shrink() : Padding(
                padding: const EdgeInsets.only(right: 8.0),
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
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(right: isMineXorReply && chatMessageModel.isConsecutively ? 8.0 : 0),
                  // child: _buildMsgWidget(chatMessageModel.msg, chatMessageModel.isRead, isMineXorReply),
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Bubble(
                        color: _bubbleColor,
                        onHighlightChanged: (_) {
                          // _updateBubbleColor(true);
                        },//isMineXorReply ? kPrimaryLightColor : kNeutralColor200,
                        onLongPress: () {
                          if (widget.isRedacted) {
                            return;
                          }
                          _updateBubbleColor(true);
                          if (widget.onLongPress != null) {
                            widget.onLongPress!(_lastPointerDownPosition);
                          } else {
                            _showMenu(context, _lastPointerDownPosition!, isMineXorReply);
                          }
                        },
                        radius: const Radius.circular(10),
                        borderColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const BubbleEdges.fromLTRB(12, 8, 12, 8),
                        alignment: isMineXorReply ? Alignment.topRight : Alignment.topLeft,
                        nip: chatMessageModel.isConsecutively
                            ? BubbleNip.no
                            : isMineXorReply
                            ? BubbleNip.rightTop
                            : BubbleNip.leftTop,
                        nipOffset: 16.0,
                        leftChild: isMineXorReply
                            ? [
                          widget.isError ? _buildErrorArea() : _buildDateTimeArea(chatMessageModel.isRead, chatMessageModel.isEdited, isMineXorReply),
                          // _buildErrorArea(),
                        ]
                            : [],
                        rightChild: !isMineXorReply
                            ? [
                          _buildDateTimeArea(chatMessageModel.isRead, chatMessageModel.isEdited, isMineXorReply),
                        ]
                            : [],
                        mainAxisAlignment: isMineXorReply ? MainAxisAlignment.end : MainAxisAlignment.start,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: isMineXorReply ? 0.6.sw : 0.50.sw, // Maximum width for the Bubble widget.
                          ),
                          child: _buildMsgArea(chatMessageModel.isReply, msg, isMineXorReply),
                        ),
                      ),
                      hasReaction
                          ? Padding(
                              padding: const EdgeInsets.only(top: 2.0, left: 8, right: 8),
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
    );
  }
}

// class ChatMessageItem extends ConsumerWidget {
//   final ChatMessageModel chatMessageModel;
//   final ValueKey _sliderKey = const ValueKey('slider');
//   Offset? _lastPointerDownPosition;
//   final ValueChanged<bool>? onSlide;
//   final void Function()? onTap;
//   final void Function(Offset?)? onLongPress;
//   final void Function()? onCopy;
//   final void Function(ChatMessageModel)? onLeave;
//   final void Function(ChatMessageModel)? onReply;
//   final void Function(ChatMessageModel)? onEdit;
//   final void Function(ChatMessageModel)? onDelete;
//   final void Function(ChatMessageModel, String reactionKey)? onReaction;
//   final void Function(ChatMessageModel)? onError;
//   final bool isError;
//   final bool isSending;
//   final bool isRedacted;
//   final String redactedMsg;
//   final double bottomPadding;
//
//   ChatMessageItem({
//     Key? key,
//     required this.chatMessageModel,
//     this.onSlide,
//     this.onTap,
//     this.onLongPress,
//     this.onCopy,
//     this.onLeave,
//     this.onReply,
//     this.onEdit,
//     this.onDelete,
//     this.onReaction,
//     this.onError,
//     required this.isError,
//     required this.isSending,
//     required this.isRedacted,
//     this.redactedMsg = '',
//     this.bottomPadding = 4.0,
//   }) : super(key: key);
//
//   // late Color _bubbleColor;
//   // bool isHighLight = false;
//
//   Widget _getAvatar(String avatarUrl) {
//     return WidgetMask(
//       blendMode: BlendMode.srcATop,
//       childSaveLayer: true,
//       mask: Center(
//         child: Image.asset(
//           'assets/image/feed/image/sample_image3.png',
//           // avatarUrl != '' ? 'assets/image/feed/image/sample_image3.png' : 'https://via.placeholder.com/150/f66b97',
//           // width: 42,
//           height: 28,
//           fit: BoxFit.fill,
//         ),
//       ),
//       // Image.network(
//       //     avatarUrl != '' ? avatarUrl : 'https://via.placeholder.com/150/f66b97',
//       //     // avatarUrl != '' ? 'assets/image/feed/image/sample_image3.png' : 'https://via.placeholder.com/150/f66b97',
//       //     // width: 42.w,
//       //     height: 41.h,
//       //     fit: BoxFit.fill,
//       //   ),
//       // ),
//       child: SvgPicture.asset(
//         'assets/image/feed/image/squircle.svg',
//         // width: 28,
//         height: 28,
//         fit: BoxFit.fill,
//       ),
//     );
//   }
//
//   ///NOTE
//   ///GPT Code
//   void _showMenu(BuildContext context, Offset position, bool isMine) {
//     final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
//     final screenHeight = overlay.size.height;
//
//     List<PopupMenuEntry<ContextMenuType>> menuItems = [];
//     menuItems.add(
//       PopupMenuItem<ContextMenuType>(
//         value: ContextMenuType.reply,
//         child: SizedBox(
//           width: 212,
//           child: Row(
//             children: [
//               Text(
//                 '메시지.답장'.tr(),
//                 style: kBody12SemiBoldStyle.copyWith(color: kTextSubTitleColor),
//               ),
//               const Spacer(),
//               Image.asset(
//                 'assets/image/chat/icon_re-comment.png',
//                 color: kTextSubTitleColor,
//                 width: 20,
//                 height: 20,
//               ),
//             ],
//           ),
//         ),
//       ),
//     ); //reply
//     if (isMine) {
//       menuItems.add(
//         PopupMenuItem<ContextMenuType>(
//           value: ContextMenuType.edit,
//           child: SizedBox(
//             width: 212,
//             child: Row(
//               children: [
//                 Text(
//                   '메시지.수정'.tr(),
//                   style: kBody12SemiBoldStyle.copyWith(color: kTextSubTitleColor),
//                 ),
//                 const Spacer(),
//                 Image.asset(
//                   'assets/image/chat/icon_modify.png',
//                   color: kTextSubTitleColor,
//                   width: 20,
//                   height: 20,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ); //edit
//     }
//     menuItems.add(
//       PopupMenuItem<ContextMenuType>(
//         value: ContextMenuType.copy,
//         child: SizedBox(
//           width: 212,
//           child: Row(
//             children: [
//               Text(
//                 '메시지.복사'.tr(),
//                 style: kBody12SemiBoldStyle.copyWith(color: kTextSubTitleColor),
//               ),
//               const Spacer(),
//               Image.asset(
//                 'assets/image/chat/icon_copy.png',
//                 color: kTextSubTitleColor,
//                 width: 20,
//                 height: 20,
//               ),
//             ],
//           ),
//         ),
//       ),
//     ); //copy
//     menuItems.add(
//       PopupMenuItem<ContextMenuType>(
//         value: ContextMenuType.delete,
//         child: SizedBox(
//           width: 212,
//           child: Row(
//             children: [
//               Text(
//                 '메시지.삭제'.tr(),
//                 style: kBody12SemiBoldStyle.copyWith(color: kBadgeColor),
//               ),
//               const Spacer(),
//               Image.asset(
//                 'assets/image/chat/icon_delete_s.png',
//                 color: kBadgeColor,
//                 width: 20,
//                 height: 20,
//               ),
//             ],
//           ),
//         ),
//       ),
//     ); //delete
//     menuItems.add(
//       PopupMenuItem<ContextMenuType>(
//         value: ContextMenuType.reaction,
//         child: SizedBox(
//           width: 212,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Divider(),
//               Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     InkWell(
//                       child: Text('😀'),
//                       onTap: () {
//                         _reaction('😀');
//                         Navigator.pop(context);
//                       },
//                     ),
//                     InkWell(
//                       child: Text('😃'),
//                       onTap: () {
//                         _reaction('😃');
//                         Navigator.pop(context);
//                       },
//                     ),
//                     InkWell(
//                       child: Text('😄'),
//                       onTap: () {
//                         _reaction('😀');
//                         Navigator.pop(context);
//                       },
//                     ),
//                     InkWell(
//                       child: Text('😁'),
//                       onTap: () {
//                         _reaction('😁');
//                         Navigator.pop(context);
//                       },
//                     ),
//                     InkWell(
//                       child: Text('😆'),
//                       onTap: () {
//                         _reaction('😆');
//                         Navigator.pop(context);
//                       },
//                     ),
//                     InkWell(
//                       child: Text('😅'),
//                       onTap: () {
//                         _reaction('😅');
//                         Navigator.pop(context);
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ); //reactions
//
//     // Get height of single menu item
//     final menuItemHeight = 48.0; // Standard Material Design menu item height
//     // Calculate estimated menu height
//     final menuHeight = menuItems.length * menuItemHeight;
//
//     // Calculate top of the menu
//     final double menuTop = position.dy < screenHeight / 2 ? position.dy : max(0, position.dy - menuHeight);
//
//     print('position.dx ${position.dx} / menuTop : $menuTop / overlay w ${overlay.size.width} / overlay h ${overlay.size.height}');
//     print('L ${position.dx} / T : $menuTop / R ${overlay.size.width - position.dx} / B ${overlay.size.height - menuTop}');
//
//     showMenu(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       context: context,
//       items: menuItems,
//       position: RelativeRect.fromLTRB(position.dx, menuTop, overlay.size.width - position.dx, overlay.size.height - menuTop),
//       elevation: 8.0,
//     ).then<void>((ContextMenuType? newValue) {
//       if (newValue == null) return;
//       // isHighLight = false;
//       switch (newValue) {
//         case ContextMenuType.reply:
//           _reply();
//           return;
//         case ContextMenuType.edit:
//           _edit();
//           return;
//         case ContextMenuType.copy:
//           Clipboard.setData(ClipboardData(text: chatMessageModel.msg));
//           return;
//         case ContextMenuType.delete:
//           _delete();
//           return;
//         case ContextMenuType.resend:
//           _resend();
//           return;
//         case ContextMenuType.reaction:
//           return;
//       }
//     });
//   }
//
//   void _reply() {
//     if (onReply != null) {
//       onReply!(chatMessageModel);
//     }
//   }
//
//   void _edit() {
//     final bool isMineXorReply = chatMessageModel.isMine ^ chatMessageModel.isReply;
//     if (!isMineXorReply) {
//       return;
//     }
//
//     if (isRedacted) {
//       return;
//     }
//
//     if (onEdit != null) {
//       onEdit!(chatMessageModel);
//     }
//   }
//
//   void _delete() {
//     final bool isMineXorReply = chatMessageModel.isMine ^ chatMessageModel.isReply;
//     if (!isMineXorReply) {
//       return;
//     }
//     if (onDelete != null) {
//       onDelete!(chatMessageModel);
//     }
//   }
//
//   void _reaction(String reactionKey) {
//     if (onReaction != null) {
//       onReaction!(chatMessageModel, reactionKey);
//     }
//   }
//
//   void _resend() {
//     if (onError != null) {
//       onError!(chatMessageModel);
//     }
//   }
//
//   Widget _hashTagText(String text) {
//     return DetectableText(
//       text: text,
//       detectionRegExp: detectionRegExp(atSign: false) ??
//           RegExp(
//             "(?!\\n)(?:^|\\s)([#]([$detectionContentLetters]+))|$urlRegexContent",
//             multiLine: true,
//           ),
//       detectedStyle: kBody13RegularStyle.copyWith(color: kSecondaryColor),
//       basicStyle: kBody13RegularStyle.copyWith(color: isRedacted ? kTextBodyColor : kTextSubTitleColor),
//       onTap: (tappedText) {
//         ///TODO
//         /// 해시태그 검색 페이지 이동
//         /// 밖에서 함수 받아오기
//       },
//     );
//   }
//
//   Widget _buildMsgArea(bool isReply, String msg, bool isMine) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Visibility(
//           visible: isReply,
//           child: IntrinsicWidth(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   '${chatMessageModel.replyTargetNick}${'메시지.님에게 답장'.tr()}\n${chatMessageModel.replyTargetMsg}',
//                   style: kBody11RegularStyle.copyWith(color: kTextBodyColor),
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.only(top: 8.0, bottom: 8),
//                   child: Divider(
//                     color: kNeutralColor300,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         _hashTagText(msg),
//         // Text(msg),
//       ],
//     );
//   }
//
//   Widget _buildDateTimeArea(bool isRead, bool isEdit, bool isMine) {
//     Widget rows;
//
//     if (isMine && isSending) {
//       return const SpinKitCircle(
//         size: 10,
//         color: kNeutralColor500,
//       );
//     }
//
//     if (isMine) {
//       rows = Row(
//         children: [
//           isMine
//               ? isRead
//                   ? const ImageIcon(
//                       AssetImage('assets/image/chat/icon_check_pair.png'),
//                       // size: 10.w,
//                       color: kNeutralColor500,
//                     )
//                   : const ImageIcon(
//                       AssetImage('assets/image/chat/icon_check_single.png'),
//                       // size: 10.w,
//                       color: kNeutralColor500,
//                     )
//               : const SizedBox.shrink(),
//           chatMessageModel.isViewTime
//               ? Text(
//                   DateTime.parse(chatMessageModel.dateTime).timeOfDay(),
//                   style: kBadge10MediumStyle.copyWith(color: kNeutralColor500),
//                 )
//               : const SizedBox.shrink(),
//           // Text(
//           //   DateTime.parse(chatMessageModel.dateTime).timeOfDay(),
//           //   style: kBadge10MediumStyle.copyWith(color: kNeutralColor500),
//           // ),
//           // SizedBox(
//           //   width: 4.w,
//           // ),
//           isEdit
//               ? Padding(
//                   padding: const EdgeInsets.only(left: 4.0),
//                   child: Text('메시지.수정됨'.tr(), style: kBadge10MediumStyle.copyWith(color: kNeutralColor500)),
//                 )
//               : const SizedBox.shrink(),
//         ],
//       );
//     } else {
//       rows = Row(
//         children: [
//           isEdit ? Text('메시지.수정됨'.tr(), style: kBadge10MediumStyle.copyWith(color: kNeutralColor500)) : const SizedBox.shrink(),
//           const SizedBox(
//             width: 4,
//           ),
//           chatMessageModel.isViewTime
//               ? Text(
//                   DateTime.parse(chatMessageModel.dateTime).timeOfDay(),
//                   style: kBadge10MediumStyle.copyWith(color: kNeutralColor500),
//                 )
//               : const SizedBox.shrink(),
//         ],
//       );
//     }
//
//     return rows;
//   }
//
//   Widget _buildErrorArea() {
//     return Container(
//       width: 45,
//       height: 20,
//       decoration: const BoxDecoration(
//         color: kBadgeColor,
//         borderRadius: BorderRadius.all(
//           Radius.circular(7),
//         ),
//       ),
//       child: IntrinsicHeight(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             InkWell(
//               onTap: () {
//                 _resend();
//               },
//               child: const ImageIcon(
//                 AssetImage('assets/image/chat/icon_rt.png'),
//                 // size: 7.w,
//                 color: kNeutralColor100,
//               ),
//             ),
//             // IconButton(
//             //     onPressed: () {},
//             //     icon: ImageIcon(
//             //       const AssetImage('assets/image/chat/icon_rt_small.png'),
//             //       size: 7.w,
//             //       color: kNeutralColor100,
//             //     )),
//             Padding(
//               padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
//               child: VerticalDivider(
//                 thickness: 2,
//                 width: 1,
//                 color: kNeutralColor100.withOpacity(0.2),
//               ),
//             ),
//             InkWell(
//               onTap: () {
//                 // print('remove');
//                 _delete();
//               },
//               child: const ImageIcon(
//                 AssetImage('assets/image/chat/icon_close_s.png'),
//                 // size: 7.w,
//                 color: kNeutralColor100,
//               ),
//             )
//             // IconButton(
//             //     onPressed: () {},
//             //     icon: ImageIcon(
//             //       const AssetImage('assets/image/chat/icon_close_small.png'),
//             //       size: 7.w,
//             //       color: kNeutralColor100,
//             //     )),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final bool isMine = chatMessageModel.isMine;
//     final bool isMineXorReply = isMine ^ chatMessageModel.isReply;
//     final bool isAvatarCondition = !chatMessageModel.isConsecutively && !isMineXorReply;
//     final bool hasReaction = chatMessageModel.reactions.isEmpty ? false : true;
//     final String msg = isRedacted ? redactedMsg : chatMessageModel.msg;
//     // if (isMineXorReply) {
//     //   _bubbleColor = isHighLight ? kPrimaryLightColor : kPrimaryLightColor;
//     // } else {
//     //   _bubbleColor = isHighLight ? kNeutralColor400 : kNeutralColor200;
//     // }
//
//     return Swipeable(
//       key: const ValueKey(0),
//       direction: SwipeDirection.endToStart,
//       onSwipe: (direction) {
//         if (direction == SwipeDirection.startToEnd) {
//           // do something
//           print('start to end');
//         } else {
//           // do something else
//           print('end to start');
//           // ref
//           //     .read(chatReplyProvider.notifier)
//           //     .state = chatMessageModel;
//           if (onReply != null) {
//             onReply!(chatMessageModel);
//           }
//         }
//       },
//       background: const Center(
//         child: Icon(
//           Icons.reply,
//           color: kNeutralColor600,
//         ),
//       ),
//       secondaryBackground: const Center(
//         child: Icon(
//           Icons.reply,
//           color: kNeutralColor600,
//         ),
//       ),
//       confirmSwipe: (direction) async {
//         if (isRedacted) {
//           return false;
//         }
//         return true;
//       },
//       child: Padding(
//         padding: EdgeInsets.only(bottom: bottomPadding),
//         child: Row(
//           mainAxisAlignment: isMineXorReply ? MainAxisAlignment.end : MainAxisAlignment.start,
//           // crossAxisAlignment: isMineXorReply ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(right: 8.0),
//               child: InkWell(
//                 onTap: () {
//                   print('move user page');
//                 },
//                 child: SizedBox(
//                   // color: Colors.red,
//                   width: isAvatarCondition ? 28 : 35,
//                   height: 28,
//                   child: isAvatarCondition ? _getAvatar(chatMessageModel.avatarUrl) : const SizedBox.shrink(),
//                 ),
//               ),
//             ),
//
//             Expanded(
//               child: Padding(
//                 padding: EdgeInsets.only(right: isMineXorReply && chatMessageModel.isConsecutively ? 8.0 : 0),
//                 // child: _buildMsgWidget(chatMessageModel.msg, chatMessageModel.isRead, isMineXorReply),
//                 child: Column(
//                   children: [
//                     Listener(
//                       onPointerDown: (details) => _lastPointerDownPosition = details.position,
//                       child: Bubble(
//                         color: isMineXorReply ? kPrimaryLightColor : kNeutralColor200,
//                         highlightColor: kNeutralColor400,
//                         onLongPress: () {
//                           if (isRedacted) {
//                             return;
//                           }
//                           if (onLongPress != null) {
//                             onLongPress!(_lastPointerDownPosition);
//                           } else {
//                             _showMenu(context, _lastPointerDownPosition!, isMineXorReply);
//                           }
//                         },
//                         radius: const Radius.circular(10),
//                         borderColor: Colors.transparent,
//                         shadowColor: Colors.transparent,
//                         padding: const BubbleEdges.fromLTRB(12, 8, 12, 8),
//                         alignment: isMineXorReply ? Alignment.topRight : Alignment.topLeft,
//                         nip: chatMessageModel.isConsecutively
//                             ? BubbleNip.no
//                             : isMineXorReply
//                                 ? BubbleNip.rightTop
//                                 : BubbleNip.leftTop,
//                         nipOffset: 16.0,
//                         leftChild: isMineXorReply
//                             ? [
//                                 isError ? _buildErrorArea() : _buildDateTimeArea(chatMessageModel.isRead, chatMessageModel.isEdited, isMineXorReply),
//                                 // _buildErrorArea(),
//                               ]
//                             : [],
//                         rightChild: !isMineXorReply
//                             ? [
//                                 _buildDateTimeArea(chatMessageModel.isRead, chatMessageModel.isEdited, isMineXorReply),
//                               ]
//                             : [],
//                         mainAxisAlignment: isMineXorReply ? MainAxisAlignment.end : MainAxisAlignment.start,
//                         child: Container(
//                           constraints: BoxConstraints(
//                             maxWidth: isMineXorReply ? 0.6.sw : 0.58.sw, // Maximum width for the Bubble widget.
//                           ),
//                           child: _buildMsgArea(chatMessageModel.isReply, msg, isMineXorReply),
//                         ),
//                       ),
//                     ),
//                     hasReaction
//                         ? Padding(
//                             padding: const EdgeInsets.only(top: 2.0, left: 8, right: 8),
//                             child: Align(alignment: isMineXorReply ? Alignment.centerRight : Alignment.centerLeft, child: Text(chatMessageModel.reactions.first)),
//                           )
//                         : const SizedBox.shrink(),
//                   ],
//                 ),
//               ),
//             ),
//
//             // isError ? Text('error') : const SizedBox.shrink(),
//             // isSending ? const CircularProgressIndicator() : const SizedBox.shrink(),
//           ],
//         ),
//       ),
//     );
//   }
// }
