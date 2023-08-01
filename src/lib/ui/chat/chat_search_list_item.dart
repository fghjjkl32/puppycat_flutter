import 'package:flutter/material.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';


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
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if(onTab != null) {
          onTab!(chatMemberId);
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getProfileAvatar(profileImgUrl, true),
          Column(
            children: [
              Text(nick),
              Text(intro),
            ],
          ),
          const Spacer(),
          IconButton(icon : const Icon(Icons.star_border), onPressed: () {
            if(onTabFavorite != null) {
              onTabFavorite!();
            }
          },),
        ],
      ),
    );
  }
}
