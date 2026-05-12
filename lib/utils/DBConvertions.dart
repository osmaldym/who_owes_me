import 'package:who_owes_me/models/user.dart';

class DBConvertions {
  static List<User> responseToUserList(List<Map<String, Object?>> response) {
    return [ for (final resp in response) responseToUser(resp) ];
  }

  static User responseToUser(Map<String, Object?> response) {
    return User(
      id: response['id'] as int,
      name: response['name'] as String?,
      email: response['email'] as String?,
      phone: response['phone'] as String?,
    );
  }
}
