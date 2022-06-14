import 'package:json_annotation/json_annotation.dart';

part "contract_work.g.dart";

@JsonSerializable()
class ContractWorkEntity{
  @JsonKey(name: "_id")
  String? id;
  @JsonKey()
  String? title;
  @JsonKey()
  String? unit;
  @JsonKey()
  num? unitPrice;

  ContractWorkEntity({
    this.id,
    this.title,
    this.unit,
    this.unitPrice,

  });
  ContractWorkEntity copyWith({
    String? id,
    String? title,
    String? unit,
    num? unitPrice

  }) {
    return ContractWorkEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      unit: unit ?? this.unit,
      unitPrice:  unitPrice ?? this.unitPrice

    );
  }
    factory ContractWorkEntity.fromJson(Map<String, dynamic> json) =>
        _$ContractWorkEntityFromJson(json);
    Map<String, dynamic> toJson() => _$ContractWorkEntityToJson(this);
}