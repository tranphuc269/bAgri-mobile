import 'package:json_annotation/json_annotation.dart';

part 'user_entity.g.dart';
@JsonSerializable()
class UserEntity {
  @JsonKey(name: "_id")
  String? id;
  String? name;
  String? role;
  String? phone;
  String? email;


  UserEntity({
    this.id,
    this.name,
    this.role,
    this.phone,
    this.email

  });

  UserEntity copyWith({
    String? id,
    String? name,
    String? role,
    String? phone,
    String? email
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      email: email ?? this.email
    );
  }

  factory UserEntity.fromJson(Map<String, dynamic> json) => UserEntity(
    id: json['_id'] as String?,
    name: json['name'] as String?,
    role: json['role'] as String?,
    phone: json['phone'] as String?,
    email: json['email'] as String?,
  );

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        '_id': this.id,
        'name': this.name,
        'role': this.role,
        'phoneNumber': this.phone,
        'email': this.email
      };
}
