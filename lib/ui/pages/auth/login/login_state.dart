part of 'login_cubit.dart';

enum LoginStatusBagri {
  INITIAL,
  LOADING,
  SUCCESS,
  FAILURE,
  USERNAME_PASSWORD_INVALID,
}

class LoginState extends Equatable {
  final LoginStatusBagri LoginStatus;
  final String phonenumber;
  final String password;
  final RoleEntity? role;

  LoginState(
      {this.LoginStatus = LoginStatusBagri.INITIAL,
      this.phonenumber = "",
      this.password = "",
      this.role});

  bool get isValid {
    if (isValidEmail || isValidPhone) {
      return true;
    } else {
      return false;
    }
  }

  bool get isValidEmail {
    return Validator.validateEmail(phonenumber);
  }

  bool get isValidPhone {
    return Validator.validatePhone(phonenumber);
  }

  LoginState copyWith({
    LoginStatusBagri? LoginStatus,
    String? username,
    String? password,
    RoleEntity? role,
  }) {
    return new LoginState(
      LoginStatus: LoginStatus ?? this.LoginStatus,
      phonenumber: username ?? this.phonenumber,
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [
        this.LoginStatus,
        this.phonenumber,
        this.password,
        this.role,
      ];
}
