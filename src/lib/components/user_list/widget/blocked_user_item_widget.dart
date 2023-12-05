import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/components/toast/toast.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/block/block_state_provider.dart';

class BlockUserItemWidget extends ConsumerStatefulWidget {
  const BlockUserItemWidget({
    required this.profileImage,
    required this.userName,
    required this.content,
    required this.isSpecialUser,
    required this.memberUuid,
    Key? key,
  }) : super(key: key);

  final String? profileImage;
  final String userName;
  final String content;
  final bool isSpecialUser;
  final String memberUuid;

  @override
  BlockUserItemWidgetState createState() => BlockUserItemWidgetState();
}

class BlockUserItemWidgetState extends ConsumerState<BlockUserItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.0.w, right: 12.w, bottom: 16.h),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  right: 10.w,
                ),
                child: getProfileAvatar(widget.profileImage ?? "", 32.w, 32.h),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      widget.isSpecialUser
                          ? Row(
                              children: [
                                Image.asset(
                                  'assets/image/feed/icon/small_size/icon_special.png',
                                  height: 13.h,
                                ),
                                SizedBox(
                                  width: 4.w,
                                ),
                              ],
                            )
                          : Container(),
                      Text(
                        widget.userName,
                        style: kBody13BoldStyle.copyWith(color: kTextTitleColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    widget.content,
                    style: kBody11RegularStyle.copyWith(color: kTextBodyColor),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () async {
              final result = await ref.read(blockStateProvider.notifier).deleteBlock(
                    blockUuid: widget.memberUuid,
                  );

              if (result.result) {
                if (mounted) {
                  toast(
                    context: context,
                    text: "'${widget.userName.length > 8 ? '${widget.userName.substring(0, 8)}...' : widget.userName}'님을 차단해제하였습니다.",
                    type: ToastType.grey,
                  );
                }
              }
            },
            child: Container(
              width: 56.w,
              height: 32.h,
              decoration: const BoxDecoration(
                color: kPrimaryLightColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
              child: Center(
                child: Text(
                  "차단 해제",
                  style: kButton12BoldStyle.copyWith(color: kPrimaryColor),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
