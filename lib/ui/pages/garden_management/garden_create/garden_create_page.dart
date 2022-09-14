import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/models/entities/user/user_entity.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/ui/components/app_button.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_error_list_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_text_field.dart';
import 'package:flutter_base/utils/validators.dart';
import 'package:flutter_base/ui/widgets/app_snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'garden_create_cubit.dart';


enum AreaUnit { Hecta, m2}
class CreateGardenPage extends StatefulWidget {
  final String? zoneId;
  final String? zoneName;

  CreateGardenPage({this.zoneId, this.zoneName});
  @override
  _CreateGardenPageState createState() => _CreateGardenPageState();
}

class _CreateGardenPageState extends State<CreateGardenPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late StreamSubscription _showMessageSubscription;

  AreaUnit areaUnit = AreaUnit.m2;
  final nameController = TextEditingController(text: "");
  final areaController = TextEditingController(text: "");
  final treeQuantityControler = TextEditingController(text: "");

  GardenCreateCubit? _cubit;

  List<UserEntity> noManagerData = [
    UserEntity(id: "NO_ID", name: "Chưa có quản lý vườn")
  ];
  UserEntity? _managerValue =
      UserEntity(id: "NO_ID", name: "Chọn quản lý vườn");

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<GardenCreateCubit>(context);

    //Set initial cubit
    _cubit!.changeName(nameController.text);
    _cubit!.changeArea(areaController.text);
    _cubit!.getListManager();

    nameController.addListener(() {
      _cubit!.changeName(nameController.text);
    });

    areaController.addListener(() {
      _cubit!.changeArea(areaController.text);
    });

    _showMessageSubscription =
        _cubit!.showMessageController.stream.listen((event) {
          _showMessage(event);
        });
  }

  @override
  void dispose() {
    _cubit!.close();
    nameController.dispose();
    areaController.dispose();
    _showMessageSubscription.cancel();
    super.dispose();
  }

  void _showMessage(SnackBarMessage message) {
    _scaffoldKey.currentState!.removeCurrentSnackBar();
    _scaffoldKey.currentState!.showSnackBar(AppSnackBar(message: message));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBarWidget(
          title: 'Thêm mới vườn',
          context: context,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 26),
            Expanded(flex: 4, child: _buildBodyWidget(context)),
            Expanded(flex: 1, child: _buildCreateButton()),
          ],
        ));
  }

  Widget _buildBodyWidget(BuildContext context) {
    return SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            Container(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tên vườn",
                          style: AppTextStyle.greyS14,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        AppTextField(
                          hintText: "Nhập vào tên vườn",
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          controller: nameController,
                          validator: (value) {
                            if (Validator.validateNullOrEmpty(value!))
                              return "Chưa nhập tên vườn";
                            else
                              return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Diện tích",
                          style: AppTextStyle.greyS14,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        AppTextField(
                          hintText: "Nhập vào diện tích",
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          controller: areaController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (Validator.validateNullOrEmpty(value!))
                              return "Chưa nhập diện tích";
                            else
                              return null;
                          },
                        ),
                        Row(
                          children: [
                            Text("Đơn vị diện tích: ", style: AppTextStyle.greyS14,),
                            Flexible(
                              fit: FlexFit.loose,
                              child: RadioListTile(
                                title: Text("m²", style: AppTextStyle.greyS16Bold),
                                value: AreaUnit.m2,
                                groupValue: areaUnit,
                                onChanged: (value){
                                  setState(() {
                                    areaUnit = value as AreaUnit;
                                    // print(value.name);
                                  });
                                },
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: RadioListTile(
                                title: Text("ha", style: AppTextStyle.greyS16Bold),
                                value: AreaUnit.Hecta,
                                groupValue: areaUnit,
                                onChanged: (value){
                                  setState(() {
                                    areaUnit = value as AreaUnit;
                                    // print(areaUnit.name);
                                  });
                                  },
                            )
                            ),
                          ],
                        ),
                        Text(
                          "Số lượng cây trồng",
                          style: AppTextStyle.greyS14,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        AppTextField(
                          controller: treeQuantityControler,
                          hintText: "Nhập vào số lượng cây trồng của vườn",
                          validator: (value) {
                            if (Validator.validateNullOrEmpty(value!))
                              return "Chưa nhập số lượng cây trồng";
                            else
                              return null;
                          },
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Người quản lý',
                          style: AppTextStyle.greyS14,
                        ),
                        SizedBox(height: 10),
                        _buildSelectManager(),
                      ],
                    ),
                  )),
            )
          ],
        ));
  }

  Widget _buildSelectManager() {
    return Container(
      child: BlocBuilder<GardenCreateCubit, GardenCreateState>(
        bloc: _cubit,
        buildWhen: (previous, current) =>
            previous.getListManagerStatus != current.getListManagerStatus,
        builder: (context, state) {
          if (state.getListManagerStatus == LoadStatus.LOADING) {
            return Center(
                child: CircularProgressIndicator(
              color: AppColors.main,
            ));
          } else if (state.getListManagerStatus == LoadStatus.FAILURE) {
            return AppErrorListWidget(
              onRefresh: _onRefreshData,
            );
          } else if (state.getListManagerStatus == LoadStatus.SUCCESS) {
            return DropdownButtonFormField(
              style: AppTextStyle.blackS16,
              icon: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(Icons.keyboard_arrow_down)),
              onChanged: (value) {
                _cubit!.state.listManager!.length > 0
                    ? setState(() {
                        _managerValue = value! as UserEntity?;
                        _cubit!.changeManagerPhone(_managerValue!.phone.toString());
                      })
                    : setState(() {
                        _managerValue = value! as UserEntity?;
                      });
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (_managerValue!.id == 'NO_ID') {
                  return "Vui lòng chọn quản lý vườn";
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                hintText: "Chọn quản lý vườn ",
                hintStyle: AppTextStyle.greyS16,
                contentPadding:
                    EdgeInsets.only(top: 10, right: 10, bottom: 10, left: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.lineGray),
                ),
                disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.main),
                    borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.main),
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.main),
                    borderRadius: BorderRadius.circular(10)),
              ),
              isExpanded: true,
              items: _cubit!.state.listManager!.length > 0
                  ? _cubit!.state.listManager!.map((value) {
                      return DropdownMenuItem<UserEntity>(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(value.name ?? ""),
                        value: value,
                      );
                    }).toList()
                  : noManagerData.map((value) {
                      return DropdownMenuItem<UserEntity>(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(value.name ?? ""),
                        value: value,
                      );
                    }).toList(),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildCreateButton() {
    return BlocConsumer<GardenCreateCubit, GardenCreateState>(
      bloc: _cubit,
      listenWhen: (prev, current) {
        return prev.createGardenStatus != current.createGardenStatus;
      },
      listener: (context, state) {
        if (state.createGardenStatus == LoadStatus.SUCCESS) {
          Navigator.of(context).pop(true);
        }
      },
      builder: (context, state) {
        final isLoading = (state.createGardenStatus == LoadStatus.LOADING);
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 60),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 1,
                  child: AppRedButton(
                      title: 'Hủy bỏ',
                      onPressed: () async {
                        Navigator.of(context).pop(true);
                      })),
              SizedBox(
                width: 30,
              ),
              Expanded(
                flex: 1,
                child: AppGreenButton(
                  title: 'Xác nhận',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _cubit!.createGarden(areaUnit.name, widget.zoneName.toString(), treeQuantityControler.text);
                    }
                  },
                  isLoading: isLoading,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  Future<void> _onRefreshData() async {
    _cubit!.getListManager();
  }
}
class GardenCreateArgument {
  String? zoneId;
  String? zoneName;

  GardenCreateArgument({this.zoneId, this.zoneName});
}
