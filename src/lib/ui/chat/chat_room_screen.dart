import 'dart:math';

import 'package:bubble/bubble.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/theme_data.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_msg_model.dart';
import 'package:pet_mobile_social_flutter/ui/chat/chat_msg_item.dart';
import 'package:widget_mask/widget_mask.dart';

class ChatRoomScreen2 extends ConsumerWidget {
  final String titleNick;
  final List<ChatMessageModel> msgList;

  ChatRoomScreen2({
    Key? key,
    required this.titleNick,
    required this.msgList,
  }) : super(key: key);

  final TextEditingController _inputTextController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Material(
        child: Theme(
          data: themeData(context).copyWith(
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
            ),
          ),
          child: Scaffold(
            body: Scaffold(
              appBar: AppBar(
                title: Text(titleNick),
                backgroundColor: kNeutralColor100,
              ),
              extendBody: true,
              resizeToAvoidBottomInset: false,
              bottomNavigationBar: false ? null : Padding(
                padding: EdgeInsets.only(top: 7.0.h),
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.white,
                            blurRadius: 18.0,
                            spreadRadius: 35,
                            offset: Offset(0.0, 20.h)
                        )
                      ],
                      color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(12.0.w, 0.0.h, 12.0.w, 24.0.h),
                    child: TextField(
                      controller: _inputTextController,
                      decoration: InputDecoration(
                        hintText: '메시지.메시지를 입력해 주세요'.tr(),
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(left: 24.0.w),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.send_outlined,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(14.0.w, 4.0.h, 14.0.w, 4.0.h),
                  child: ListView.builder(
                    physics:  const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: msgList.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      return ChatMessageItem(chatMessageModel: msgList[index]);
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
