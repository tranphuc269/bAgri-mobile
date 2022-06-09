part of 'account_list_cubit.dart';

class AccountListState extends Equatable {

  LoginStatusBagri? getListAccountStatus;
  LoadStatus? setRoleStatus;
  List<UserEntity>? listUserData;
  RoleEntity? role;
  bool? isSelectedRole;


  AccountListState({
    this.getListAccountStatus,
    this.listUserData,
    this.setRoleStatus,
    this.role,
    this.isSelectedRole
  });

  AccountListState copyWith({
    LoginStatusBagri? getListAccountStatus,
    LoadStatus? setRoleStatus,
    List<UserEntity>? listUserData,
    RoleEntity? role,
    bool? isSelectedRole
  }) {
    return AccountListState(
      getListAccountStatus: getListAccountStatus ?? this.getListAccountStatus,
      listUserData: listUserData ?? this.listUserData,
      setRoleStatus: setRoleStatus ?? this.setRoleStatus,
      role: role ?? this.role,
      isSelectedRole: isSelectedRole ?? this.isSelectedRole,
    );
  }


  @override
  List<Object?> get props => [
    this.getListAccountStatus,
    this.listUserData,
    this.setRoleStatus,
    this.role
  ];
}
