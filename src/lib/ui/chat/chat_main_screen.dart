import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/controller/chat/abstract_chat_controller.dart';
import 'package:pet_mobile_social_flutter/controller/chat/matrix_chat_controller.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_room_model.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_register_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_room_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/chat/chat_room_item.dart';
import 'package:pet_mobile_social_flutter/ui/chat/matrix_chat_room_list_item.dart';
import 'package:widget_mask/widget_mask.dart';

class ChatMainScreen extends ConsumerStatefulWidget {
  const ChatMainScreen({Key? key}) : super(key: key);

  @override
  ChatMainScreenState createState() => ChatMainScreenState();
}

class ChatMainScreenState extends ConsumerState<ChatMainScreen> {
  late ScrollController _scrollController;
  // MatrixChatClientController clientController = MatrixChatClientController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // listenChatEvent();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // void listenChatEvent() async {
  //   // MatrixChatClientController clientController = MatrixChatClientController();
  //   Client client = clientController.client;
  //
  //   // await client.checkHomeserver(Uri.parse("https://sns-chat.devlabs.co.kr:8008"));
  //   await client.checkHomeserver(Uri.parse("https://dev2.office.uxplus.kr"));
  //   var result = await client.login(
  //     LoginType.mLoginPassword,
  //     identifier: AuthenticationUserIdentifier(user: 'test2'),
  //     password: 'test2',
  //   );
  //
  //   client.accessToken = result.accessToken;
  //   print('client.accessToken ${client.accessToken}');
  //
  //   // ref.read(chatRoomStateProvider.notifier).listenRoomState();
  // }

  Widget _buildFavorite() {
    return ListView.separated(
      itemCount: 8,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      separatorBuilder: (context, index) {
        return SizedBox(width: 12.0.w,);
      },
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            WidgetMask(
              blendMode: BlendMode.srcATop,
              childSaveLayer: true,
              mask: Center(
                child: Image.network(
                  'https://via.placeholder.com/150/f66b97',
                  height: 48.h,
                  fit: BoxFit.fill,
                ),
              ),
              child: SvgPicture.asset(
                'assets/image/feed/image/squircle.svg',
                height: 48.h,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: 6.0.h),
            Text(
              'test',
              style: kBody12RegularStyle.copyWith(color: kTextTitleColor),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      },
    );
  }

  Widget _buildRoomList() {
    print('aaaaaaaaaa');
    AbstractChatController chatController = ref.watch(chatControllerProvider('matrix'));

    return StreamBuilder(
      stream: chatController.getRoomListStream(),
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          return const Center(child: CircularProgressIndicator(),);
        }

        // if(!snapshot.hasData) {
        //   return const Center(child: CircularProgressIndicator(),);
        // }

        List<ChatRoomModel> roomList = chatController.getRoomList();
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.only( top: 16.0.h),
          itemCount: roomList.length,
          itemBuilder: (BuildContext context, int index) {
            ChatRoomModel room = roomList[index];
            // print('room id : ${room.id} / membership ${room.isJoined}');
            ///NOTE 2023. 07. 12.
            ///여기부터 우선 의존성, 확장성 무시하고 결과 먼저 보기로
            var matrixController = chatController as MatrixChatClientController;
            return Padding(
              padding: EdgeInsets.only(bottom: 6.0.h),
              child: ChatRoomItem(
                roomModel: room,
                onLeave: () async {
                  await matrixController.client.rooms[index].leave();
                },
                onTap: () {

                  Room matrixRoom = matrixController.client.getRoomById(matrixController.client.rooms[index].id) ?? matrixController.client.rooms[index];
                  context.push('/chatMain/chatRoom', extra: matrixRoom);
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
      },
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '메시지.메시지'.tr(),
          style: kTitle18BoldStyle.copyWith(color: kTextTitleColor, height: 1.4.h),
        ),
        backgroundColor: kNeutralColor100,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.chat)),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 12.0.w, top: 8.0.h, bottom: 12.0.h),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '메시지.즐겨찾기'.tr(),
                        style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor, height: 1.2.h),
                      ),
                    ),
                    SizedBox(height: 8.0.h,),
                    SizedBox(
                      height: 72.h,
                      child: _buildFavorite(),
                    ),
                  ],
                ),
              ),
              const Divider(),
              _buildRoomList(),
            ],
          ),
        ),
      ),
    );
  }
}
