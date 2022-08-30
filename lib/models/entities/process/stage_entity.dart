import 'package:equatable/equatable.dart';
import 'package:flutter_base/models/entities/process/step_entity.dart';

// part 'stage_entity.g.dart';

// @JsonSerializable()
class StageEntity extends Equatable {
  String? name;
  String? stage_id;
  List<StepEntity>? steps;
  int? aboutFrom;
  int? aboutTo;
  String? description;


  // factory StageEntity.fromJson(Map<String, dynamic> json) =>
  //     _$StageEntityFromJson(json);
  // Map<String, dynamic> toJson() => _$StageEntityToJson(this);
  factory StageEntity.fromJson(dynamic json) {
    List<StepEntity>? list =[];
    json["steps"].forEach(
        (e){
          StepEntity stepEntity = StepEntity.fromJson(e);
          list.add(stepEntity);
        }
    );
    StageEntity stageEntity = StageEntity(
        stage_id: json["_id"],
        description: json["description"],
        name: json["name"],
        steps: list
    );
    return stageEntity;
  }
  Map<String, dynamic> toJson() => <String, dynamic>{
        '_id': this.stage_id,
        'name': this.name,
        'description': this.description,
        'steps': this.steps!.map((e) => e.toJson()).toList()
      };

  StageEntity(
      {this.name,
      this.stage_id,
      this.steps,
      this.aboutFrom,
      this.aboutTo,
      this.description});

  StageEntity copyWith({
    String? name,
    String? stage_id,
    String? description,
    int? aboutFrom,
    int? aboutTo,
    List<StepEntity>? steps,
  }) {
    return StageEntity(
        name: name ?? this.name,
        stage_id: stage_id ?? this.stage_id,
        steps: steps ?? this.steps,
        aboutFrom: aboutFrom ?? this.aboutFrom,
        aboutTo: aboutTo ?? this.aboutTo,
        description: description ?? this.description);
  }

  @override
  List<Object?> get props =>
      [name, steps, stage_id, aboutFrom, aboutTo, description];
}
