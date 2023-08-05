import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/components/user_list/widget/follower_item_widget.dart';
import 'package:pet_mobile_social_flutter/components/user_list/widget/following_item_widget.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_model.dart';
import 'package:pet_mobile_social_flutter/models/search/search_data.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_favorite_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_search_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/follow/follow_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/search/search_state_notifier.dart';
import 'package:pet_mobile_social_flutter/ui/chat/chat_search_list_item.dart';
import 'package:widget_mask/widget_mask.dart';

class ChatSearchScreen extends ConsumerStatefulWidget {
  const ChatSearchScreen({super.key});

  @override
  ChatSearchScreenState createState() => ChatSearchScreenState();
}

class ChatSearchScreenState extends ConsumerState<ChatSearchScreen> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController searchScrollController = ScrollController();
  ScrollController followController = ScrollController();
  int followOldLength = 0;
  int searchOldLength = 0;
  int userMemberIdx = 0;
  Timer? _searchDebounceTimer;
  String _searchWord = '';

  final PagingController<int, ChatFavoriteModel> _searchPagingController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    // var userInfoModel = ref.read(userInfoProvider);
    // ref.read(searchStateProvider.notifier).clearSearchMensionList();
    userMemberIdx = ref.read(userInfoProvider).userModel!.idx;
    ref.read(followStateProvider.notifier).initFollowList(userMemberIdx, 1);
    searchScrollController.addListener(_searchScrollListener);

    // _searchPagingController.addPageRequestListener((pageKey) {
    //   _fetchSearchPage(pageKey);
    // });

    super.initState();
  }

  Future<void> _fetchSearchPage(int pageKey) async {
    try {
      if(_searchWord.isNotEmpty || _searchWord != '') {
        pageKey = pageKey + 1;
      }
      final responseModel = await ref.read(chatSearchStateProvider.notifier).getChatSearchList(userMemberIdx, pageKey, _searchWord);
      final newItems = responseModel.data.list
          .map(
            (e) => ChatFavoriteModel(
              memberIdx: e.memberIdx!,
              isBadge: e.isBadge!,
              nick: e.nick ?? 'unknown',
              profileImgUrl: e.profileImgUrl ?? '',
              favoriteState: e.favoriteState,
              chatMemberId: e.chatMemberId ?? '',
              chatHomeServer: e.chatHomeServer ?? '',
              chatAccessToken: e.chatAccessToken ?? '',
              chatDeviceId: e.chatDeviceId ?? '',
              introText: e.intro ?? '',
            ),
          )
          .toList();

      int currentItemCount = _searchPagingController.itemList?.length ?? newItems.length;
      print('currentItemCount $currentItemCount / ${responseModel.data.params!.pagination!.totalRecordCount!}');
      final isLastPage = currentItemCount + newItems.length >= responseModel.data.params!.pagination!.totalRecordCount!;
      if (isLastPage) {
        _searchPagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _searchPagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _searchPagingController.error = error;
    }
  }

  void _followScrollListener() {
    if (followController.position.pixels > followController.position.maxScrollExtent - MediaQuery.of(context).size.height) {
      if (followOldLength == ref.read(followStateProvider).followListState.list.length) {
        ref.read(followStateProvider.notifier).loadMoreFollowList(userMemberIdx);
      }
    }
  }

  void _searchScrollListener() {
    if (searchScrollController.position.pixels > searchScrollController.position.maxScrollExtent - MediaQuery.of(context).size.height) {
      if (searchOldLength == ref.read(chatSearchStateProvider).length) {
        int page = ref.read(chatSearchPageProvider) + 1;
        ref.read(chatSearchStateProvider.notifier).chatSearchNick(userMemberIdx, page, _searchWord);
      }
    }
  }

  @override
  void dispose() {
    // ref.read(chatSearchStateProvider.notifier).chatSearchNick(userMemberIdx, 1, '');

    searchScrollController.removeListener(_searchScrollListener);
    searchScrollController.dispose();
    followController.removeListener(_followScrollListener);
    followController.dispose();

    _searchPagingController.dispose();

    super.dispose();
  }

  void _onTabListItem(String chatMemberId) {
    context.pop(chatMemberId);
  }

  Widget _buildFavorite() {
    var chatFavoriteList = ref.watch(chatFavoriteStateProvider);

    return chatFavoriteList.isEmpty
        ? const SizedBox.shrink()
        : Expanded(
            child: ListView.separated(
              itemCount: 20,
              //chatFavoriteList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              // scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) {
                return SizedBox(
                  width: 12.0.w,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                return ChatSearchListItem(
                  idx: 1,
                  nick: '123',
                  intro: '234',
                  isFavorite: true,
                  profileImgUrl: '',
                  //'assets/image/feed/image/sample_image3.png',
                  chatMemberId: 'chatFavoriteList[index].chatMemberId',
                  chatHomeServer: 'chatFavoriteList[index].chatHomeServer',
                  tempIdx: index.toString(),
                );
                // return ChatSearchListItem(
                //   idx: chatFavoriteList[index].memberIdx,
                //   nick: chatFavoriteList[index].nick,
                //   intro: chatFavoriteList[index].introText,
                //   isFavorite: true,
                //   profileImgUrl: chatFavoriteList[index].profileImgUrl,
                //   //'assets/image/feed/image/sample_image3.png',
                //   chatMemberId: chatFavoriteList[index].chatMemberId,
                //   chatHomeServer: chatFavoriteList[index].chatHomeServer,
                //   tempIdx: index.toString(),
                // );
              },
            ),
          );
  }

  Widget _buildFollow() {
    return Consumer(builder: (ctx, ref, child) {
      final followState = ref.watch(followStateProvider);
      final isLoadMoreError = followState.followListState.isLoadMoreError;
      final isLoadMoreDone = followState.followListState.isLoadMoreDone;
      final isLoading = followState.followListState.isLoading;
      final lists = followState.followListState.list;
      return ListView.builder(
        shrinkWrap: true,
        itemCount: lists.length + 1,
        itemBuilder: (context, index) {
          if (index == lists.length) {
            if (isLoadMoreError) {
              return const Center(
                child: Text('Error'),
              );
            }
            if (isLoadMoreDone) {
              return Container();
            }
            return Container();
          }

          return ChatSearchListItem(
            idx: lists[index].memberIdx!,
            nick: lists[index].followNick ?? 'unknown',
            intro: lists[index].intro ?? '',
            isFavorite: true,
            profileImgUrl: lists[index].url ?? '',
            //'assets/image/feed/image/sample_image3.png',
            chatMemberId: lists[index].chatMemeberId ?? '',
            chatHomeServer: lists[index].chatHomeServer ?? '',
            tempIdx: index.toString(),
          );
        },
      );
    });
  }

  // Widget _buildSearch() {
  //   final searchList = ref.watch(chatSearchStateProvider);
  //   searchOldLength = searchList.length ?? 0;
  //   return Expanded(
  //     child: ListView.separated(
  //       itemCount: searchList.length,
  //       shrinkWrap: true,
  //       controller: searchScrollController,
  //       separatorBuilder: (context, index) {
  //         return SizedBox(
  //           width: 12.0.w,
  //         );
  //       },
  //       itemBuilder: (BuildContext context, int index) {
  //         return ChatSearchListItem(
  //           idx: searchList[index].memberIdx!,
  //           nick: searchList[index].nick ?? 'unknown',
  //           intro: searchList[index].introText ?? '',
  //           isFavorite: searchList[index].favoriteState == 1 ? true : false,
  //           profileImgUrl: searchList[index].profileImgUrl ?? '',
  //           chatMemberId: searchList[index].chatMemberId ?? '',
  //           chatHomeServer: searchList[index].chatHomeServer ?? '',
  //           tempIdx: index.toString(),
  //           onTab: _onTabListItem,
  //           onTabFavorite: () {
  //             if (searchList[index].favoriteState == 1) {
  //               ref.read(chatFavoriteStateProvider.notifier).unSetChatFavorite(userMemberIdx, searchList[index].chatMemberId!);
  //             } else {
  //               ref.read(chatFavoriteStateProvider.notifier).setChatFavorite(userMemberIdx, searchList[index].chatMemberId!);
  //             }
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }
  Widget _buildSearchTemp() {
    ref.listen(chatFavoriteStateChangedProvider, (previous, next) {
      if(next == null) {
        return;
      }
      if(previous == next) {
        return;
      }
      if(_searchPagingController.itemList == null) {
        return;
      }

      int changedIdx = _searchPagingController.itemList!.indexWhere((element) => element.memberIdx == next!.memberIdx);

      if(changedIdx < 0) {
        return;
      }

      print('SearchFavorite 333 $changedIdx / $next}');
      ref.read(chatFavoriteStateChangedProvider.notifier).state = null;
      _searchPagingController.itemList![changedIdx] = next;
      _searchPagingController.notifyListeners();
    });

    return Expanded(
      child: PagedListView<int, ChatFavoriteModel>(
        pagingController: _searchPagingController,
        builderDelegate: PagedChildBuilderDelegate<ChatFavoriteModel>(
          itemBuilder: (context, item, index) {
            return ChatSearchListItem(
              idx: item.memberIdx!,
              nick: item.nick ?? 'unknown',
              intro: item.introText ?? '',
              isFavorite: item.favoriteState == 1 ? true : false,
              profileImgUrl: item.profileImgUrl ?? '',
              chatMemberId: item.chatMemberId ?? '',
              chatHomeServer: item.chatHomeServer ?? '',
              tempIdx: index.toString(),
              onTab: _onTabListItem,
              onTabFavorite: () {
                if (item.favoriteState == 1) {
                  ref.read(chatSearchStateProvider.notifier).unSetSearchFavorite(userMemberIdx, item.memberIdx);
                } else {
                  ref.read(chatSearchStateProvider.notifier).setSearchFavorite(userMemberIdx, item.memberIdx);
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody() {
    // final searchList = ref.watch(searchStateProvider).list;
    // final searchList = ref.watch(chatSearchStateProvider);
    final searchStatus = ref.watch(chatSearchStatusProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: FormBuilderTextField(
            name: 'chatFavorite',
            controller: searchController,
            onChanged: (value) {
              if (value.toString().isEmpty || searchController.text.isEmpty) {
                _searchWord = '';
                // ref.read(chatSearchStateProvider.notifier).chatSearchNick(userMemberIdx, 1, _searchWord);
                // return;
              }

              if (_searchDebounceTimer?.isActive ?? false) {
                _searchDebounceTimer?.cancel();
              }
              _searchWord = value.toString();
              _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
                // ref.read(chatSearchStateProvider.notifier).chatSearchNick(userMemberIdx, 1, _searchWord);
                _searchPagingController.refresh();
              });
            },
            style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
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
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      child: Icon(
                        Icons.search,
                        color: Colors.grey[600],
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        searchController.text = "";
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                        child: Icon(
                          Icons.close,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
              hintText: "메시지.닉네임을 검색해주세요".tr(),
              hintStyle: kBody11RegularStyle.copyWith(color: kNeutralColor500),
            ),
          ),
        ),
        SizedBox(
          height: 4.h,
        ),
        // _buildFavorite(),
        // _buildFavorite(),
        // searchStatus == ChatSearchStatus.idle ? Expanded(
        //   child: Column(
        //     children: [
        //       ExpansionTile(
        //         initiallyExpanded: true,
        //         title: Text(
        //           '메시지.즐겨찾기'.tr(),
        //           style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor, height: 1.2.h),
        //         ),
        //         children: [
        //           Padding(
        //             padding: EdgeInsets.only(left: 12.0.w, top: 8.0.h, bottom: 12.0.h),
        //             child: _buildFavorite(),
        //           ),
        //         ],
        //       ),
        //       ExpansionTile(
        //         initiallyExpanded: true,
        //         title: Text(
        //           '팔로잉',
        //           style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor, height: 1.2.h),
        //         ),
        //         children: [
        //           Padding(
        //             padding: EdgeInsets.only(left: 12.0.w, top: 8.0.h, bottom: 12.0.h),
        //             child: _buildFollow(),
        //           ),
        //         ],
        //       ),
        //     ],
        //   ),
        // ) : _buildSearch(),
        // SingleChildScrollView(
        //   controller: searchScrollController,
        //   child: _buildSearch(),
        // ),
        _buildSearchTemp(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('aaaaaaaaaaa');
        ref.read(chatSearchStateProvider.notifier).chatSearchNick(userMemberIdx, 1, '');
        context.pop();

        return false;
      },
      child: Material(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(
              "메시지.메시지 상대 선택".tr(),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: _buildBody(),
        ),
      ),
    );
  }
}
