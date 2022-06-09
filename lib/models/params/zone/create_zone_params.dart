import 'package:json_annotation/json_annotation.dart';
part 'create_zone_params.g.dart';

@JsonSerializable()
class CreateZoneParam {
  @JsonKey()
  String? name;

  CreateZoneParam({
    this.name,
  });

  CreateZoneParam copyWith({
    String? name,
  }) {
    return CreateZoneParam(
      name: name ?? this.name,
    );
  }

  factory CreateZoneParam.fromJson(Map<String, dynamic> json) =>
      _$CreateZoneParamFromJson(json);

  Map<String, dynamic> toJson() => _$CreateZoneParamToJson(this);
}
