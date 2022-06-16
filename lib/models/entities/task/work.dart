import 'package:json_annotation/json_annotation.dart';

part 'work.g.dart';

@JsonSerializable()
class Work{
  @JsonKey(name: '_id')
  String? workId;
  String? unit;
  int? unitPrice;
  String? title;

  Work({
    this.unit,
    this.title,
    this.unitPrice,
    this.workId
});

  Work copyWith({
    String? workId,
    String? unit,
    String? title,
    int? unitPrice
  }) {
    return Work(
      workId: workId ?? this.workId,
      unit: unit ?? this.unit,
      title: title ?? this.title,
      unitPrice: unitPrice ?? this.unitPrice
    );
  }

  factory Work.fromJson(Map<String, dynamic> json) =>
      _$WorkFromJson(json);
  Map<String, dynamic> toJson() => _$WorkToJson(this);
}