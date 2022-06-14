import 'package:json_annotation/json_annotation.dart';

part 'create_contract_work_param.g.dart';

@JsonSerializable()
class CreateContractWorkParam {
  @JsonKey()
  String? title;
  @JsonKey()
  String? unit;
  @JsonKey()
  String? unitPrice;

  String? phone;

  factory CreateContractWorkParam.fromJson(Map<String, dynamic> json) => CreateContractWorkParam(
    title: json['title'] as String?,
    unit: json['unit'] as String?,
    unitPrice: json['unitPrice'] as String
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'title': this.title,
    'unit': this.unit,
    'unitPrice': this.unitPrice

};

  CreateContractWorkParam({
    this.title,
    this.unit,
    this.unitPrice
  });

  CreateContractWorkParam copyWith({
    String? title,
    String? unit,
    String? unitPrice,
  }) {
    return CreateContractWorkParam(
      title: title ?? this.title,
      unit: unit ?? this.unit,
      unitPrice: unitPrice ?? this.unitPrice
    );
  }
}
