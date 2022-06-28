part of 'change_password_cubit.dart';

class ChangePasswordState extends Equatable {
  LoadStatus? loadStatus;
  String? messageError;

  @override
  List<Object?> get props => [
        this.loadStatus,
    this.messageError
      ];

  ChangePasswordState({
    this.loadStatus,
    this.messageError
  });

  ChangePasswordState copyWith({
    LoadStatus? loadStatus,
    String? messageError,
  }) {
    return ChangePasswordState(
      loadStatus: loadStatus ?? this.loadStatus,
      messageError: messageError ?? this.messageError
    );
  }
}
