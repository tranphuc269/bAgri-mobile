part of 'registry_cubit.dart';

class RegistryState extends Equatable {
  LoadStatus? RegisterStatus;
  String? email;
  String? password;
  String? phone;
  String? name;
  String? messageError;
  @override
  List<Object?> get props => [
        this.RegisterStatus,
        this.email,
        this.password,
        this.phone,
        this.name,
        this.messageError
      ];

  RegistryState({
    this.RegisterStatus,
    this.email,
    this.password,
    this.phone,
    this.name,
    this.messageError,
  });

  RegistryState copyWith({
    LoadStatus? RegisterStatus,
    String? email,
    String? password,
    String? phone,
    String? name,
    String? messageError,
  }) {
    return RegistryState(
      RegisterStatus: RegisterStatus ?? this.RegisterStatus,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      messageError: messageError ?? this.messageError,
    );
  }
}
