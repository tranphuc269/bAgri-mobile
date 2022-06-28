part of 'otp_authentication_cubit.dart';

class OtpAuthenticationState extends Equatable {
  LoadStatus? OtpAuthStatus;

  List<Object?> get props => [
        this.OtpAuthStatus,
      ];

  OtpAuthenticationState({this.OtpAuthStatus});

  OtpAuthenticationState copyWith({
    LoadStatus? OtpAuthStatus,
}){
    return OtpAuthenticationState(OtpAuthStatus:OtpAuthStatus ?? this.OtpAuthStatus);
  }
}
