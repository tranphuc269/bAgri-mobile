import 'package:json_annotation/json_annotation.dart';

part 'user_entity.g.dart';

// @JsonSerializable()
// class UserInfoResponse {
//   UserEntity? me;
//
//   UserInfoResponse({
//     this.me,
//   });
//
//   UserInfoResponse copyWith({
//     UserEntity? me,
//   }) {
//     return UserInfoResponse(
//       me: me ?? this.me,
//     );
//   }
//
//   factory UserInfoResponse.fromJson(Map<String, dynamic> json) =>
//       _$UserInfoResponseFromJson(json);
//   Map<String, dynamic> toJson() => _$UserInfoResponseToJson(this);
// }

@JsonSerializable()
class UserEntity {
  String? id;
  String? username;
  String? name;
  String? role;
  String? phoneNumber;


  UserEntity({
    this.id,
    this.username,
    this.name,
    this.role,
    this.phoneNumber,

  });

  UserEntity copyWith({
    String? id,
    String? username,
    String? name,
    String? role,
    String? phoneNumber,
  }) {
    return UserEntity(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  // factory UserEntity.fromJson(Map<String, dynamic> json) =>
  //     _$UserEntityFromJson(json);
  // Map<String, dynamic> toJson() => _$UserEntityToJson(this);

  factory UserEntity.fromJson(Map<String, dynamic> json) => UserEntity(
    id: json['_id'] as String?,
    username: json['username'] as String?,
    name: json['name'] as String?,
    role: json['role'] as String?,
    phoneNumber: json['phoneNumber'] as String?,
  );

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        '_id': this.id,
        'username': this.username,
        'name': this.name,
        'role': this.role,
        'phoneNumber': this.phoneNumber,
      };
}
