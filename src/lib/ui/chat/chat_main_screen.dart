import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:matrix/matrix.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/controller/chat/matrix_chat_controller.dart';
import 'package:pet_mobile_social_flutter/ui/chat/chat_room_list_item.dart';
import 'package:widget_mask/widget_mask.dart';

class ChatMainScreen extends ConsumerStatefulWidget {
  const ChatMainScreen({Key? key}) : super(key: key);

  @override
  ChatMainScreenState createState() => ChatMainScreenState();
}

class ChatMainScreenState extends ConsumerState<ChatMainScreen> {
  late ScrollController _scrollController;
  MatrixChatClientController clientController = MatrixChatClientController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    listenChatEvent();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void listenChatEvent() async {
    // MatrixChatClientController clientController = MatrixChatClientController();
    Client client = clientController.client;

    await client.checkHomeserver(Uri.parse("https://sns-chat.devlabs.co.kr:8008"));
    var result = await client.login(
      LoginType.mLoginPassword,
      identifier: AuthenticationUserIdentifier(user: 'thirdnsov_gmail.com'),
      password: 'test12#\$',
    );

    client.accessToken = result.accessToken;
    print('client.accessToken ${client.accessToken}');
  }

  Widget _buildFavorite() {
    return ListView.builder(
      itemCount: 8,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              WidgetMask(
                blendMode: BlendMode.srcATop,
                childSaveLayer: true,
                mask: Center(
                  child: Image.network(
                    'https://via.placeholder.com/150/f66b97',
                    height: 46.h,
                    fit: BoxFit.fill,
                  ),
                ),
                child: SvgPicture.asset(
                  'assets/image/feed/image/squircle.svg',
                  height: 46.h,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                'test',
                style: kBody12RegularStyle.copyWith(color: kTextTitleColor),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRoomList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return ChatRoomListItem();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('메시지'),
        // leading: IconButton(onPressed: () {}, icon: const Icon(Icons.chat)),
        // leadingWidth: ,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.chat)),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text('Chat Main Screen'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('메시지.즐겨찾기'.tr()),
                  ),
                ),
                SizedBox(
                  height: 80.h,
                  child: _buildFavorite(),
                ),
                ElevatedButton(
                  onPressed: () async {
                    var result = await clientController.getRoomList();
                    print('result $result');
                  },
                  child: const Text('test'),
                ),
                _buildRoomList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
