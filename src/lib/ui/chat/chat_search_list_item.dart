import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';

class ChatSearchListItem extends StatefulWidget {
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
        print('chatMemberId 2 ${widget.chatMemberId}');
        if (widget.onTab != null) {
          widget.onTab!(widget.chatMemberId);
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
                    style: kBody13BoldStyle.copyWith(color: kTextTitleColor, letterSpacing: 0.2, height: 1.4),
                  ),
                  Text(
                    widget.intro,
                    style: kBody11RegularStyle.copyWith(color: kTextBodyColor, letterSpacing: 0.2, height: 1.2),
                  ),
                ],
              ),
            ),
            const Spacer(),
            widget.isFavorite
                ? GestureDetector(
                    onTap: () {
                      if (widget.onTabFavorite != null) {
                        widget.onTabFavorite!();
                      }
                    },
                    child: showFavoriteLottieAnimation
                        ? Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Lottie.asset(
                              'assets/lottie/icon_star.json',
                              controller: favoriteController,
                              onLoaded: (composition) {
                                favoriteController.duration = composition.duration;
                                favoriteController.forward();
                              },
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const Icon(
                              Puppycat_social.icon_star_small_ac,
                              color: kPrimaryColor,
                              size: 20,
                            ),
                          ),
                  )
                : GestureDetector(
                    onTap: () async {
                      if (widget.onTabFavorite != null) {
                        widget.onTabFavorite!();
                      }

                      setState(() {
                        showFavoriteLottieAnimation = true;
                      });

                      favoriteController.forward(from: 0);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(
                        Puppycat_social.icon_star_small_de,
                        color: kTextBodyColor,
                        size: 20,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
