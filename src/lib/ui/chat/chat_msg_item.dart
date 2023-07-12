import 'dart:math';

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_msg_model.dart';
import 'package:widget_mask/widget_mask.dart';

class ChatMessageItem extends ConsumerWidget {
  final ChatMessageModel chatMessageModel;

  const ChatMessageItem({
    Key? key,
    required this.chatMessageModel,
  }) : super(key: key);

  Widget _getAvatar(String avatarUrl) {
    return WidgetMask(
      blendMode: BlendMode.srcATop,
      childSaveLayer: true,
      mask: Center(
        child: Image.network(
          avatarUrl != '' ? avatarUrl : 'https://via.placeholder.com/150/f66b97',
          // width: 42.w,
          height: 41.h,
          fit: BoxFit.fill,
        ),
      ),
      child: SvgPicture.asset(
        'assets/image/feed/image/squircle.svg',
        width: 41.w,
        height: 41.h,
        fit: BoxFit.fill,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isMine = chatMessageModel.isMine;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _getAvatar(chatMessageModel.avatarUrl),
        Bubble(
          color: isMine ? kPrimaryLightColor : kNeutralColor200,
          borderColor: Colors.transparent,
          shadowColor: Colors.transparent,
          margin: BubbleEdges.only(top: 4.h),
          alignment: isMine ? Alignment.topRight : Alignment.topLeft,
          nip: BubbleNip.values[Random().nextInt(6)],//BubbleNip.leftBottom,
          child: Text(chatMessageModel.msg),
        ),
      ],
    );
  }
}
