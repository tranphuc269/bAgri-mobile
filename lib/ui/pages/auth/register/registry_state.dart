part of 'registry_cubit.dart';

class RegistryState extends Equatable {
  LoadStatus? RegisterStatus;
  String? username;
  String? password;
  String? phone;
  String? fullName;
  String? messageError;
  @override
  List<Object?> get props => [
        this.RegisterStatus,
        this.username,
        this.password,
        this.phone,
        this.fullName,
        this.messageError
      ];

  RegistryState({
    this.RegisterStatus,
    this.username,
    this.password,
    this.phone,
    this.fullName,
    this.messageError,
  });

  RegistryState copyWith({
    LoadStatus? RegisterStatus,
    String? username,
    String? password,
    String? phone,
    String? fullName,
    String? messageError,
  }) {
    return RegistryState(
      RegisterStatus: RegisterStatus ?? this.RegisterStatus,
      username: username ?? this.username,
      password: password ?? this.password,
      phone: phone ?? this.phone,

      fullName: fullName ?? this.fullName,
      messageError: messageError ?? this.messageError,
    );
  }
}
