import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UuidUtil {
  late SharedPreferences prefs;
  final String uuidKey = 'uuid';

  Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  String generateUuid({
    int version = 4,
    String? v5Key,
  }) {
    const Uuid uuidInstance = Uuid();
    String uuid = uuidInstance.v4();

    return uuid;
  }

  Future<bool> checkExistUuid() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(uuidKey)) {
      return true;
    } else {
      return false;
    }
  }

  void setUUID(String uuid) async {
    await prefs.setString(uuidKey, uuid);
  }

  void removeUUID() async {
    await prefs.remove(uuidKey);
  }

  Future<String> getUUID([bool newUUID = false]) async {
    if(newUUID) {
      final uuid = generateUuid();
      setUUID(uuid);
      return uuid;
    }

    if(await checkExistUuid()) {
      return prefs.getString(uuidKey)!;
    } else {
      final uuid = generateUuid();
      setUUID(uuid);
      return uuid;
    }
  }
}
