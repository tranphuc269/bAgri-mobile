import 'package:json_annotation/json_annotation.dart';

part 'turnover_entity.g.dart';

@JsonSerializable()
class TurnoverEntity {
  @JsonKey()
  String? name;
  String? unit;
  int? unitPrice;
  num? quantity;

  TurnoverEntity({
    this.name,
    this.unit,
    this.unitPrice,
    this.quantity,
  });

  TurnoverEntity copyWith({
    String? name,
    String? unit,
    int? unitPrice,
    num? quantity
  }){
    return TurnoverEntity(
      name: name ?? this.name,
      unit: unit ?? this.unit,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity
    );
  }
  factory TurnoverEntity.fromJson(Map<String, dynamic> json) =>
      _$TurnoverEntityFromJson(json);
  Map<String, dynamic> toJson() => _$TurnoverEntityToJson(this);
}
