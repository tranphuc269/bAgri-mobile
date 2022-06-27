import 'package:json_annotation/json_annotation.dart';

part 'material.g.dart';

@JsonSerializable()
class Material{
  @JsonKey(name: '_id')
  String? materialId;
  String? unit;
  int? unitPrice;
  String? name;
  int? quantity;

  Material({
    this.unit,
    this.name,
    this.unitPrice,
    this.materialId,
    this.quantity
  });

  Material copyWith({
    String? materialId,
    String? unit,
    String? name,
    int? unitPrice,
    int? quantity
  }) {
    return Material(
        materialId: materialId ?? this.materialId,
        unit: unit ?? this.unit,
        name: name ?? this.name,
        unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity
    );
  }

  factory Material.fromJson(Map<String, dynamic> json) =>
      _$MaterialFromJson(json);
  Map<String, dynamic> toJson() => _$MaterialToJson(this);
}

@JsonSerializable()
class MaterialUsedByTask{
  String? name;
  String? unit;
  int? quantity;
  MaterialUsedByTask({
    this.name,
    this.unit,
    this.quantity
  });
  MaterialUsedByTask copyWith({
    String? unit,
    String? name,
    int? quantity
  }) {
    return MaterialUsedByTask(
        unit: unit ?? this.unit,
        name: name ?? this.name,
        quantity: quantity ?? this.quantity
    );
  }

  factory MaterialUsedByTask.fromJson(Map<String, dynamic> json) =>
      _$MaterialUsedByTaskFromJson(json);
  Map<String, dynamic> toJson() => _$MaterialUsedByTaskToJson(this);

}