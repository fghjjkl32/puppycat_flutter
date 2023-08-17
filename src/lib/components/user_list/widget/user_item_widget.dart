import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/feed_detail_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/content_like_user_list/content_like_user_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/search/search_helper_provider.dart';
import 'package:pet_mobile_social_flutter/services/search/search_db_helper.dart';
import 'package:pet_mobile_social_flutter/ui/search/search_screen.dart';
import 'package:widget_mask/widget_mask.dart';

class UserItemWidget extends ConsumerStatefulWidget {
  const UserItemWidget({
    required this.profileImage,
    required this.userName,
    required this.content,
    required this.isSpecialUser,
    required this.memberIdx,
    required this.contentType,
    Key? key,
  }) : super(key: key);

  final String? profileImage;
  final String userName;
  final String content;
  final bool isSpecialUser;
  final int memberIdx;
  final String contentType;
  @override
  UserItemWidgetState createState() => UserItemWidgetState();
}

class UserItemWidgetState extends ConsumerState<UserItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final dbHelper = ref.read(dbHelperProvider);
        final profile = SearchesCompanion(
          name: Value(widget.userName),
          content: Value(widget.contentType),
          contentId: Value(widget.memberIdx),
          image: Value(widget.profileImage),
          intro: Value(widget.content),
          isBadge: Value(widget.isSpecialUser),
          created: Value(DateTime.now()),
        );

        // 검색어를 저장합니다.
        await dbHelper.insertSearch(profile);

        ref.refresh(searchProvider);

        context.push(
            "/home/myPage/followList/${widget.memberIdx}/userPage/${widget.userName}/${widget.memberIdx}");
      },
      child: Padding(
        padding:
            EdgeInsets.only(left: 12.0.w, right: 12.w, bottom: 8.h, top: 8.h),
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
                  child: widget.profileImage == null
                      ? WidgetMask(
                          blendMode: BlendMode.srcATop,
                          childSaveLayer: true,
                          mask: Center(
                            child: Image.asset(
                              'assets/image/feed/icon/large_size/icon_taguser.png',
                              height: 32.h,
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: SvgPicture.asset(
                            'assets/image/feed/image/squircle.svg',
                            height: 32.h,
                          ),
                        )
                      : WidgetMask(
                          blendMode: BlendMode.srcATop,
                          childSaveLayer: true,
                          mask: Center(
                            child: Image.asset(
                              widget.profileImage!,
                              height: 32.h,
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: SvgPicture.asset(
                            'assets/image/feed/image/squircle.svg',
                            height: 32.h,
                            fit: BoxFit.fill,
                          ),
                        ),
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
                          style:
                              kBody13BoldStyle.copyWith(color: kTextTitleColor),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Text(
                      widget.content,
                      style:
                          kBody11RegularStyle.copyWith(color: kTextBodyColor),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
