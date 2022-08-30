
import 'package:flutter_base/models/entities/zone/zone_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'garden_entity.g.dart';

@JsonSerializable()
class GardenListResponse {
  @JsonKey()
  List<GardenEntity>? gardens;

  GardenListResponse({
    this.gardens,
  });

  GardenListResponse copyWith({
    List<GardenEntity>? gardens,
  }) {
    return GardenListResponse(
      gardens: gardens ?? this.gardens,
    );
  }

  factory GardenListResponse.fromJson(Map<String, dynamic> json) =>
      _$GardenListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GardenListResponseToJson(this);
}

@JsonSerializable()
class GardenEntity {
  @JsonKey(name: "_id")
  String? garden_id;
  @JsonKey()
  String? name;
  @JsonKey()
  int? area;
  @JsonKey()
  String? areaUnit;
  @JsonKey()
  String? manager;
  @JsonKey()
  int? treePlaceQuantity;
  ZoneEntity? zone;


  factory GardenEntity.fromJson(Map<String, dynamic> json) =>
      // _$GardenEntityFromJson(json);
  GardenEntity(
    garden_id: json['_id'] as String?,
    name: json['name'] as String?,
    area: json['area'] as int?,
    areaUnit: json['areaUnit'] as String?,
    manager: json['manager'] as String?,
    treePlaceQuantity: json['treePlaceQuantity'] as int?,
    zone: json['zone'] == null
        ? null
        : ZoneEntity.fromJson(json['zone'] as Map<String, dynamic>),
  );
  Map<String, dynamic> toJson() => _$GardenEntityToJson(this);

  GardenEntity({
    this.garden_id,
    this.name,
    this.area,
    this.areaUnit,
    this.manager,
    this.treePlaceQuantity,
    this.zone,
  });

  GardenEntity copyWith({
    String? id,
    String? garden_id,
    String? name,
    int? area,
    String? areaUnit,
    String? manager,
    int? treePlaceQuantity,
    ZoneEntity? zone

  }) {
    return GardenEntity(
      garden_id: garden_id ?? this.garden_id,
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
  String? garden_id;
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

 /* GardenEntityResponseFromZoneId _$GardenEntityResponseFromZoneIdFromJson(
      Map<String, dynamic> json) =>*/
  //     GardenEntityResponseFromZoneId(
  //       garden_id: json['_id'] as String?,
  //       name: json['name'] as String?,
  //       area: json['area'] as int?,
  //       areaUnit: json['areaUnit'] as String?,
  //       managerId: json['manager'] as String?,
  //       treePlaceQuantity: json['treePlaceQuantity'] as int?,
  //       zone: json['zone'] == null
  //           ? null
  //           : ZoneEntity.fromJson(json['zone'] as Map<String, dynamic>),
  //     );
  Map<String, dynamic> toJson() =>
      _$GardenEntityResponseFromZoneIdToJson(this);

  GardenEntityResponseFromZoneId({
    this.garden_id,
    this.name,
    this.area,
    this.areaUnit,
    this.managerId,
    this.treePlaceQuantity,
    this.zoneId,
  });

  GardenEntityResponseFromZoneId copyWith({
    String? id,
    String? garden_id,
    String? name,
    int? area,
    String? areaUnit,
    String? managerId,
    int? treePlaceQuantity,
    String? zoneId

  }) {
    return GardenEntityResponseFromZoneId(
        garden_id: garden_id ?? this.garden_id,
        name: name ?? this.name,
        area: area ?? this.area,
        areaUnit: areaUnit ?? this.areaUnit,
        managerId: managerId ?? this.managerId,
        treePlaceQuantity: treePlaceQuantity ?? this.treePlaceQuantity,
        zoneId: zoneId ?? this.zoneId
    );
  }
}
