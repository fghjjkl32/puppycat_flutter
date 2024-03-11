import 'package:flutter/material.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';

class ChatSearchListItem extends StatefulWidget {
  final String memberUuid;
  final String nick;
  final String intro;
  final String profileImgUrl;
  final Future<void> Function()? onTab;
  final Function? onTabProfileImg;

  const ChatSearchListItem({
    super.key,
    required this.memberUuid,
    required this.nick,
    required this.intro,
    required this.profileImgUrl,
    this.onTab,
    this.onTabProfileImg,
  });

  @override
  State<ChatSearchListItem> createState() => _ChatSearchListItemState();
}

class _ChatSearchListItemState extends State<ChatSearchListItem> with TickerProviderStateMixin {
  bool showFavoriteLottieAnimation = false;

  late final AnimationController favoriteController;

  @override
  void initState() {
    favoriteController = AnimationController(
      vsync: this,
    );

    super.initState();
  }

  @override
  void dispose() {
    favoriteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.onTab != null) {
          widget.onTab!();
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 7, bottom: 7),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getProfileAvatar(
              widget.profileImgUrl,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.nick,
                    style: kBody13BoldStyle.copyWith(color: kPreviousTextTitleColor, letterSpacing: 0.2, height: 1.4),
                  ),
                  Text(
                    widget.intro,
                    style: kBody11RegularStyle.copyWith(color: kPreviousTextBodyColor, letterSpacing: 0.2, height: 1.2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
