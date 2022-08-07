import 'package:json_annotation/json_annotation.dart';

part 'material_task.g.dart';

@JsonSerializable()
class MaterialTask{
  @JsonKey(name: '_id')
  String? materialId;
  String? unit;
  String? name;
  int? quantity;
  int? unitPrice;

  MaterialTask({
    this.unit,
    this.name,
    this.materialId,
    this.quantity,
    this.unitPrice
  });

  MaterialTask copyWith({
    String? materialId,
    String? unit,
    String? name,
    int? quantity,
    int? unitPrice,
  }) {
    return MaterialTask(
        materialId: materialId ?? this.materialId,
        unit: unit ?? this.unit,
        name: name ?? this.name,
        quantity: quantity ?? this.quantity,
        unitPrice: unitPrice ?? this.unitPrice
    );
  }

  factory MaterialTask.fromJson(Map<String, dynamic> json) =>
      _$MaterialTaskFromJson(json);
  Map<String, dynamic> toJson() => _$MaterialTaskToJson(this);
}