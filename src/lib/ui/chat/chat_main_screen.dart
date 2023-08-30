import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart' hide Visibility;
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/controller/chat/abstract_chat_controller.dart';
import 'package:pet_mobile_social_flutter/controller/chat/chat_controller.dart';
import 'package:pet_mobile_social_flutter/controller/chat/matrix_chat_controller.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_model.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_room_model.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_favorite_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_register_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_room_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/chat/chat_room_item.dart';
import 'package:pet_mobile_social_flutter/ui/chat/matrix_chat_room_list_item.dart';
import 'package:widget_mask/widget_mask.dart';

// final emptyChatRoomProvider = StateProvider<bool>((ref) => false);

class ChatMainScreen extends ConsumerStatefulWidget {
  const ChatMainScreen({Key? key}) : super(key: key);

  @override
  ChatMainScreenState createState() => ChatMainScreenState();
}

class ChatMainScreenState extends ConsumerState<ChatMainScreen> {
  late ScrollController _scrollController;

  // MatrixChatClientController clientController = MatrixChatClientController();
  late ChatController _chatController;
  bool _isEmptyRoom = false;

  @override
  void initState() {
    getChatFavoriteList();
    _scrollController = ScrollController();
    var userInfoModel = ref.read(userInfoProvider);
    _chatController = ref.read(chatControllerProvider(ChatControllerInfo(
        provider: 'matrix',
        clientName: 'puppycat_${userInfoModel.userModel!.idx}')));
    _waitForFirstSync();
    super.initState();
  }

  ///background -> run
  @override
  void didChangeDependencies() {
    getChatFavoriteList();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _waitForFirstSync() async {
    print('_waitForFirstSync 1');
    final client = _chatController.client;
    await client.roomsLoading;
    await client.accountDataLoading;
    if (client.prevBatch == null) {
      print('_waitForFirstSync 2');
      await client.onSync.stream.first;
    }
  }

  void enterRoom() {}

  void getChatFavoriteList() {
    var userInfoModel = ref.read(userInfoProvider);
    if (userInfoModel.userModel != null) {
      var memberIdx = userInfoModel.userModel!.idx;

      ref.read(chatFavoriteStateProvider.notifier).getChatFavorite(memberIdx);
    }
  }

  Widget _buildFavorite(List<ChatFavoriteModel> chatFavoriteList) {
    // var chatFavoriteList = ref.watch(chatFavoriteStateProvider);

    return chatFavoriteList.isEmpty
        ? const SizedBox.shrink()
        : ListView.separated(
            itemCount: chatFavoriteList.length,
            // shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) {
              return SizedBox(
                width: 12.0.w,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () async {
                  if (chatFavoriteList[index].chatMemberId != null) {
                    var matrixController = _chatController.controller
                        as MatrixChatClientController;
                    var roomId = await _chatController.client.startDirectChat(
                        chatFavoriteList[index].chatMemberId!,
                        enableEncryption: false);

                    print('roomId $roomId');
                    if (await matrixController.checkHideRoom(roomId)) {
                      matrixController.showRoom(roomId);
                    }

                    Room? room = _chatController.client.rooms
                        .firstWhereOrNull((element) => element.id == roomId);
                    if (room != null) {
                      // await room.setHistoryVisibility(HistoryVisibility.joined);
                      // print('historyVisibility ${room.historyVisibility}');
                      if (mounted) {
                        context.push('/chatMain/chatRoom', extra: room);
                      }
                    }
                  }
                },
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        getProfileAvatar(
                          chatFavoriteList[index].profileImgUrl,
                        ),

                        // WidgetMask(
                        //   blendMode: BlendMode.srcATop,
                        //   childSaveLayer: true,
                        //   mask: Center(
                        //     child: chatFavoriteList[index].profileImgUrl.isNotEmpty
                        //         ? Image.network(
                        //             chatFavoriteList[index].profileImgUrl,
                        //             // width: 42.w,
                        //             height: 48.h,
                        //             fit: BoxFit.fill,
                        //           )
                        //         : Image.asset('assets/image/common/icon_profile_medium.png'),
                        //   ),
                        //   child: SvgPicture.asset(
                        //     'assets/image/feed/image/squircle.svg',
                        //     height: 48.h,
                        //     fit: BoxFit.fill,
                        //   ),
                        // ),
                        chatFavoriteList[index].isBadge == 1
                            ? Positioned(
                                top: 1.h,
                                right: 1.w,
                                child: Image.asset(
                                    'assets/image/common/icon_special.png',
                                    width: 12.w),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                    SizedBox(height: 6.0.h),
                    Text(
                      chatFavoriteList[index].nick,
                      style:
                          kBody12RegularStyle.copyWith(color: kTextTitleColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          );
  }

  Widget _buildNoRooms() {
    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/image/chat/empty_character_01_nopost_88_x2.png',
                width: 88,
                height: 88,
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                '메시지.주고받은 메시지가 없습니다'.tr(),
                textAlign: TextAlign.center,
                style: kBody13RegularStyle.copyWith(
                    color: kTextBodyColor, height: 1.4, letterSpacing: 0.2),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 320,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  disabledBackgroundColor: kNeutralColor400,
                  disabledForegroundColor: kTextBodyColor,
                  elevation: 0,
                ),
                child: Text(
                  '회원가입.퍼피캣 이용하기'.tr(),
                  style: kButton14MediumStyle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoomList() {
    var matrixController =
        _chatController.controller as MatrixChatClientController;

    return StreamBuilder(
      stream: _chatController.controller.getRoomListStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return FutureBuilder(
            future: matrixController.getRoomListAsync(),
            builder: (context, snapshot) {
              List<ChatRoomModel> roomList = [];
              if (snapshot.hasData) {
                roomList = snapshot.data as List<ChatRoomModel>;
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                // padding: EdgeInsets.only(top: 16.0.h),
                itemCount: roomList.length,
                itemBuilder: (BuildContext context, int index) {
                  ///NOTE 2023. 07. 12.
                  ///여기부터 우선 의존성, 확장성 무시하고 결과 먼저 보기로
                  Room matrixRoom = matrixController.client.getRoomById(
                          matrixController.client.rooms[index].id) ??
                      matrixController.client.rooms[index];

                  ChatRoomModel room = roomList[index].copyWith(
                    isFavorite:
                        _checkChatFavorite(matrixRoom.directChatMatrixID ?? ''),
                  );
                  // print('room id : ${room.id} / membership ${room.isJoined}');
                  return Padding(
                    padding: EdgeInsets.only(bottom: 6.0.h),
                    child: ChatRoomItem(
                      roomModel: room,
                      onLeave: () async {
                        // await matrixRoom.leave();
                        matrixController.hideRoom(room.id);
                        // if (roomList.length <= 1) {
                        //   ref.read(emptyChatRoomProvider.notifier).state = true;
                        // }
                      },
                      onTap: () {
                        context.push('/chatMain/chatRoom', extra: matrixRoom);
                      },
                      onPin: (pinState) async {
                        await matrixRoom.setFavourite(!pinState);
                      },
                      onFavorite: (isFavorite) {
                        print(matrixRoom.directChatMatrixID);
                        String? chatMemberId = matrixRoom.directChatMatrixID;
                        if (chatMemberId == null) {
                          return;
                        }
                        var memberIdx =
                            ref.read(userInfoProvider).userModel!.idx;

                        if (isFavorite) {
                          ref
                              .read(chatFavoriteStateProvider.notifier)
                              .unSetChatFavorite(memberIdx, chatMemberId);
                        } else {
                          ref
                              .read(chatFavoriteStateProvider.notifier)
                              .setChatFavorite(memberIdx, chatMemberId);
                        }
                      },
                    ),
                  );
                  // return Padding(
                  //   padding: EdgeInsets.only(bottom: 6.0.h),
                  //   child: ChatRoomItem(
                  //     roomModel: room,
                  //     onTap: () {
                  //       context.push('/chatMain/chatRoom', extra: room);
                  //     },
                  //   ),
                  // );
                },
              );
            });
      },
    );
  }

  bool _checkChatFavorite(String chatMemberId) {
    var chatFavoriteList = ref.read(chatFavoriteStateProvider);

    return chatFavoriteList
        .any((element) => element.chatMemberId == chatMemberId);
  }

  Future<bool> _setJoin(Room room) async {
    if (room.membership != Membership.invite) {
      return false;
    }
    final waitForRoom = room.client.waitForRoomInSync(
      room.id,
      join: true,
    );
    await room.join();
    await waitForRoom;
    return true;
  }

  Widget _buildBlank() {
    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/image/signUpScreen/corgi_1.png'),
              SizedBox(
                height: 12.h,
              ),
              Text(
                '회원가입.퍼피캣의 가족이 되신 걸 환영해요'.tr(),
                style: kTitle14BoldStyle.copyWith(
                    height: 1.4, color: kTextTitleColor),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 8.h,
              ),
              Text(
                '회원가입.회원가입 환영 메시지'.tr(),
                style: kBody12RegularStyle.copyWith(
                    height: 1.3, color: kTextBodyColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 320.w,
              height: 48.h,
              child: ElevatedButton(
                onPressed: () {
                  var userModel = ref.read(userModelProvider);
                  ref
                      .read(loginStateProvider.notifier)
                      .loginByUserModel(userModel: userModel!);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  disabledBackgroundColor: kNeutralColor400,
                  disabledForegroundColor: kTextBodyColor,
                  elevation: 0,
                ),
                child: Text(
                  '회원가입.퍼피캣 이용하기'.tr(),
                  style: kButton14BoldStyle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var chatFavoriteList = ref.watch(chatFavoriteStateProvider);
    bool isEmptyRoom = _chatController.controller.getRoomList().isEmpty;
    bool isViewEmptyPage = chatFavoriteList.isEmpty && isEmptyRoom;

    print(
        'isEmptyRoom $isEmptyRoom / ${chatFavoriteList.isEmpty} / ${chatFavoriteList.isEmpty && isEmptyRoom}');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '메시지.메시지'.tr(),
          style:
              kTitle18BoldStyle.copyWith(color: kTextTitleColor, height: 1.4.h),
        ),
        backgroundColor: kNeutralColor100,
        actions: [
          IconButton(
            onPressed: () async {
              context.push('/chatMain/chatSearch').then((value) async {
                print('value $value');
                if (value == null) {
                  return;
                }
                var matrixController =
                    _chatController.controller as MatrixChatClientController;
                if (await matrixController.checkHideRoom(value.toString())) {
                  matrixController.showRoom(value.toString());
                }

                print('value.toString() ${value.toString()}');
                var roomId = await _chatController.client
                    .startDirectChat(value.toString(), enableEncryption: false);
                Room? room = _chatController.client.rooms
                    .firstWhereOrNull((element) => element.id == roomId);
                if (room != null) {
                  // await room.setHistoryVisibility(HistoryVisibility.joined);
                  if (mounted) {
                    context.push('/chatMain/chatRoom', extra: room);
                  }
                }
              });
            },
            icon: Image.asset('assets/image/chat/icon_choice.png'),
            iconSize: 40.w,
          ),
        ],
      ),
      body: SafeArea(
        child: isViewEmptyPage
            ? _buildNoRooms()
            : SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    chatFavoriteList.isEmpty
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: EdgeInsets.only(
                                left: 12.0.w, top: 8.0.h, bottom: 12.0.h),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '메시지.즐겨찾기'.tr(),
                                    style: kTitle16ExtraBoldStyle.copyWith(
                                        color: kTextTitleColor, height: 1.2.h),
                                  ),
                                ),
                                SizedBox(
                                  height: 8.0.h,
                                ),
                                SizedBox(
                                  height: 72.h,
                                  child: _buildFavorite(
                                    chatFavoriteList,
                                  ),
                                ),
                              ],
                            ),
                          ),
                    // const Divider(),
                    SizedBox(
                      width: double.infinity,
                      height: 16.h,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[kNeutralColor300, kNeutralColor100],
                          ),
                        ),
                      ),
                    ),
                    _buildRoomList(),
                  ],
                ),
              ),
      ),
    );
  }
}
