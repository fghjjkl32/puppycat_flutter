import 'package:flutter/material.dart';

class RestrictionDialog extends StatelessWidget {
  final bool isForever;
  final String foreverRestrictionTitle = "활동이 영구 정지되었습니다.";
  final String restrictionTitle = "활동이 일시적으로 제한된 계정입니다.";
  final String restrictionBody = "자세한 내용은\n1:1채널톡으로 문의해주세요.";
  final String? restrictionPeriod;

  const RestrictionDialog({
    Key? key,
    this.isForever = true,
    this.restrictionPeriod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: WillPopScope(
        onWillPop: () async => false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(isForever ? foreverRestrictionTitle : restrictionTitle, textAlign: TextAlign.center),
            Visibility(
              visible: !isForever,
              child: Text('기한 : $restrictionPeriod', textAlign: TextAlign.center),
            ),
            Text(restrictionBody, textAlign: TextAlign.center,),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text('확인'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('1:1 채널톡'),
            ),
          ],
        ),
      ],
    );
  }
}
