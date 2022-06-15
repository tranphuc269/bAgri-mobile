import 'package:json_annotation/json_annotation.dart';

part 'material.g.dart';

@JsonSerializable()
class Material{
  @JsonKey(name: '_id')
  String? materialId;
  String? unit;
  int? unitPrice;
  String? title;
  int? quantity;

  Material({
    this.unit,
    this.title,
    this.unitPrice,
    this.materialId,
    this.quantity
  });

  Material copyWith({
    String? materialId,
    String? unit,
    String? title,
    int? unitPrice,
    int? quantity
  }) {
    return Material(
        materialId: materialId ?? this.materialId,
        unit: unit ?? this.unit,
        title: title ?? this.title,
        unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity
    );
  }

  factory Material.fromJson(Map<String, dynamic> json) =>
      _$MaterialFromJson(json);
  Map<String, dynamic> toJson() => _$MaterialToJson(this);
}