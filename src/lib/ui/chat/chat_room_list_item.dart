import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:widget_mask/widget_mask.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class ChatRoomListItem extends StatelessWidget {
  const ChatRoomListItem({Key? key}) : super(key: key);

  Widget getAvatar() {
    return WidgetMask(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {},
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: (_) {},
            backgroundColor: Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.share,
            label: 'Share',
          ),
        ],
      ),
      endActionPane: ActionPane(
        extentRatio: 0.21,
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {},
            backgroundColor: Color(0xFF7BC043),
            foregroundColor: Colors.white,
            icon: Icons.exit_to_app,
            label: 'Exit',
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 8.h),
        child: Row(
          children: [
            getAvatar(),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('테스트'),
                      Visibility(
                        child: Icon(Icons.push_pin),
                        visible: true,
                      ),
                      Spacer(),
                      Visibility(
                        child: Icon(Icons.check),
                        visible: true,
                      ),
                      Text('3초 전'),
                    ],
                  ),
                  Row(
                    children: [
                      Text('메시지 왔다 읽어'),
                      Spacer(),
                      Icon(Icons.numbers),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
