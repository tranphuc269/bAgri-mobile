import 'package:json_annotation/json_annotation.dart';

part 'login_model.g.dart';

@JsonSerializable()
class LoginResponseEntity {
  @JsonKey()
  String? status;
  @JsonKey()
  TokenEntity? data;

  LoginResponseEntity({
    this.status,
    this.data,
  });

  LoginResponseEntity copyWith({
    String? status,
    TokenEntity? data,
  }) {
    return LoginResponseEntity(
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }

  factory LoginResponseEntity.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseEntityFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseEntityToJson(this);
}

@JsonSerializable()
class TokenEntity {
  @JsonKey()
  String? access_token;

  TokenEntity({
    this.access_token,
  });

  TokenEntity copyWith({
    String? token,
    String? user_id,
  }) {
    return TokenEntity(
      access_token: access_token ?? this.access_token,
    );
  }
  factory TokenEntity.fromJson(Map<String, dynamic> json) =>
      _$TokenEntityFromJson(json);
  Map<String, dynamic> toJson() => _$TokenEntityToJson(this);
}
