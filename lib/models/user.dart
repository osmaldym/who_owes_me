import 'package:who_owes_me/models/baseModel.dart';

class User extends BaseModel {
  String? name;
  String? email;
  String? phone;

  User({
    super.id,
    this.email,
    this.name,
    this.phone,
    super.deletedAt,
  });

  @override
  Map<String, Object?> toMap() => {
    ...super.toMap(),
    'name': name,
    'email': email,
    'phone': phone,
  };

  @override
  String toString() => 'User: ${toMap()}';
}