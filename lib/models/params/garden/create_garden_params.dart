import 'package:flutter_base/models/entities/zone/zone_entity.dart';
import 'package:flutter_base/ui/pages/garden_management/zone/zone_list_cubit.dart';
import 'package:json_annotation/json_annotation.dart';
part 'create_garden_params.g.dart';

@JsonSerializable()
class CreateGardenParam {
  @JsonKey()
  String? managerPhone;
  @JsonKey()
  String? name;
  @JsonKey()
  num? area;
  @JsonKey()
  String? areaUnit;
  @JsonKey()
  num? treePlaceQuantity;
  @JsonKey()
  String? zoneName;


  CreateGardenParam({this.name, this.area, this.managerPhone, this.areaUnit, this.treePlaceQuantity, this.zoneName});

  CreateGardenParam copyWith({
    String? name,
    num? area,
    String? managerPhone,
    String? areaUnit,
    num? treePlaceQuantity,
    String? zoneName,
  }) {
    return CreateGardenParam(
      name: name ?? this.name,
      area: area ?? this.area,
      managerPhone: managerPhone ?? this.managerPhone,
      treePlaceQuantity: treePlaceQuantity ?? this.treePlaceQuantity,
      zoneName: zoneName ?? this.zoneName
    );
  }

  factory CreateGardenParam.fromJson(Map<String, dynamic> json) =>
      _$CreateGardenParamFromJson(json);

  Map<String, dynamic> toJson() => _$CreateGardenParamToJson(this);
}
