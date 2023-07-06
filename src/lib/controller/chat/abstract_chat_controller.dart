
abstract class AbstractChatController {
  Future<dynamic> login(String id, String pw);
  Future<dynamic> logout();
  Future<dynamic> register(String id, String pw, String displayName);
  Future<dynamic> setDisplayName(String id, String nick);
  Future<dynamic> getFavoriteList();
  Future<dynamic> getRoomList();
}