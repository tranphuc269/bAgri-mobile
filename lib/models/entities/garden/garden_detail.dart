import 'package:json_annotation/json_annotation.dart';

part 'garden_detail.g.dart';
@JsonSerializable()
class GardenDetailEntity {
  @JsonKey()
  GardenItemEntity? garden;

  GardenDetailEntity({
    this.garden,
  });

  GardenDetailEntity copyWith({
    GardenItemEntity? garden,
  }) {
    return GardenDetailEntity(
      garden: garden ?? this.garden,
    );
  }

  factory GardenDetailEntity.fromJson(Map<String, dynamic> json) =>
      _$GardenDetailEntityFromJson(json);
  Map<String, dynamic> toJson() => _$GardenDetailEntityToJson(this);
}

@JsonSerializable()
class GardenItemEntity {
  @JsonKey()
  String? gardenId;
  @JsonKey()
  String? name;
  @JsonKey()
  int? area;
  @JsonKey()
  ManagerEntity? manager;
  @JsonKey()
  List<SeasonWithGardenEntity>? seasons;

  GardenItemEntity({
    this.gardenId,
    this.name,
    this.area,
    this.manager,
    this.seasons,
  });

  GardenItemEntity copyWith({
    String? gardenId,
    String? name,
    int? area,
    ManagerEntity? manager,
    List<SeasonWithGardenEntity>? seasons,
  }) {
    return GardenItemEntity(
      gardenId: gardenId ?? this.gardenId,
      name: name ?? this.name,
      area: area ?? this.area,
      seasons: seasons ?? this.seasons,
    );
  }

  factory GardenItemEntity.fromJson(Map<String, dynamic> json) =>
      _$GardenItemEntityFromJson(json);
  Map<String, dynamic> toJson() => _$GardenItemEntityToJson(this);
}

@JsonSerializable()
class SeasonWithGardenEntity {
  String? name;
  String? season_id;
  String? start_date;
  String? end_date;
  String? status;

  factory SeasonWithGardenEntity.fromJson(Map<String, dynamic> json) =>
      _$SeasonWithGardenEntityFromJson(json);
  Map<String, dynamic> toJson() => _$SeasonWithGardenEntityToJson(this);

  SeasonWithGardenEntity({
    this.name,
    this.season_id,
    this.start_date,
    this.end_date,
    this.status,
  });

  SeasonWithGardenEntity copyWith({
    String? name,
    String? season_id,
    String? start_date,
    String? end_date,
    String? status,
  }) {
    return SeasonWithGardenEntity(
      name: name ?? this.name,
      season_id: season_id ?? this.season_id,
      start_date: start_date ?? this.start_date,
      end_date: end_date ?? this.end_date,
      status: status ?? this.status,
    );
  }
}

@JsonSerializable()
class ManagerEntity {
  String? manager_id;
  String? name;

  factory ManagerEntity.fromJson(Map<String, dynamic> json) =>
      _$ManagerEntityFromJson(json);
  Map<String, dynamic> toJson() => _$ManagerEntityToJson(this);

  ManagerEntity({
    this.manager_id,
    this.name,
  });

  ManagerEntity copyWith({
    String? manager_id,
    String? name,
  }) {
    return ManagerEntity(
      manager_id: manager_id ?? this.manager_id,
      name: name ?? this.name,
    );
  }
}
@JsonSerializable()
class GardenDetailEntityResponse{
  @JsonKey()
  String? gardenId;
  @JsonKey()
  String? gardenName;
  @JsonKey()
  int? area;
  @JsonKey()
  String? areaUnit;
  @JsonKey()
  String? managerId;
  @JsonKey()
  String? manager;
  @JsonKey()
  int? treePlaceQuantity;
  @JsonKey()
  String? zoneId;
  GardenDetailEntityResponse({
    this.gardenId,
    this.gardenName,
    this.area,
    this.areaUnit,
    this.managerId,
    this.manager,
    this.treePlaceQuantity,
    this.zoneId
  });
  GardenDetailEntityResponse copyWith({
    String? gardenId,
    String? gardenName,
    int? area,
    String? areaUnit,
    String? manangerId,
    String? manager,
    int? treePlaceQuantity,
    String? zoneId
  }) {
    return GardenDetailEntityResponse(
      gardenId: gardenId ?? this.gardenId,
      gardenName: gardenName ?? this.gardenName,
      area: area ?? this.area,
      areaUnit: areaUnit ?? this.areaUnit,
      manager: manager ?? this.manager,
      managerId: managerId ?? this.managerId,
      treePlaceQuantity: treePlaceQuantity ?? this.treePlaceQuantity,
      zoneId: zoneId ?? this.zoneId
    );
  }
  factory GardenDetailEntityResponse.fromJson(Map<String, dynamic> json) =>
      // _$GardenDetailEntityResponseFromJson(json);
  GardenDetailEntityResponse(
  gardenId: json['_id'] as String?,
  gardenName: json['name'] as String?,
  area: json['area'] as int?,
  areaUnit: json['areaUnit'] as String?,
  managerId: json['manager']['_id'] as String?,
  manager: json['manager']['name'] as String?,
  treePlaceQuantity: json['treePlaceQuantity'] as int?,
  zoneId: json['zone'] as String?,
  );
  Map<String, dynamic> toJson() => <String, dynamic>{
    'gardenId': this.gardenId,
    'gardenName': this.gardenName,
    'area': this.area,
    'areaUnit': this.areaUnit,
    'manager':{
      '_id': this.managerId,
      'name':this.manager
    },
    'treePlaceQuantity': this.treePlaceQuantity,
    'zone': {
      '_id':this.zoneId,
    }
  };

}