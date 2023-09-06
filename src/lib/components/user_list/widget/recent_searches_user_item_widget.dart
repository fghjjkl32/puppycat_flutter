import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/content_like_user_list/content_like_user_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/search/search_helper_provider.dart';
import 'package:pet_mobile_social_flutter/ui/search/search_screen.dart';
import 'package:widget_mask/widget_mask.dart';
import 'package:pet_mobile_social_flutter/ui/search/search_screen.dart';
import 'package:pet_mobile_social_flutter/services/search/search_db_helper.dart';

class RecentSearchesUserItemWidget extends ConsumerStatefulWidget {
  const RecentSearchesUserItemWidget({
    required this.profileImage,
    required this.userName,
    required this.content,
    required this.isSpecialUser,
    required this.memberIdx,
    required this.search,
    required this.dateTime,
    required this.oldMemberIdx,
    Key? key,
  }) : super(key: key);

  final String? profileImage;
  final String userName;
  final String content;
  final bool isSpecialUser;
  final int memberIdx;
  final Searche search;
  final DateTime dateTime;
  final int oldMemberIdx;
  @override
  RecentSearchesUserItemWidgetState createState() => RecentSearchesUserItemWidgetState();
}

class RecentSearchesUserItemWidgetState extends ConsumerState<RecentSearchesUserItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ref.read(userModelProvider)?.idx == widget.memberIdx
            ? context.push("/home/myPage")
            : context.push("/home/myPage/followList/${widget.memberIdx}/userPage/${widget.userName}/${widget.memberIdx}/${widget.oldMemberIdx}");
      },
      child: Padding(
        padding: EdgeInsets.only(left: 12.0.w, right: 12.w, bottom: 8.h, top: 8.h),
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
            Row(
              children: [
                Text(
                  DateFormat('MM.dd').format(widget.dateTime),
                  style: kBadge10MediumStyle.copyWith(color: kTextBodyColor),
                ),
                SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onTap: () async {
                      final dbHelper = ref.read(dbHelperProvider);
                      // 탭하면 검색 기록을 삭제합니다.
                      await dbHelper.deleteSearch(widget.search);

                      // Refresh the provider to trigger the search again
                      ref.refresh(searchProvider);
                    },
                    child: const Icon(
                      Puppycat_social.icon_close_medium,
                      color: kTextBodyColor,
                      size: 26,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
