import 'package:flutter_base/models/entities/garden_manager/garden_manager_entity.dart';
import 'package:flutter_base/models/entities/zone/zone_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'garden_entity.g.dart';

@JsonSerializable()
class GardenEntity {
  @JsonKey(name: "_id")
  String? gardenId;
  @JsonKey()
  String? name;
  @JsonKey()
  num? area;
  @JsonKey()
  String? areaUnit;
  @JsonKey()
  GardenManagerEntity? manager;
  @JsonKey()
  int? treePlaceQuantity;
  ZoneEntity? zone;


  factory GardenEntity.fromJson(Map<String, dynamic> json) =>
      _$GardenEntityFromJson(json);
  Map<String, dynamic> toJson() => _$GardenEntityToJson(this);

  GardenEntity({
    this.gardenId,
    this.name,
    this.area,
    this.areaUnit,
    this.manager,
    this.treePlaceQuantity,
    this.zone,
  });

  GardenEntity copyWith({
    String? id,
    String? gardenId,
    String? name,
    num? area,
    String? areaUnit,
    GardenManagerEntity? manager,
    int? treePlaceQuantity,
    ZoneEntity? zone

  }) {
    return GardenEntity(
      gardenId: gardenId ?? this.gardenId,
      name: name ?? this.name,
      area: area ?? this.area,
      areaUnit: areaUnit ?? this.areaUnit,
      manager: manager?? manager,
      treePlaceQuantity: treePlaceQuantity ?? this.treePlaceQuantity,
      zone: zone ?? this.zone
    );
  }
}

@JsonSerializable()
class GardenEntityResponseFromZoneId {
  @JsonKey(name: "_id")
  String? gardenId;
  @JsonKey()
  String? name;
  @JsonKey()
  int? area;
  @JsonKey()
  String? areaUnit;
  @JsonKey()
  String? managerId;
  @JsonKey()
  int? treePlaceQuantity;
  @JsonKey(name: "zone")
  String? zoneId;


  factory GardenEntityResponseFromZoneId.fromJson(Map<String, dynamic> json) =>
      _$GardenEntityResponseFromZoneIdFromJson(json);

  Map<String, dynamic> toJson() =>
      _$GardenEntityResponseFromZoneIdToJson(this);

  GardenEntityResponseFromZoneId({
    this.gardenId,
    this.name,
    this.area,
    this.areaUnit,
    this.managerId,
    this.treePlaceQuantity,
    this.zoneId,
  });

  GardenEntityResponseFromZoneId copyWith({
    String? id,
    String? gardenId,
    String? name,
    int? area,
    String? areaUnit,
    String? managerId,
    int? treePlaceQuantity,
    String? zoneId

  }) {
    return GardenEntityResponseFromZoneId(
        gardenId: gardenId ?? this.gardenId,
        name: name ?? this.name,
        area: area ?? this.area,
        areaUnit: areaUnit ?? this.areaUnit,
        managerId: managerId ?? this.managerId,
        treePlaceQuantity: treePlaceQuantity ?? this.treePlaceQuantity,
        zoneId: zoneId ?? this.zoneId
    );
  }
}
