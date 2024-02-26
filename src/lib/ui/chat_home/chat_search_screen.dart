import 'dart:async';

import 'package:easy_debounce/easy_throttle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_model.dart';
import 'package:pet_mobile_social_flutter/models/follow/follow_data.dart';
import 'package:pet_mobile_social_flutter/models/search/search_data.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_favorite_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_follow_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_room_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_search_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/follow/follow_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/chat_home/chat_search_list_item.dart';

class ChatSearchScreen extends ConsumerStatefulWidget {
  const ChatSearchScreen({super.key});

  @override
  ChatSearchScreenState createState() => ChatSearchScreenState();
}

class ChatSearchScreenState extends ConsumerState<ChatSearchScreen> {
  final TextEditingController searchController = TextEditingController();
  int followOldLength = 0;
  int searchOldLength = 0;
  Timer? _searchDebounceTimer;

  // String _searchWord = '';
  bool _isFavoriteExpanded = true;
  bool _isFollowExpanded = true;

  late PagingController<int, SearchData> _searchPagingController; // = PagingController(firstPageKey: 1);
  late PagingController<int, FollowData> _followListPagingController;
  late PagingController<int, ChatFavoriteModel> _favoriteListPagingController;

  @override
  void initState() {
    _searchPagingController = ref.read(chatUserSearchStateProvider);
    _followListPagingController = ref.read(chatFollowUserStateProvider);
    _favoriteListPagingController = ref.read(chatFavoriteStateProvider);

    ref.read(followStateProvider.notifier).initFollowList(memberUuid: ref.read(myInfoStateProvider).uuid ?? '');
    super.initState();

    _searchPagingController.refresh();
    _favoriteListPagingController.refresh();
    _followListPagingController.refresh();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _onTabListItem({
    required String targetMemberUuid,
    required String titleName,
    required String targetProfileImgUrl,
  }) async {
    print('targetMemberUuid $targetMemberUuid / titleName $titleName / targetProfileImgUrl $targetProfileImgUrl');
    EasyThrottle.throttle(
      'elevatedButtonThrottle',
      const Duration(
        milliseconds: 2500,
      ),
      () async {
        await ref
            .read(chatRoomListStateProvider.notifier)
            .enterChatRoom(
              targetMemberUuid: targetMemberUuid,
              titleName: titleName,
              targetProfileImgUrl: targetProfileImgUrl,
            )
            .then((value) => ref.read(chatRoomListStateProvider).refresh());
      },
    );
  }

  Widget _buildNoItemsFound(String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 140.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/image/chat/character_01_nopost_88_x2.png',
              width: 88,
              height: 88,
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor, height: 1.4, letterSpacing: 0.2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Expanded(
      child: PagedListView<int, SearchData>(
        pagingController: _searchPagingController,
        builderDelegate: PagedChildBuilderDelegate<SearchData>(
          noItemsFoundIndicatorBuilder: (context) {
            print('searchController.text.isEmpty ${searchController.text}');
            // if (searchController.text.isNotEmpty || searchController.text != '') {
            return _buildNoItemsFound('유저를 찾을 수 없습니다'.tr());
            // } else {
            //   return _buildPrevSearch();
            // }
          },
          itemBuilder: (context, item, index) {
            return ChatSearchListItem(
              memberUuid: item.memberUuid ?? 'unknown',
              nick: item.nick ?? 'unknown',
              intro: item.intro ?? '',
              profileImgUrl: item.profileImgUrl ?? '',
              onTab: () => _onTabListItem(
                targetMemberUuid: item.memberUuid ?? '',
                titleName: item.nick ?? 'unknown',
                targetProfileImgUrl: item.profileImgUrl ?? '',
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFavoriteUsers() {
    return PagedSliverList<int, ChatFavoriteModel>(
      // shrinkWrap: true,
      shrinkWrapFirstPageIndicators: true,
      pagingController: _favoriteListPagingController,
      // physics: const NeverScrollableScrollPhysics(),
      builderDelegate: PagedChildBuilderDelegate<ChatFavoriteModel>(
        noItemsFoundIndicatorBuilder: (context) {
          return const SizedBox.shrink();
        },
        itemBuilder: (context, item, index) {
          return ChatSearchListItem(
            memberUuid: item.targetMemberUuid ?? '',
            nick: item.nick ?? 'unknown',
            intro: '',
            //TODO
            profileImgUrl: item.profileImgUrl ?? '',
            onTab: () => _onTabListItem(
              targetMemberUuid: item.targetMemberUuid ?? '',
              titleName: item.nick ?? 'unknown',
              targetProfileImgUrl: item.profileImgUrl ?? '',
            ),
          );
        },
      ),
    );
  }

  Widget _buildFollowUsers() {
    return PagedSliverList<int, FollowData>(
      // shrinkWrap: true,
      shrinkWrapFirstPageIndicators: true,
      pagingController: _followListPagingController,
      builderDelegate: PagedChildBuilderDelegate<FollowData>(
        noItemsFoundIndicatorBuilder: (context) {
          return const SizedBox.shrink();
        },
        itemBuilder: (context, item, index) {
          return ChatSearchListItem(
            memberUuid: item.followUuid ?? '',
            nick: item.followNick ?? 'unknown',
            intro: item.intro ?? '',
            profileImgUrl: item.profileImgUrl ?? '',
            onTab: () => _onTabListItem(
              targetMemberUuid: item.followUuid ?? '',
              titleName: item.followNick ?? 'unknown',
              targetProfileImgUrl: item.profileImgUrl ?? '',
            ),
          );
        },
      ),
    );
  }

  ///NOTE
  ///ExpansionTile 사용하려고 했지만 height 이슈로 ListTile 사용
  Widget _buildPrevSearch() {
    bool isFavoriteEmpty = ref.watch(chatFavoriteListEmptyProvider);
    bool isFollowEmpty = ref.watch(chatFollowListEmptyProvider);
    bool isViewEmptyPage = isFavoriteEmpty && isFollowEmpty;

    return isViewEmptyPage
        ? Builder(builder: (context) {
            ref.read(chatFollowUserStateProvider).notifyPageRequestListeners(1);
            return _buildNoItemsFound('메시지.검색해서 메시지 전송 상대를 찾아보세요'.tr());
          })
        : CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: ListTile(
                  dense: true,
                  minVerticalPadding: 0,
                  visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                  title: Text(
                    '메시지.즐겨찾기'.tr(),
                    style: kTitle16ExtraBoldStyle.copyWith(color: kPreviousTextTitleColor, height: 1.2),
                  ),
                  onTap: () {
                    setState(() {
                      _isFavoriteExpanded = !_isFavoriteExpanded;
                    });
                  },
                  contentPadding: const EdgeInsets.all(0),
                  trailing: _isFavoriteExpanded
                      ? const ImageIcon(
                          AssetImage('assets/image/chat/icon_up.png'),
                          size: 20,
                        )
                      : const ImageIcon(
                          AssetImage('assets/image/chat/icon_down.png'),
                          size: 20,
                        ),
                ),
              ),
              if (_isFavoriteExpanded) _buildFavoriteUsers(),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Divider(
                    height: 1,
                    color: kNeutralColor300,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ListTile(
                  dense: true,
                  minVerticalPadding: 0,
                  visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                  title: Text(
                    '팔로잉'.tr(),
                    style: kTitle16ExtraBoldStyle.copyWith(color: kPreviousTextTitleColor, height: 1.2),
                  ),
                  onTap: () {
                    setState(() {
                      _isFollowExpanded = !_isFollowExpanded;
                    });
                  },
                  contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                  trailing: _isFollowExpanded
                      ? const ImageIcon(
                          AssetImage('assets/image/chat/icon_up.png'),
                          size: 20,
                        )
                      : const ImageIcon(
                          AssetImage('assets/image/chat/icon_down.png'),
                          size: 20,
                        ),
                ),
              ),
              if (_isFollowExpanded) _buildFollowUsers(),
            ],
          );
  }

  void _search(String keyword) {
    if (keyword.isEmpty || keyword == '') {
      // _searchWord = '';
      setState(() {
        ///NOTE
        /// UI 업데이트용
      });
      return;
    }

    if (_searchDebounceTimer?.isActive ?? false) {
      _searchDebounceTimer?.cancel();
    }
    // _searchWord = keyword;
    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      setState(() {});
      ref.read(chatUserSearchStateProvider.notifier).searchUser(keyword);
    });
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: FormBuilderTextField(
              name: 'chatFavorite',
              controller: searchController,
              onChanged: (value) {
                _search(searchController.text);
              },
              style: kBody13RegularStyle.copyWith(color: kPreviousTextSubTitleColor),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                filled: true,
                fillColor: kNeutralColor200,
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(100.0),
                  gapPadding: 10.0,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(100.0),
                  gapPadding: 10.0,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(100.0),
                  gapPadding: 10.0,
                ),
                suffixIconConstraints: const BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                ),
                // ignore: invalid_use_of_protected_member
                suffixIcon: searchController.text.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: ImageIcon(
                          AssetImage('assets/image/chat/icon_search_medium.png'),
                          size: 20,
                          color: kPreviousTextTitleColor,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            searchController.text = '';
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: ImageIcon(
                            AssetImage('assets/image/chat/icon_close_large.png'),
                            size: 20,
                            color: kPreviousTextTitleColor,
                          ),
                        ),
                      ),
                hintText: "메시지.닉네임을 검색해주세요".tr(),
                hintStyle: kBody14RegularStyle.copyWith(color: kTextTertiary),
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          searchController.text.isEmpty
              ? Expanded(
                  child: _buildPrevSearch(),
                )
              : _buildSearch(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
            "메시지.메시지 상대 선택".tr(),
          ),
          leading: IconButton(
            onPressed: () {
              ref.read(chatUserSearchStateProvider.notifier).searchUser('');
              context.pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: _buildBody(),
      ),
    );
  }
}
