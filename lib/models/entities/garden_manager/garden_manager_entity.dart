import 'package:json_annotation/json_annotation.dart';

part 'garden_manager_entity.g.dart';

@JsonSerializable()
class GardenManagerEntity {
  String? fullname;
  String? id;

  factory GardenManagerEntity.fromJson(Map<String, dynamic> json) =>
      _$GardenManagerEntityFromJson(json);

  Map<String, dynamic> toJson() => _$GardenManagerEntityToJson(this);

  GardenManagerEntity({
    this.fullname,
    this.id,
  });

  GardenManagerEntity copyWith({
    String? fullname,
    String? id,
  }) {
    return GardenManagerEntity(
      fullname: fullname ?? this.fullname,
      id: id ?? this.id,
    );
  }
}
