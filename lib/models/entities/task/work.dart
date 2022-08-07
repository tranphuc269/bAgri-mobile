import 'package:json_annotation/json_annotation.dart';

part 'work.g.dart';

@JsonSerializable()
class Work{
  String? unit;
  int? unitPrice;
  String? title;
  int? quantity;

  Work({
    this.unit,
    this.title,
    this.unitPrice,
    this.quantity
});

  Work copyWith({
    String? unit,
    String? title,
    int? unitPrice,
    int? quantity
  }) {
    return Work(
      unit: unit ?? this.unit,
      title: title ?? this.title,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity
    );
  }

  factory Work.fromJson(Map<String, dynamic> json) =>
      _$WorkFromJson(json);
  Map<String, dynamic> toJson() => _$WorkToJson(this);
}