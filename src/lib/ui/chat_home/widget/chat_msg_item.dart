import 'dart:math';

import 'package:bubble/bubble.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/util/extensions/date_time_extension.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_msg_model.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_msg_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/chat_home/widget/chat_bubble_widget.dart';

enum ContextMenuType {
  reply,
  edit,
  copy,
  delete,
  reaction,
  resend,
  report,
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
  final void Function(ChatMessageModel)? onReport;
  final bool isError;
  final bool isSending;
  final bool isRedacted;
  final String redactedMsg;
  final double bottomPadding;
  final void Function(ChatMessageModel)? onMoveReply;

  const ChatMessageItem({
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
    this.onReport,
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

class ChatMessageItemState extends ConsumerState<ChatMessageItem> with SingleTickerProviderStateMixin {
  Offset? _lastPointerDownPosition;
  late ChatMessageModel chatMessageModel;
  bool isMine = false;
  bool isMineXorReply = false;
  bool isAvatarCondition = false;
  bool hasReaction = false;
  String msg = '';
  Color _bubbleColor = kNeutralColor200;
  late final AnimationController _animationController;

  // bool isHighLight = false;

  @override
  void initState() {
    _updateData();

    // print('$isMine / $isMineXorReply / $isAvatarCondition / $hasReaction / $msg');

    // _bubbleColor = isMineXorReply ? kPrimaryLightColor : kNeutralColor200;
    _updateBubbleColor(false);
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    // _animationController.stop();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
        _bubbleColor = isHighLight ? kPrimaryColor400 : kPreviousPrimaryLightColor;
      } else {
        _bubbleColor = isHighLight ? kNeutralColor400 : kNeutralColor200;
      }
    });
  }

  ///NOTE
  ///GPT Code
  void _showMenu(BuildContext context, Offset position, bool isMine) {
    final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final screenHeight = overlay.size.height;

    List<PopupMenuEntry<ContextMenuType>> menuItems = [];
    // menuItems.add(
    //   PopupMenuItem<ContextMenuType>(
    //     value: ContextMenuType.reply,
    //     child: SizedBox(
    //       width: 212,
    //       child: Row(
    //         children: [
    //           Text(
    //             '메시지.답장'.tr(),
    //             style: kBody12SemiBoldStyle.copyWith(color: kPreviousTextSubTitleColor),
    //           ),
    //           const Spacer(),
    //           Image.asset(
    //             'assets/image/chat/icon_re-comment.png',
    //             color: kPreviousTextSubTitleColor,
    //             width: 20,
    //             height: 20,
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // ); //reply
    // if (isMine) {
    //   menuItems.add(
    //     PopupMenuItem<ContextMenuType>(
    //       value: ContextMenuType.edit,
    //       child: SizedBox(
    //         width: 212,
    //         child: Row(
    //           children: [
    //             Text(
    //               '메시지.수정'.tr(),
    //               style: kBody12SemiBoldStyle.copyWith(color: kPreviousTextSubTitleColor),
    //             ),
    //             const Spacer(),
    //             Image.asset(
    //               'assets/image/chat/icon_modify.png',
    //               color: kPreviousTextSubTitleColor,
    //               width: 20,
    //               height: 20,
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ); //edit
    // }
    menuItems.add(
      PopupMenuItem<ContextMenuType>(
        value: ContextMenuType.copy,
        child: Row(
          children: [
            Text(
              '메시지.복사'.tr(),
              style: kBody12SemiBoldStyle.copyWith(color: kPreviousTextSubTitleColor),
            ),
            const Spacer(),
            Image.asset(
              'assets/image/chat/icon_copy.png',
              color: kPreviousTextSubTitleColor,
              width: 20,
              height: 20,
            ),
          ],
        ),
      ),
    ); //copy
    if (!isMine) {
      menuItems.add(
        PopupMenuItem<ContextMenuType>(
          value: ContextMenuType.report,
          child: Row(
            children: [
              Text(
                '메시지.신고'.tr(),
                style: kBody12SemiBoldStyle.copyWith(color: kErrorColor400),
              ),
              const Spacer(),
              Image.asset(
                'assets/image/chat/icon_report.png',
                color: kErrorColor400,
                width: 20,
                height: 20,
              ),
            ],
          ),
        ),
      ); //report
    }
    // menuItems.add(
    //   PopupMenuItem<ContextMenuType>(
    //     value: ContextMenuType.delete,
    //     child: SizedBox(
    //       width: 212,
    //       child: Row(
    //         children: [
    //           Text(
    //             '메시지.삭제'.tr(),
    //             style: kBody12SemiBoldStyle.copyWith(color: kErrorColor400),
    //           ),
    //           const Spacer(),
    //           Image.asset(
    //             'assets/image/chat/icon_delete_s.png',
    //             color: kErrorColor400,
    //             width: 20,
    //             height: 20,
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // ); //delete
    // menuItems.add(
    //   PopupMenuItem<ContextMenuType>(
    //     value: ContextMenuType.reaction,
    //     child: SizedBox(
    //       width: 212,
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           const Divider(),
    //           Padding(
    //             padding: const EdgeInsets.only(top: 8.0),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 InkWell(
    //                   child: Lottie.asset(
    //                     'assets/lottie/character_05_1_Good_24.json',
    //                     repeat: false,
    //                   ),
    //                   onTap: () {
    //                     _reaction('assets/lottie/character_05_1_Good_24.json');
    //                     Navigator.pop(context);
    //                   },
    //                 ),
    //                 InkWell(
    //                   child: Lottie.asset(
    //                     'assets/lottie/character_05_2_like_24.json',
    //                     repeat: false,
    //                   ),
    //                   onTap: () {
    //                     _reaction('assets/lottie/character_05_2_like_24.json');
    //                     Navigator.pop(context);
    //                   },
    //                 ),
    //                 InkWell(
    //                   child: Lottie.asset(
    //                     'assets/lottie/character_05_3_dislike_24.json',
    //                     repeat: false,
    //                   ),
    //                   onTap: () {
    //                     _reaction('assets/lottie/character_05_3_dislike_24.json');
    //                     Navigator.pop(context);
    //                   },
    //                 ),
    //                 InkWell(
    //                   child: Lottie.asset(
    //                     'assets/lottie/character_05_4_laugh_24.json',
    //                     repeat: false,
    //                   ),
    //                   onTap: () {
    //                     _reaction('assets/lottie/character_05_4_laugh_24.json');
    //                     Navigator.pop(context);
    //                   },
    //                 ),
    //                 InkWell(
    //                   child: Lottie.asset(
    //                     'assets/lottie/character_05_5_sad_24.json',
    //                     repeat: false,
    //                   ),
    //                   onTap: () {
    //                     _reaction('assets/lottie/character_05_5_sad_24.json');
    //                     Navigator.pop(context);
    //                   },
    //                 ),
    //                 InkWell(
    //                   child: Lottie.asset(
    //                     'assets/lottie/character_05_6_angry_24.json',
    //                     repeat: false,
    //                   ),
    //                   onTap: () {
    //                     _reaction('assets/lottie/character_05_6_angry_24.json');
    //                     Navigator.pop(context);
    //                   },
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // ); //reactions

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
        case ContextMenuType.report:
          _report();
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

  void _report() {
    if (widget.onReport != null) {
      widget.onReport!(chatMessageModel);
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
      detectedStyle: kBody13RegularStyle.copyWith(color: kSecondaryColor500),
      basicStyle: kBody13RegularStyle.copyWith(color: widget.isRedacted ? kPreviousTextBodyColor : kPreviousTextSubTitleColor),
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
                  widget.onMoveReply!(chatMessageModel);
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${chatMessageModel.replyTargetNick}${'메시지.님에게 답장'.tr()}\n${chatMessageModel.replyTargetMsg}',
                    style: kBody11RegularStyle.copyWith(color: kPreviousTextBodyColor),
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

    final dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(chatMessageModel.dateTime) * 1000);

    if (isMine && widget.isSending) {
      return const SpinKitCircle(
        size: 10,
        color: kNeutralColor500,
      );
    }

    if (isMine) {
      rows = Row(
        children: [
          ///TODO
          ///읽음,안읽음 처리
          // isMine
          //     ? isRead
          //         ? const ImageIcon(
          //             AssetImage('assets/image/chat/icon_check_pair.png'),
          //             // size: 10.w,
          //             color: kNeutralColor500,
          //           )
          //         : const ImageIcon(
          //             AssetImage('assets/image/chat/icon_check_single.png'),
          //             // size: 10.w,
          //             color: kNeutralColor500,
          //           )
          //     : const SizedBox.shrink(),
          chatMessageModel.isViewTime
              ? Text(
                  dateTime.timeOfDay(),
                  style: kBadge10MediumStyle.copyWith(color: kNeutralColor500),
                )
              : const SizedBox.shrink(),
          // Text(
          //   DateTime.parse(chatMessageModel.dateTime).timeOfDay(),
          //   style: kBadge10MediumStyle.copyWith(color: kNeutralColor500),
          // ),
          // const SizedBox(
          //   width: 4,
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
          // const SizedBox(
          //   width: 4,
          // ),
          chatMessageModel.isViewTime
              ? Text(
                  dateTime.timeOfDay(),
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
        color: kErrorColor400,
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
              padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
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

  Widget _buildProfile() {
    if (isMineXorReply) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: InkWell(
        onTap: () {
          print('move user page');
        },
        child: SizedBox(
          // color: Colors.red,
          width: 28,
          height: 28,
          child: isAvatarCondition ? getProfileAvatar(chatMessageModel.avatarUrl) : const SizedBox.shrink(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isBigDevice = MediaQuery.of(context).size.width >= 345;
    _updateData();

    ref.listen(chatBubbleFocusProvider, (previous, next) {
      if (next == null) {
        return;
      }
      if (next != chatMessageModel.idx) {
        return;
      }
      if (next == 0) {
        return;
      }

      if (_animationController.isCompleted) {
        _animationController.reset();
      }

      _animationController.forward();
      ref.read(chatBubbleFocusProvider.notifier).state = 0;
    });

    return Listener(
      onPointerDown: (details) => _lastPointerDownPosition = details.position,
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          ChatBubbleWidget(
            color: _bubbleColor,
            onHighlightChanged: (_) {
              // _updateBubbleColor(true);
            },
            onDoubleTap: () => _reaction('assets/lottie/character_05_1_Good_24.json'),
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
            nipWidth: 6,
            // radius: const Radius.circular(10),
            borderRadius: 10.0,
            borderColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const BubbleEdges.fromLTRB(12, 8, 12, 8),
            // alignment: isMineXorReply ? Alignment.topRight : Alignment.topLeft,
            nip: isMineXorReply ? BubbleNip.rightTop : BubbleNip.leftTop,
            showNip: !chatMessageModel.isConsecutively,
            nipOffset: 16.0,
            chatBubbleAlignment: isMineXorReply ? ChatBubbleAlignment.right : ChatBubbleAlignment.left,
            sideWidget: _buildDateTimeArea(chatMessageModel.isRead, chatMessageModel.isEdited, isMineXorReply),
            child: _buildMsgArea(chatMessageModel.isReply, msg, isMineXorReply),
          ),
          hasReaction
              ? Padding(
                  padding: const EdgeInsets.only(top: 2.0, left: 8, right: 8),
                  child: Align(
                      alignment: isMineXorReply ? Alignment.centerRight : Alignment.centerLeft,
                      child: Lottie.asset(
                        chatMessageModel.reactions.first,
                        repeat: false,
                      )),
                )
              : const SizedBox.shrink(),
        ],
      ),
      // ),
    ).animate(autoPlay: false, controller: _animationController).shakeY();
  }
}
