part of 'forgot_password_cubit.dart';

class ForgotPasswordState extends Equatable {
  LoadStatus? loadStatus;
  String? messageError;



  @override
  List<Object?> get props => [
    this.loadStatus,
    this.messageError
      ];

  ForgotPasswordState({
    this.loadStatus,
    this.messageError
  });

  ForgotPasswordState copyWith({
    LoadStatus? loadStatus,
    String? messageError,

  }) {
    return ForgotPasswordState(
      loadStatus: loadStatus ?? this.loadStatus,
      messageError: messageError ?? this.messageError
    );
  }
}
