import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/models/entities/role/role_entity.dart';
import 'package:flutter_base/models/entities/user/user_entity.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/ui/components/app_button.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_error_list_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_snackbar.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_text_field.dart';
import 'package:flutter_base/ui/widgets/b_agri/drop_down_picker/app_manager_picker.dart';
import 'package:flutter_base/utils/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'garden_update_cubit.dart';


enum AreaUnit { Hecta, m2}
class UpdateGardenPage extends StatefulWidget {
  final String? garden_Id;
  final String? gardenName;
  final String? zoneName;

  UpdateGardenPage({this.garden_Id, this.gardenName, this.zoneName});
  @override
  _UpdateGardenPageState createState() => _UpdateGardenPageState();
}

class _UpdateGardenPageState extends State<UpdateGardenPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  AreaUnit areaUnit = AreaUnit.m2;

  var nameController = TextEditingController(text: "");
  var areaController = TextEditingController(text: "");
  var treePlaceQuantityControler = TextEditingController(text: "");
  GardenUpdateCubit? _cubit;

  List<UserEntity> noManagerData = [
    UserEntity(id: "NO_ID", name: "Chưa có quản lý vườn")
  ];

  UserEntity? _managerValue =
  UserEntity(id: "NO_ID", name: "Chọn quản lý vườn");
  List<String> _areaUnitList = ['m2',"hecta"];

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<GardenUpdateCubit>(context);
    //Set initial cubit
    _cubit!.getGardenData(widget.garden_Id);
    _cubit!.getListManager();


    _cubit!.changeName(nameController.text);
    _cubit!.changeArea(areaController.text);
    _cubit!.changeTreePlaceQuantity(treePlaceQuantityControler.text);

    nameController.addListener(() {
      _cubit!.changeName(nameController.text);
    });

    areaController.addListener(() {
      _cubit!.changeArea(areaController.text);
    });
    treePlaceQuantityControler.addListener(() {
      _cubit!.changeTreePlaceQuantity(treePlaceQuantityControler.text);
    });
  }

  @override
  void dispose() {
    _cubit!.close();
    nameController.dispose();
    areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBarWidget(
          title: widget.zoneName.toString(),
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

    return BlocConsumer<GardenUpdateCubit, GardenUpdateState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state.getListManagerStatus == LoadStatus.SUCCESS && state.getGardenDataStatus == LoadStatus.SUCCESS) {
            // nameController.text = state.gardenData!.gardenName ?? "";
            // areaController.text = state.gardenData!.area.toString();
            nameController = TextEditingController(text: _cubit!.state.gardenData!.gardenName);
            areaController = TextEditingController(text: (_cubit!.state.gardenData!.area).toString());
            treePlaceQuantityControler = TextEditingController(text: (_cubit!.state.gardenData!.treePlaceQuantity).toString());
          }
        },
        builder: (context, state) {
          if (state.getListManagerStatus == LoadStatus.LOADING
              || state.getGardenDataStatus == LoadStatus.LOADING
          ) {
            return Center(
                child: CircularProgressIndicator(
                  color: AppColors.main,
                ));
          } else if (state.getListManagerStatus == LoadStatus.FAILURE ||
              state.getGardenDataStatus == LoadStatus.FAILURE) {
            return AppErrorListWidget(
              onRefresh: _onRefreshData,
            );
          } else if (state.getListManagerStatus == LoadStatus.SUCCESS
              && state.getGardenDataStatus == LoadStatus.SUCCESS
          ) {
            // nameController = TextEditingController(text: state.gardenData!.gardenName);
            // areaController = TextEditingController(text: state.gardenData!.area. toString());
            // treeQuantityControler = TextEditingController(text: state.gardenData!.treePlaceQuantity.toString());
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
                                  autoValidateMode: AutovalidateMode.onUserInteraction,
                                  enable: state.editGardenStatus == LoadStatus.LOADING
                                      ? false
                                      : true,
                                  hintText: 'Nhập vào tên vườn',
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
                                  autoValidateMode: AutovalidateMode
                                      .onUserInteraction,
                                  controller: areaController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (Validator.validateNullOrEmpty(value!))
                                      return "Chưa nhập diện tích";
                                    else
                                      return null;
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Text("Đơn vị diện tích: ",
                                      style: AppTextStyle.greyS14,),
                                   SizedBox(width: 20,),
                                   _buildSelectAreaUnit(),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Số lượng cây trồng",
                                  style: AppTextStyle.greyS14,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                AppTextField(
                                  controller: treePlaceQuantityControler,
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
          }else{
            return AppErrorListWidget(
              onRefresh: _onRefreshData,
            );
          }
        }
    );
  }
  Widget _buildSelectAreaUnit(){
    String _defaultValue = _cubit!.state.gardenData!.areaUnit.toString() == "m2" ? "m²" : "Hecta";
    return Container(
      height: 45,
      width: MediaQuery
        .of(context)
        .size
        .width /3,
      child: DropdownButtonFormField<String>(
        value: _defaultValue,
        items: <String>["m²", "Hecta"].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
            alignment: AlignmentDirectional.centerStart,
          );
        }).toList(),
        icon: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(Icons.keyboard_arrow_down)),
        decoration: InputDecoration(
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
        onChanged: (value) {
          _defaultValue = value == "m²" ? "m2" : "Hecta";
          print(_defaultValue);
        },
      )
    );

  }
  Widget _buildSelectManager() {
    var index = _cubit!.state.listManager!.indexWhere((element) => element.id == _cubit!.state.gardenData!.managerId);
    UserEntity? defaultValue = _cubit!.state.listManager![index] as UserEntity;
    _managerValue = defaultValue;
    return DropdownButtonFormField(
              style: AppTextStyle.blackS16,
              value: defaultValue,
              icon: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(Icons.keyboard_arrow_down)),
              onChanged: (value) {
               _managerValue = value as UserEntity?;
               print(_managerValue!.username);
                // _cubit.changeManagerUsername()
               // _cubit!.state.listManager!.indexWhere((element) => element.id == _cubit!.state.gardenData!.manager["id"])
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
          }

  Widget _buildCreateButton() {
    return BlocConsumer<GardenUpdateCubit, GardenUpdateState>(
      bloc: _cubit,
      listenWhen: (prev, current) {
        return prev.updateGardenStatus != current.updateGardenStatus;
      },
      listener: (context, state) {
        if (state.updateGardenStatus == LoadStatus.SUCCESS) {
          _onRefreshData();
          _showCreateSuccess();
        }
        if (state.updateGardenStatus == LoadStatus.FAILURE) {
          showSnackBar('Có lỗi xảy ra!');
        }
      },
      builder: (context, state) {
        final isLoading = (state.updateGardenStatus == LoadStatus.LOADING);
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
                        Navigator.pop(context);
                      })),
              SizedBox(
                width: 30,
              ),
              Expanded(
                flex: 1,
                child: AppGreenButton(
                  title: 'Xác nhận',
                  onPressed: () {
                    print(areaController.text);
                    print(treePlaceQuantityControler.text);
                    print(widget.zoneName);
                    if (_formKey.currentState!.validate()) {
                      _cubit!.changeName(nameController.text);
                      _cubit!.changeArea(areaController.text);
                      _cubit!.changeManagerUsername(_managerValue!.username.toString());
                      _cubit!.changeArea(areaController.text);
                      _cubit!.changeTreePlaceQuantity(treePlaceQuantityControler.text);
                      _cubit!.changeAreaUnit(areaUnit.name);
                      _cubit!.updateGarden(
                          widget.garden_Id,
                          areaController.text,
                          treePlaceQuantityControler.text,
                          widget.zoneName.toString()
                      );
                    }
                    print(nameController.text);
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
  Widget _buildEditButton() {
    return BlocConsumer<GardenUpdateCubit, GardenUpdateState>(
      bloc: _cubit,
      listenWhen: (prev, current) {
        return prev.editGardenStatus != current.editGardenStatus;
      },
      listener: (context, state) {
        if (state.editGardenStatus == LoadStatus.SUCCESS) {
          _showCreateSuccess();
        }
        if (state.editGardenStatus == LoadStatus.FAILURE) {
          showSnackBar('Có lỗi xảy ra!');
        }
      },
      builder: (context, state) {
        final isLoading = (state.editGardenStatus == LoadStatus.LOADING);
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 60),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: AppRedButton(
                  title: 'Hủy bỏ',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              SizedBox(
                width: 30,
              ),
              Expanded(
                flex: 1,
                child: AppGreenButton(
                  title: 'Xác nhận',
                  onPressed: () {
                    _cubit!.updateGarden(
                        widget.garden_Id,
                        areaController.text,
                        treePlaceQuantityControler.text,
                        widget.zoneName.toString()
                    );
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

  void _showCreateSuccess() async {
    showSnackBar('Tạo mới vườn thành công!');
    Navigator.of(context).pop(true);
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(AppSnackBar(
      typeSnackBar: "success",
      message: message,
    ));
  }

  Future<void> _onRefreshData() async {
    _cubit!.getListManager();
  }
}
class GardenUpdateArgument {
  String? garden_Id;
  String? gardenName;
  String? zoneName;

  GardenUpdateArgument({this.garden_Id, this.gardenName, this.zoneName});
}
