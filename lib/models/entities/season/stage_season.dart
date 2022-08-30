import 'package:flutter_base/models/entities/season/step_season.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stage_season.g.dart';

@JsonSerializable()
class StageSeason{
  String? name;
  @JsonKey(name: '_id')
  String? stage_id;
  List<StepSeason>? steps;
  int? aboutFrom;
  int? aboutTo;
  String? description;
  String? start;
  String? end;

  StageSeason(
      {this.name,
        this.stage_id,
        this.steps,
        this.aboutFrom,
        this.aboutTo,
        this.end,
        this.start,
        this.description});

  StageSeason copyWith({
    String? name,
    String? stage_id,
    String? description,
    int? aboutFrom,
    int? aboutTo,
    String? start,
    String? end,
    List<StepSeason>? steps,
  }) {
    return StageSeason(
        name: name ?? this.name,
        stage_id: stage_id ?? this.stage_id,
        steps: steps ?? this.steps,
        start: start?? this.start,
        end: end ?? this.end,
        aboutFrom: aboutFrom ?? this.aboutFrom,
        aboutTo: aboutTo ?? this.aboutTo,
        description: description ?? this.description);
  }

  @override
  List<Object?> get props =>
      [name, steps, stage_id, aboutFrom, start, end, aboutTo, description];
  factory StageSeason.fromJson(Map<String, dynamic> json) => StageSeason(
    name: json['name'] as String?,
    stage_id: json['_id'] as String?,
    steps: (json['steps'] as List<dynamic>?)
        ?.map((e) => StepSeason.fromJson(e as Map<String, dynamic>))
        .toList(),
    aboutFrom: json['aboutFrom'] as int?,
    aboutTo: json['aboutTo'] as int?,
    end: json['end'] as String?,
    start: json['start'] as String?,
    description: json['description'] as String?,
  );
  Map<String, dynamic> toJson() =><String, dynamic>{
    'name': this.name,
    if(this.stage_id != null) '_id': this.stage_id,
    'steps': this.steps,
    'aboutFrom': this.aboutFrom,
    'aboutTo': this.aboutTo,
    'description': this.description,
    'start': this.start,
    'end': this.end,
  };
}