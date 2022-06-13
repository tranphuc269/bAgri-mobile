import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_images.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/models/entities/role/role_entity.dart';
import 'package:flutter_base/models/entities/user/user_entity.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/ui/pages/account_management/account_list/account_list_cubit.dart';
import 'package:flutter_base/ui/pages/auth/login/login_cubit.dart';
import 'package:flutter_base/ui/pages/home/home_page.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_button.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_dropdown_button.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_emty_data_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_error_list_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_snackbar.dart';
import 'package:flutter_base/ui/widgets/b_agri/custome_slidable_widget.dart';
import 'package:flutter_base/utils/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AccountListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AccountListState();
}

class _AccountListState extends State<AccountListPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late List<RoleEntity> _roleList;
  AccountListCubit? _cubit;
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  bool isErrorMessage = false;
  late bool isChange = false;

  @override
  void initState() {
    _cubit = BlocProvider.of<AccountListCubit>(context);
    super.initState();
    _cubit!.changeRole(RoleEntity(role_id: "NO_ROLE", name: "No Role"));
    _cubit!.fetchAccountList();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBarWidget(
          title: 'Quản lý tài khoản',
          context: context,
        ),
        body: Container(
          child: BlocBuilder<AccountListCubit, AccountListState>(
            bloc: _cubit,
            buildWhen: (previous, current) =>
                previous.getListAccountStatus != current.getListAccountStatus,
            builder: (context, state) {
              if (state.getListAccountStatus == LoginStatusBagri.LOADING) {
                return Center(
                    child: CircularProgressIndicator(
                  color: AppColors.main,
                ));
              } else if (state.getListAccountStatus ==
                  LoginStatusBagri.FAILURE) {
                return AppErrorListWidget(
                  onRefresh: _onRefreshData,
                );
              } else if (state.getListAccountStatus ==
                  LoginStatusBagri.SUCCESS) {
                return state.listUserData!.length != 0
                    ? RefreshIndicator(
                        color: AppColors.main,
                        onRefresh: _onRefreshData,
                        child: ListView.separated(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 10, bottom: 25),
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: state.listUserData!.length,
                          shrinkWrap: true,
                          primary: false,
                          controller: _scrollController,
                          itemBuilder: (context, index) {
                            UserEntity user = state.listUserData![index];
                            return _buildItem(
                              name: user.name ?? "",
                              role: user.role ?? "",
                              phoneNumber: user.phoneNumber ?? "",
                              onPressed: () async {
                                showDialog(
                                    context: context,
                                    builder: (context) => _dialog(
                                          user: user,
                                          // role: user.role ?? "",
                                          id: user.id ?? "",
                                        ));
                              },
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 10);
                          },
                        ),
                      )
                    : Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: EmptyDataWidget(),
                            ),
                          ],
                        ),
                      );
              } else {
                return Container();
              }
            },
          ),
        ));
  }

  _buildItem(
      {required String name,
      required String role,
      required String phoneNumber,
      VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 75,
        decoration: BoxDecoration(
          color: AppColors.grayEC,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Slidable(
          endActionPane: ActionPane(
            extentRatio: 1 / 3,
            motion: BehindMotion(),
            children: [
              CustomSlidableAction(
                  backgroundColor: AppColors.blueSlideButton,
                  foregroundColor: Colors.white,
                  onPressed: (BuildContext context) {
                    // onUpdate?.call();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: Image.asset(AppImages.icSlideEdit),
                      ),
                      SizedBox(height: 4),
                      FittedBox(
                        child: Text(
                          'Sửa',
                          style: AppTextStyle.whiteS16,
                        ),
                      )
                    ],
                  )),
              CustomSlidable(
                  backgroundColor: AppColors.redSlideButton,
                  foregroundColor: Colors.white,
                  onPressed: (BuildContext context) {
                    // onDelete?.call();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: Image.asset(AppImages.icSlideDelete),
                      ),
                      SizedBox(height: 4),
                      FittedBox(
                        child: Text(
                          'Xóa',
                          style: AppTextStyle.whiteS16,
                        ),
                      )
                    ],
                  )),
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 15),
            child: Row(
              children: [
                Expanded(
                    child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: AppTextStyle.greyS16Bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Số điện thoại: ${phoneNumber}',
                          style: AppTextStyle.greyS14,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                    SizedBox(width: 40),
                    Text(
                      role,
                      style: AppTextStyle.greyS14Bold,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dialog({
    required UserEntity user,
    // {required String name,
    // required String phoneNumber,
    // required String role,
    required String id,
  }) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: const Text("Thông tin tài khoản"),
        content: Container(
            height: MediaQuery.of(context).size.height / 3.5,
            width: MediaQuery.of(context).size.width,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Họ và tên: ${user.name}",
                style: AppTextStyle.greyS18Bold,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10),
              Text(
                "Số điện thoại: ${user.phoneNumber}",
                style: AppTextStyle.greyS14,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10),
              Text(
                "Vai trò: ${user.role} ",
                style: AppTextStyle.greyS14,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10),
              _buildRoleOption(user: user),
              SizedBox(height: 10),
            ])),
      );
    });
  }

  Widget _buildRoleOption({required UserEntity user}) {
    RoleEntity _value = RoleEntity(role_id: "NO_ROLE", name: "No Role");
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(children: [
          AppRolePicker(
            onChange: (value) {
              setState(() {
                _value = value!;
              });
            },
            value: _value.role_id == "NO_ROLE" ? null : _value,
            hintText: "Thay đổi vai trò",
            autoValidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value!.role_id == "NO_ROLE")
                return "Chưa chọn vai trò";
              else
                return null;
            },
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                  height: 40,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: AppColors.redButton,
                  onPressed: (() => {Navigator.of(context).pop()}),
                  child: Text("Hủy",
                      style: TextStyle(color: Colors.white, fontSize: 14))),
              BlocConsumer<AccountListCubit, AccountListState>(
                  bloc: _cubit,
                  listenWhen: (prev, current) {
                    return (prev.setRoleStatus != current.setRoleStatus);
                  },
                  listener: (context, state) {
                    if (state.setRoleStatus == LoadStatus.SUCCESS) {
                      _showCreateSuccess();
                    }
                    if (state.setRoleStatus == LoadStatus.FAILURE) {
                      showSnackBar('Đã có lỗi xảy ra ');
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state.setRoleStatus == LoadStatus.LOADING;
                    if (isErrorMessage) {
                      return SizedBox(
                        height: 40,
                      );
                    }
                    return AppButton(
                        color: AppColors.main,
                        isLoading: isLoading,
                        title: "Xác nhận",
                        onPressed: isLoading
                            ? null
                            : () async {
                                if (_value.role_id == "NO_ROLE") {
                                  showSnackBar("Vui lòng chọn vai trò!");
                                } else {
                                  await _cubit!.setRole(user.id.toString(),
                                      _value.role_id.toString());
                                  Navigator.of(context).pop();
                                  _onRefreshData();
                                }
                              });
                  })
            ],
          )
        ]));
  }

  Future<void> _onRefreshData() async {
    _cubit!.fetchAccountList();
  }

  void _showCreateSuccess() async {
    showSnackBar('Cấp quyền thành công!');
  }

  void showSnackBar(String message) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(AppSnackBar(
      typeSnackBar: "success",
      message: message,
    ));
    setState(() {
      isErrorMessage = true;
    });
    await Future.delayed(Duration(milliseconds: 2200));
    setState(() {
      isErrorMessage = false;
    });
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      // _cubit!.fetchNextGardenData();
    }
  }
}
