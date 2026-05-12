class BaseModel {
  int? id;

  BaseModel({
    this.id,
  });

  Map<String, Object?> toMap() => {
    'id': id
  };
}