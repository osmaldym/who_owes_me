import 'package:who_owes_me/models/pay.dart';
import 'package:who_owes_me/models/user.dart';

class DBConvertions {
  static List<User> responseToUserList(List<Map<String, Object?>> response) {
    return [ for (final resp in response) responseToUser(resp) ];
  }

  static User responseToUser(Map<String, Object?> response) {
     int? deletedAt = response['deleted_at'] as int?;

    return User(
      id: response['id'] as int,
      name: response['name'] as String?,
      email: response['email'] as String?,
      phone: response['phone'] as String?,
      deletedAt: deletedAt == null ? null : DateTime.fromMicrosecondsSinceEpoch(deletedAt),
    );
  }

  static List<Pay> responseToPayList(List<Map<String, Object?>> response) {
    return [ for (final resp in response) responseToPay(resp) ];
  }

  static Pay responseToPay(Map<String, Object?> response) {
    int? date = response['date'] as int?;
    int? deletedAt = response['deleted_at'] as int?;

    return Pay(
      id: response['id'] as int,
      userId: response['user_id'] as int?,
      title: response['title'] as String?,
      amount: response['amount'] as double?,
      paid: response['paid'] == null ? null : (response['paid'] as int) == 1,
      date: date == null ? null : DateTime.fromMicrosecondsSinceEpoch(date),
      deletedAt: deletedAt == null ? null : DateTime.fromMicrosecondsSinceEpoch(deletedAt),
    );
  }
}
