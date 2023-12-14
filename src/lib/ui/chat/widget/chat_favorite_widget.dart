import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_model.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_favorite_state_provider.dart';

class ChatFavoriteWidget extends ConsumerStatefulWidget {
  const ChatFavoriteWidget({super.key});

  @override
  ChatFavoriteWidgetState createState() => ChatFavoriteWidgetState();
}

class ChatFavoriteWidgetState extends ConsumerState<ChatFavoriteWidget> {
  late PagingController<int, ChatFavoriteModel> _pagingController;

  @override
  void initState() {
    _pagingController = ref.read(chatFavoriteStateProvider);
    _pagingController.refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PagedListView<int, ChatFavoriteModel>(
            scrollDirection: Axis.horizontal,
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<ChatFavoriteModel>(
              noItemsFoundIndicatorBuilder: (context) {
                return const SizedBox.shrink();
              },
              itemBuilder: (context, item, index) {
                return InkWell(
                  onTap: () async {},
                  child: Column(
                    children: [
                      getProfileAvatar(
                        item.profileImgUrl,
                      ),
                      // Stack(
                      //   children: [
                      //     getProfileAvatar(
                      //       item.profileImgUrl,
                      //     ),
                      //     item.isBadge == 1
                      //         ? Positioned(
                      //             top: 1.h,
                      //             right: 1.w,
                      //             child: Image.asset('assets/image/common/icon_special.png', width: 12.w),
                      //           )
                      //         : const SizedBox.shrink(),
                      //   ],
                      // ),
                      const SizedBox(height: 6.0),
                      Text(
                        item.nick,
                        style: kBody11RegularStyle.copyWith(color: kNeutralColor900, height: 1.4, letterSpacing: 0.2),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
