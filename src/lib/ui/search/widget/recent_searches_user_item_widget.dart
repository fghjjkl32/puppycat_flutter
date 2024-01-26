import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        myInfo.uuid == widget.memberUuid ? context.push("/member/myPage") : context.push("/member/userPage/${widget.userName}/${widget.memberUuid}/${widget.memberUuid}");
        //TODO
        //Route 다시
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 8, top: 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 10,
                    ),
                    child: getProfileAvatar(widget.profileImage ?? "", 36, 36),
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
                                        height: 13,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                    ],
                                  )
                                : Container(),
                            Flexible(
                              child: Text(
                                widget.userName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: kBody14BoldStyle.copyWith(color: kPreviousTextTitleColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          widget.content,
                          style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
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
                const SizedBox(
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
