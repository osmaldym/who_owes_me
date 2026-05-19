class BaseModel {
  int? id;
  DateTime? deletedAt;

  BaseModel({
    this.id,
    this.deletedAt,
  });

  Map<String, Object?> toMap() => {
    'id': id,
    'deleted_at': deletedAt?.microsecondsSinceEpoch,
  };
}