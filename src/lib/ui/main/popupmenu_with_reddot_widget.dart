import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/my_page_main_screen.dart';

class PopupMenuWithReddot extends ConsumerStatefulWidget {
  const PopupMenuWithReddot({super.key});

  @override
  PopupMenuWithReddotState createState() => PopupMenuWithReddotState();
}

class PopupMenuWithReddotState extends ConsumerState<PopupMenuWithReddot> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // Function called when the widget metrics change (e.g., when the widget is drawn on screen)
    if (ModalRoute.of(context)?.isCurrent ?? false) {
      print('ohg run??');
      yourFunction();
    }
  }

  void yourFunction() {
    print("Widget is now on the screen");
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('run???????????????');
    return PopupMenuButton(
      padding: EdgeInsets.zero,
      icon: Image.asset(
        'assets/image/header/icon/large_size/icon_more_h.png',
        height: 26,
      ),
      onSelected: (id) {
        if (id == 'notification') {
          context.go("/home/notification");
        }
        if (id == 'search') {
          context.go("/home/search");
        }
        if (id == 'message') {
          context.push('/chatMain');
        }
        if (id == 'setting') {
          context.push("/home/myPage/setting");
        }
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16.0),
          bottomRight: Radius.circular(16.0),
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      itemBuilder: (context) {
        final list = <PopupMenuEntry>[];
        list.add(
          diaryPopUpMenuItem(
            'notification',
            '알림',
            const Icon(Icons.notifications),
            context,
          ),
        );
        list.add(
          const PopupMenuDivider(
            height: 5,
          ),
        );
        list.add(
          diaryPopUpMenuItem(
            'search',
            '검색',
            const Icon(Icons.search),
            context,
          ),
        );
        list.add(
          const PopupMenuDivider(
            height: 5,
          ),
        );
        list.add(
          diaryPopUpMenuItem(
            'message',
            '메시지',
            const Icon(Icons.message),
            context,
          ),
        );
        list.add(
          const PopupMenuDivider(
            height: 5,
          ),
        );
        list.add(
          diaryPopUpMenuItem(
            'setting',
            '설정',
            const Icon(Icons.settings),
            context,
          ),
        );
        return list;
      },
    );
  }
}
