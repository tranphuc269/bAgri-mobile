
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'step_entity.g.dart';

// @JsonSerializable()
class StepEntity extends Equatable {
  String? step_id;
  int? from_day;
  int? to_day;
  String? name;
  // String? stage_id;
  String? description;
  int? actual_day;

  // @JsonKey(ignore: true)
  // int? startDay;
  // @JsonKey(ignore: true)
  // int? endDay;

  // factory StepEntity.fromJson(Map<String, dynamic> json) =>
  //     _$StepEntityFromJson(json);
  //
  // Map<String, dynamic> toJson() => _$StepEntityToJson(this);
  factory StepEntity.fromJson(dynamic json){
    StepEntity stepEntity = StepEntity(
        step_id: json["_id"] as String?,
        description: json["description"] as String?,
        actual_day: json["actual_day"] as int?,
        name: json["name"] as String?,
        from_day: json["aboutFrom"] as int?,
        to_day: json["aboutTo"] as int?
    );
    return stepEntity;
  }
  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        '_id': this.step_id,
        'name': this.name,
        'aboutTo': this.to_day,
        'aboutFrom': this.from_day,
        'actual_day': this.actual_day,
        'description': this.description
      };

  @override
  List<Object?> get props =>
      [step_id, from_day, to_day, name,  actual_day, description];

  StepEntity({
    this.step_id,
    this.from_day,
    this.to_day,
    this.name,
    // this.stage_id,
    this.description,
    // this.startDay,
    // this.endDay,
    this.actual_day,
  });

  StepEntity copyWith({
    String? step_id,
    int? from_day,
    int? to_day,
    String? name,
    // String? stage_id,
    int? actual_day,
    // int? startDay,
    // int? endDay,
  }) {
    return StepEntity(
        step_id: step_id ?? this.step_id,
        from_day: from_day ?? this.from_day,
         to_day: to_day ?? this.to_day,
        name: name ?? this.name,
        // stage_id: stage_id ?? this.stage_id,
        actual_day: actual_day ?? this.actual_day,
        // startDay: startDay ?? this.startDay,
        // endDay: endDay ?? this.endDay,
        description: description ?? this.description);
  }
}

@JsonSerializable()
class StepEntityResponseByDay{
  String? season;
  num? treeQuantity;
  String? garden;
  DateTime? start;
  DateTime? end;
  String? tree;
  String? name;
  num? aboutFrom;
  num? aboutTo;
  String? description;

  factory StepEntityResponseByDay.fromJson(Map<String, dynamic> json) =>
      _$StepEntityResponseByDayFromJson(json);
  Map<String, dynamic> toJson() => _$StepEntityResponseByDayToJson(this);

  StepEntityResponseByDay({
    this.season,
    this.treeQuantity,
    this.garden,
    this.start,
    this.end,
    this.tree,
    this.name,
    this.aboutFrom,
    this.aboutTo,
    this.description});

  StepEntityResponseByDay copyWith({
    String? season,
    num? treeQuantity,
    String? garden,
    DateTime? start,
    DateTime? end,
    String? tree,
    String? name,
    num? aboutFrom,
    num? aboutTo,
    String? description,
  }){
    return StepEntityResponseByDay(
        season: season ?? this.season,
        treeQuantity: treeQuantity ?? this.treeQuantity,
        garden: garden ?? this.garden,
        start: start ?? this.start,
        tree:  tree ?? this.tree,
        aboutFrom: aboutFrom ?? aboutFrom,
        aboutTo: aboutTo ?? aboutTo,
        description: description ?? this.description
    );
  }

}