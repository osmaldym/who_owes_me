import 'package:who_owes_me/models/pay.dart';
import 'package:who_owes_me/models/user.dart';

class RelatedPay extends Pay {
  User? user;

  RelatedPay({
    super.id,
    super.userId,
    super.title,
    super.amount,
    super.date,
    this.user,
  });

  @override
  Map<String, Object?> toMap() => {
    ...super.toMap(),
    'user': user,
  };

  @override
  String toString() => 'RelatedPay: ${toMap()}';
}