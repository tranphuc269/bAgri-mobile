import 'package:json_annotation/json_annotation.dart';

part 'step_season.g.dart';
@JsonSerializable()
class StepSeason {

  String? step_id;
  @JsonKey(name: 'aboutFrom')
  int? from_day;
  @JsonKey(name: 'aboutTo')
  int? to_day;
  String? name;
  String? description;
  // @JsonKey(name: 'actualDay')
  // int? actual_day;
  String? start;
  String? end;

  StepSeason({
    this.step_id,
    this.from_day,
    this.to_day,
    this.name,
    this.description,
    this.start,
    this.end,
    // this.actual_day,
  });

  @override
  List<Object?> get props =>
      [step_id, from_day, to_day, name,/* actual_day,*/ description, start, end];

  factory StepSeason.fromJson(Map<String, dynamic> json) => StepSeason(
    step_id: json['_id'] as String?,
    from_day: json['aboutFrom'] as int?,
    to_day: json['aboutTo'] as int?,
    name: json['name'] as String?,
    description: json['description'] as String?,
    start: json['start'] as String?,
    end: json['end'] as String?,
    // actual_day: json['actualDay'] as int?,
  );
  Map<String, dynamic> toJson() => <String, dynamic>{
    if(this.step_id != null) '_id': this.step_id,
    'aboutFrom': this.from_day,
    'aboutTo': this.to_day,
    'name': this.name,
    'description': this.description,
    // 'actualDay': this.actual_day,
    'start': this.start,
    'end': this.end,
  };
}
