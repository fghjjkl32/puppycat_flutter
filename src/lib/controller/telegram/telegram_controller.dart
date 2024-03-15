import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

class TelegramBot {
  String BOT_TOKEN = '6629476428:AAEuLf6o4wrECCD7fyGK-eD_DFZ9OnVbzGc';
  String CHAT_ID = '-4120977865';
  late TeleDart _teledart;

  Future<void> initialize() async {
    final username = (await Telegram(BOT_TOKEN).getMe()).username;
    _teledart = TeleDart(BOT_TOKEN, Event(username!));

    _teledart.start();
  }

  Future<void> sendMessage(String message) async {
    await _teledart.sendMessage(int.parse(CHAT_ID), message);
  }
}
