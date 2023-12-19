import 'package:flutter/material.dart';
import 'package:pet_mobile_social_flutter/common/library/chat/vo/chat_item.dart';
import 'package:pet_mobile_social_flutter/common/library/chat/widget/chat_base_item.dart';
import 'package:pet_mobile_social_flutter/common/library/chat/widget/text_box.dart';

class TextChatItem extends StatelessWidget {
  final ChatItem data;

  const TextChatItem(
    this.data, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChatBaseItem(
      data,
      TextBox(data),
    );
  }
}
