
import 'package:json_annotation/json_annotation.dart';

part 'zone_entity.g.dart';

@JsonSerializable()
class ZoneEntity {
  String? zone_id;
  String? name;


  factory ZoneEntity.fromJson(Map<String, dynamic> json) => ZoneEntity(
    zone_id: json['_id'] as String?,
    name: json['name'] as String?,
  );

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        '_id': this.zone_id,
        'name': this.name,
      };


  ZoneEntity({
    this.zone_id,
    this.name,
  });

  ZoneEntity copyWith({
    String? zone_id,
    String? name,
  }) {
    return ZoneEntity(
      zone_id: zone_id ?? this.zone_id,
      name: name ?? this.name,
    );
  }
}

@JsonSerializable()
class ZoneListResponse {
  List<ZoneEntity>? zones;

  factory ZoneListResponse.fromJson(Map<String, dynamic> json) =>
      _$ZoneListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ZoneListResponseToJson(this);

  ZoneListResponse({
    this.zones,
  });

 ZoneListResponse copyWith({
    List<ZoneEntity>? zones,
  }) {
    return ZoneListResponse(
      zones: zones ?? this.zones
    );
  }
}
