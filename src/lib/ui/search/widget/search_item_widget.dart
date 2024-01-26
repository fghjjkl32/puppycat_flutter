import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/search/search_helper_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:pet_mobile_social_flutter/services/search/search_db_helper.dart';
import 'package:pet_mobile_social_flutter/ui/search/search_screen.dart';

class SearchItemWidget extends ConsumerStatefulWidget {
  const SearchItemWidget({
    required this.profileImage,
    required this.userName,
    required this.content,
    required this.isSpecialUser,
    required this.memberUuid,
    required this.contentType,
    required this.oldMemberUuid,
    Key? key,
  }) : super(key: key);

  final String? profileImage;
  final String userName;
  final String content;
  final bool isSpecialUser;
  final String memberUuid;
  final String contentType;
  final String oldMemberUuid;

  @override
  UserItemWidgetState createState() => UserItemWidgetState();
}

class UserItemWidgetState extends ConsumerState<SearchItemWidget> {
  @override
  Widget build(BuildContext context) {
    final myInfo = ref.read(myInfoStateProvider);
    final isLogined = ref.read(loginStatementProvider);
    return InkWell(
      onTap: () async {
        final dbHelper = ref.read(dbHelperProvider);
        final profile = SearchesCompanion(
          name: Value(widget.userName),
          content: Value(widget.contentType),
          contentId: Value(widget.memberUuid),
          image: Value(widget.profileImage),
          intro: Value(widget.content),
          isBadge: Value(widget.isSpecialUser),
          created: Value(DateTime.now()),
        );

        // 검색어를 저장합니다.
        await dbHelper.insertSearch(profile);

        ref.refresh(searchProvider);

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
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 10,
                  ),
                  child: getProfileAvatar(widget.profileImage ?? "", 36, 36),
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
                          style: kBody14BoldStyle.copyWith(color: kPreviousTextTitleColor),
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
          ],
        ),
      ),
    );
  }
}
