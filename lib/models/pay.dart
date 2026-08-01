import 'package:who_owes_me/models/baseModel.dart';

class Pay extends BaseModel {
  String? title;
  int? userId;
  double? amount;
  DateTime? date;
  bool? paid;

  Pay({
    super.id,
    this.userId,
    this.title,
    this.amount,
    this.date,
    this.paid,
    super.deletedAt,
  });

  @override
  Map<String, Object?> toMap() => {
    ...super.toMap(),
    'user_id': userId,
    'title': title,
    'amount': amount,
    'paid': paid,
    'date': date?.microsecondsSinceEpoch,
  };

  @override
  String toString() => 'Pay: ${toMap()}';
}