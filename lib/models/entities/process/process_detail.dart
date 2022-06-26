import 'package:json_annotation/json_annotation.dart';

import 'list_process.dart';

part 'process_detail.g.dart';

@JsonSerializable()
class ProcessDetailResponse {
  ProcessEntity? process;

  factory ProcessDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$ProcessDetailResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ProcessDetailResponseToJson(this);

  ProcessDetailResponse({
    this.process,
  });

  ProcessDetailResponse copyWith({
    ProcessEntity? process,
  }) {
    return ProcessDetailResponse(
      process: process ?? this.process,
    );
  }
}

