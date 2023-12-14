import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/search/search_helper_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:pet_mobile_social_flutter/services/search/search_db_helper.dart';
import 'package:pet_mobile_social_flutter/ui/search/search_screen.dart';

class RecentSearchesUserItemWidget extends ConsumerStatefulWidget {
  const RecentSearchesUserItemWidget({
    required this.profileImage,
    required this.userName,
    required this.content,
    required this.isSpecialUser,
    required this.memberUuid,
    required this.search,
    required this.dateTime,
    required this.oldMemberUuid,
    Key? key,
  }) : super(key: key);

  final String? profileImage;
  final String userName;
  final String content;
  final bool isSpecialUser;
  final String memberUuid;
  final Searche search;
  final DateTime dateTime;
  final String oldMemberUuid;

  @override
  RecentSearchesUserItemWidgetState createState() => RecentSearchesUserItemWidgetState();
}

class RecentSearchesUserItemWidgetState extends ConsumerState<RecentSearchesUserItemWidget> {
  @override
  Widget build(BuildContext context) {
    final myInfo = ref.read(myInfoStateProvider);
    final isLogined = ref.read(loginStatementProvider);

    return InkWell(
      onTap: () {
        myInfo.uuid == widget.memberUuid
            ? context.push("/home/myPage")
            : context.push("/home/myPage/followList/${widget.memberUuid}/userPage/${widget.userName}/${widget.memberUuid}/${widget.memberUuid}");
        //TODO
        //Route 다시
      },
      child: Padding(
        padding: EdgeInsets.only(left: 12.0.w, right: 12.w, bottom: 8.h, top: 8.h),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      right: 10.w,
                    ),
                    child: getProfileAvatar(widget.profileImage ?? "", 32.w, 32.h),
                  ),
                  Expanded(
                    child: Column(
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
                            Flexible(
                              child: Text(
                                widget.userName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: kBody13BoldStyle.copyWith(color: kPreviousTextTitleColor),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Text(
                          widget.content,
                          style: kBody11RegularStyle.copyWith(color: kPreviousTextBodyColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  DateFormat('MM.dd').format(widget.dateTime),
                  style: kBadge10MediumStyle.copyWith(color: kPreviousTextBodyColor),
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
                      color: kPreviousTextBodyColor,
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
