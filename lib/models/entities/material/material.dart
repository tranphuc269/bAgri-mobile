import 'package:json_annotation/json_annotation.dart';

part 'material.g.dart';

@JsonSerializable()
class MaterialEntity{
  @JsonKey(name: '_id')
  String? materialId;
  String? unit;
  int? unitPrice;
  String? name;
  int? quantity;

  MaterialEntity({
    this.unit,
    this.name,
    this.unitPrice,
    this.materialId,
    this.quantity
  });

  MaterialEntity copyWith({
    String? materialId,
    String? unit,
    String? name,
    int? unitPrice,
    int? quantity
  }) {
    return MaterialEntity(
        materialId: materialId ?? this.materialId,
        unit: unit ?? this.unit,
        name: name ?? this.name,
        unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity
    );
  }

  factory MaterialEntity.fromJson(Map<String, dynamic> json) =>
      _$MaterialEntityFromJson(json);
  Map<String, dynamic> toJson() => _$MaterialEntityToJson(this);
}

@JsonSerializable()
class MaterialUsedByTask{
  String? name;
  String? unit;
  int? quantity;
  int? unitPrice;
  MaterialUsedByTask({
    this.name,
    this.unit,
    this.quantity,
    this.unitPrice
  });
  MaterialUsedByTask copyWith({
    String? unit,
    String? name,
    int? quantity,
    int? unitPrice
  }) {
    return MaterialUsedByTask(
        unit: unit ?? this.unit,
        name: name ?? this.name,
        quantity: quantity ?? this.quantity,
        unitPrice: unitPrice ?? this.unitPrice
    );
  }

  factory MaterialUsedByTask.fromJson(Map<String, dynamic> json) =>
      _$MaterialUsedByTaskFromJson(json);
  Map<String, dynamic> toJson() => _$MaterialUsedByTaskToJson(this);

}