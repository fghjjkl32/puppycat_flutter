import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_model.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_favorite_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_room_list_state_provider.dart';

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
    print('run???????????');
    _pagingController.refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _pagingController = ref.watch(chatFavoriteStateProvider);
    bool isFavoriteListEmpty = ref.watch(chatFavoriteListEmptyProvider);

    print('isFavoriteListEmpty $isFavoriteListEmpty');
    //
    // if (isFavoriteListEmpty) {
    //   return const SizedBox.shrink();
    // }

    // return SizedBox(
    //   height: 120,
    //   child: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Column(
    //       children: [
    //         Expanded(
    //           child: ListView.builder(
    //               shrinkWrap: true,
    //               itemCount: 5,
    //               scrollDirection: Axis.horizontal,
    //               itemBuilder: (context, index) {
    //                 return Text('data $index');
    //               }),
    //         ),
    //       ],
    //     ),
    //   ),
    // );

    return Column(
      children: [
        SizedBox(
          // color: Colors.blue,
          height: isFavoriteListEmpty ? 0 : 120,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                  child: Text(
                    '메시지.즐겨찾기'.tr(),
                    style: kBody14BoldStyle.copyWith(color: kPreviousTextTitleColor, height: 1.2),
                  ),
                ),
              ),
              SizedBox(
                height: 72,
                child: PagedListView<int, ChatFavoriteModel>.separated(
                  // shrinkWrap: true,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      width: 4.0,
                    );
                  },
                  scrollDirection: Axis.horizontal,
                  pagingController: _pagingController,
                  padding: const EdgeInsets.fromLTRB(6.0, 2.0, 6.0, 2.0),
                  builderDelegate: PagedChildBuilderDelegate<ChatFavoriteModel>(
                    firstPageErrorIndicatorBuilder: (context) {
                      // setState(() {
                      //   isFavoriteListEmpty = true;
                      // });
                      ref.read(chatFavoriteListEmptyProvider.notifier).state = true;
                      return const SizedBox.shrink();
                    },
                    noItemsFoundIndicatorBuilder: (context) {
                      // setState(() {
                      //   isFavoriteListEmpty = true;
                      // });
                      ref.read(chatFavoriteListEmptyProvider.notifier).state = true;
                      return const SizedBox.shrink();
                    },
                    itemBuilder: (context, item, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: InkWell(
                          onTap: () async {
                            await ref
                                .read(chatRoomListStateProvider.notifier)
                                .enterChatRoom(
                                  targetMemberUuid: item.targetMemberUuid,
                                  titleName: item.nick,
                                  targetProfileImgUrl: item.profileImgUrl,
                                )
                                .then((value) => ref.read(chatRoomListStateProvider).refresh());
                          },
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
                              Text(
                                item.nick,
                                style: kBody11RegularStyle.copyWith(
                                  color: kNeutralColor900,
                                  height: 1.4,
                                  letterSpacing: 0.2,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        isFavoriteListEmpty
            ? const SizedBox.shrink()
            : SizedBox(
                width: double.infinity,
                height: 18,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[kPreviousNeutralColor200, kPreviousNeutralColor100],
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
