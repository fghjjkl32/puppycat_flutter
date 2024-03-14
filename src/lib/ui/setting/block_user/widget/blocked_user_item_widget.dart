import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/block/block_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/components/toast/toast.dart';

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
      padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 10,
                ),
                child: getProfileAvatar(widget.profileImage ?? "", 40, 40),
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
                                  height: 13,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                              ],
                            )
                          : Container(),
                      Text(
                        widget.userName,
                        style: kBody13BoldStyle.copyWith(color: kPreviousTextTitleColor),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    widget.content,
                    style: kBody11RegularStyle.copyWith(color: kPreviousTextBodyColor),
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
                    text: "설정.차단을 풀었어요".tr(args: [(widget.userName.length > 8 ? '${widget.userName.substring(0, 8)}...' : widget.userName)]),
                    type: ToastType.grey,
                  );
                }
              }
            },
            child: Container(
              width: 74,
              height: 32,
              decoration: const BoxDecoration(
                color: kBackgroundSecondary,
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
              child: Center(
                child: Text(
                  "설정.차단 풀기".tr(),
                  style: kButton14MediumStyle.copyWith(color: kTextSecondary),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
