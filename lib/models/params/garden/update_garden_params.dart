import 'package:flutter_base/models/entities/zone/zone_entity.dart';
import 'package:flutter_base/ui/pages/garden_management/zone/zone_list_cubit.dart';
import 'package:json_annotation/json_annotation.dart';
part 'update_garden_params.g.dart';

@JsonSerializable()
class UpdateGardenParam {
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
  UpdateGardenParam({this.name, this.area, this.managerPhone, this.areaUnit, this.treePlaceQuantity, this.zoneName});

  UpdateGardenParam copyWith({
    String? name,
    num? area,
    String? managerPhone,
    String? areaUnit,
    num? treePlaceQuantity,
    String? zoneName,
  }) {
    return UpdateGardenParam(
        name: name ?? this.name,
        area: area ?? this.area,
        areaUnit: areaUnit ?? this.areaUnit,
        managerPhone: managerPhone ?? this.managerPhone,
        treePlaceQuantity: treePlaceQuantity ?? this.treePlaceQuantity,
        zoneName: zoneName ?? this.zoneName
    );
  }

  factory UpdateGardenParam.fromJson(Map<String, dynamic> json) =>
      _$UpdateGardenParamFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateGardenParamToJson(this);
}
