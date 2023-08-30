import 'package:flutter/material.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';

class ChatSearchListItem extends StatelessWidget {
  final int idx;
  final String nick;
  final String intro;
  final bool isFavorite;
  final String profileImgUrl;
  final String chatMemberId;
  final String chatHomeServer;
  final Function? onTab;
  final Function? onTabFavorite;
  final Function? onTabProfileImg;
  final String tempIdx;

  const ChatSearchListItem({
    super.key,
    required this.idx,
    required this.nick,
    required this.intro,
    required this.isFavorite,
    required this.profileImgUrl,
    required this.chatMemberId,
    required this.chatHomeServer,
    this.onTab,
    this.onTabFavorite,
    this.onTabProfileImg,
    required this.tempIdx,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('chatMemberId 2 $chatMemberId');
        if (onTab != null) {
          onTab!(chatMemberId);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 7, bottom: 7),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getProfileAvatar(
              profileImgUrl,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nick,
                    style: kBody13BoldStyle.copyWith(
                        color: kTextTitleColor,
                        letterSpacing: 0.2,
                        height: 1.4),
                  ),
                  Text(
                    intro,
                    style: kBody11RegularStyle.copyWith(
                        color: kTextBodyColor, letterSpacing: 0.2, height: 1.2),
                  ),
                ],
              ),
            ),
            const Spacer(),
            IconButton(
              padding: const EdgeInsets.all(0),
              alignment: Alignment.centerRight,
              icon: isFavorite
                  ? const ImageIcon(
                      AssetImage('assets/image/chat/icon_star_s_on.png'),
                      size: 20,
                      color: kPrimaryColor,
                    )
                  : const ImageIcon(
                      AssetImage('assets/image/chat/icon_star_s_off.png'),
                      size: 20,
                      color: kTextBodyColor,
                    ),
              onPressed: () {
                if (onTabFavorite != null) {
                  onTabFavorite!();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
