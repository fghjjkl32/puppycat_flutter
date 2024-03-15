import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

class TelegramBot {
  TelegramBot() {}

  Future<void> initialize() async {
    var BOT_TOKEN = 'YOUR_BOT_TOKEN_FROM_BOT_FATHER';
    final username = (await Telegram(BOT_TOKEN).getMe()).username;
    var teledart = TeleDart(BOT_TOKEN, Event(username!));

    teledart.start();
  }
}
