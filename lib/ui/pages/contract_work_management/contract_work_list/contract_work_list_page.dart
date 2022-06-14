import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_images.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/models/entities/garden/garden_detail.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/ui/pages/contract_work_management/contract_work_list/contract_work_list_cubit.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_button.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_emty_data_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_error_list_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_text_field.dart';
import 'package:flutter_base/ui/widgets/b_agri/custome_slidable_widget.dart';
import 'package:flutter_base/utils/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

enum Unit{Cong, Dong}
class ContractWorkListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ContractWorkListState();
}

class _ContractWorkListState extends State<ContractWorkListPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final formatCurrency = new NumberFormat.currency(locale: 'vi');
  Unit unit = Unit.Dong;
  String _unitValue = "Đồng/bầu";

  final _unitPriceController = TextEditingController(text: '');
  final _contentController = TextEditingController(text: '');

  ContractWorkListCubit? _cubit;
  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<ContractWorkListCubit>(context);
    _cubit!.fetchContractWorkList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBarWidget(
        title: 'Quản lý công việc khoán',
        context: context,
      ),
      body: Container(
        child: BlocBuilder<ContractWorkListCubit,ContractWorkListState>(
          bloc: _cubit,
          buildWhen: (previous, current) =>
          previous.getListWorkStatus != current.getListWorkStatus,
          builder: (context, state) {
            if (state.getListWorkStatus == LoadStatus.LOADING) {
              return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.main,
                  ));
            } else if (state.getListWorkStatus ==
                LoadStatus.FAILURE) {
              return AppErrorListWidget(
                onRefresh: _onRefreshData,
              );
            } else if (state.getListWorkStatus ==
                LoadStatus.SUCCESS) {
              return Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [EmptyDataWidget()],
                ),
              );
              //   state.listUserData!.length != 0
              //     ? RefreshIndicator(
              //   color: AppColors.main,
              //   onRefresh: _onRefreshData,
              //   child: ListView.separated(
              //     padding: EdgeInsets.only(
              //         left: 10, right: 10, top: 10, bottom: 25),
              //     physics: AlwaysScrollableScrollPhysics(),
              //     itemCount: state.listUserData!.length,
              //     shrinkWrap: true,
              //     primary: false,
              //     controller: _scrollController,
              //     itemBuilder: (context, index) {
              //       UserEntity user = state.listUserData![index];
              //       return _buildItem(
              //         name: user.name ?? "",
              //         role: user.role ?? "",
              //         phoneNumber: user.phoneNumber ?? "",
              //
              //         onPressed: () async {
              //           showDialog(
              //               context: context,
              //               builder: (context) => _dialog(
              //                 user: user,
              //                 // role: user.role ?? "",
              //                 id: user.id ?? "",
              //               ));
              //         },
              //       );
              //     },
              //     separatorBuilder: (context, index) {
              //       return SizedBox(height: 10);
              //     },
              //   ),
              // )
              //     : Expanded(
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Center(
              //         child: EmptyDataWidget(),
              //       ),
              //     ],
              //   ),
              // );
            } else {
              return Container();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "btn2",
        onPressed: () async {
          _cubit!.createContractWork();
          // showDialog(
          //     context: context,
          //     builder: (context) =>
          //         _dialogCreate(title: Text("Thêm công việc khoán")));
          // bool isAdd = await Application.router
          //     ?.navigateTo(context, Routes.treeCreate);
          // if (isAdd) {
          //   _onRefreshData();
          // }
        },
        backgroundColor: AppColors.main,
        child: Icon(
          Icons.add,
          size: 40,
        ),
      ),
    );
  }

  _buildItem(
      {required String title,
      required String unit,
      required String unitPrice,
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
                          "Nội dung: ${title}",
                          style: AppTextStyle.greyS16Bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(mainAxisSize: MainAxisSize.min, children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(
                              'Đơn giá: ${formatCurrency.format(num.parse(unitPrice))}',
                              style: AppTextStyle.greyS14,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: Text(
                              'Đơn vị: ${unit}',
                              style: AppTextStyle.greyS14,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ])
                      ],
                    ),
                  ],
                )),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dialogCreate({
    Text? title,
  }) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
          title: title,
          content: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: double.infinity,
              ),
              // width: MediaQuery.of(context).size.width +20,
              child: Form(
                key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextLabel("Nội dung:"),
                        _buildContentInput(),
                        _buildTextLabel("Đơn giá:"),
                        _buildUnitPriceInput(),
                        _buildTextLabel("Đơn vị:"),
                        Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor: AppColors.main
                          ),
                          child:Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: RadioListTile(
                                  activeColor: AppColors.main,
                                  title: Text("Đồng/bầu", style: AppTextStyle.greyS16Bold),
                                  value: Unit.Dong,
                                  groupValue: unit,
                                  onChanged: (value){
                                    setState(() {
                                      unit = value as Unit;
                                      handleUnitChange("Đồng/bầu");
                                      print(_unitValue);
                                    });
                                  },
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                  child: RadioListTile(
                                    activeColor: AppColors.main,
                                    title: Text("Công", style: AppTextStyle.greyS16Bold),
                                    value: Unit.Cong,
                                    groupValue: unit,
                                    onChanged:(value){
                                      setState(() {
                                        unit = value as Unit;
                                        handleUnitChange("Công");
                                        print(_unitValue);
                                      });
                                    },
                                  )
                              ),
                            ],
                          ) ,
                        )

                      ])
              ),
            ),
          ),
        actions: [
          TextButton(
              onPressed:(){
                Navigator.of(context).pop();
                _contentController.clear();
                _unitPriceController.clear();
              },
              child: Text("Hủy", style: AppTextStyle.redS16)),
          TextButton(
              onPressed:(){
                if (_formKey.currentState!.validate()) {
                  // await _cubit!.createZone(_nameZoneController.text);
                  // if(state.createZoneStatus == LoadStatus.FAILURE){
                  //   Navigator.pop(context, false);
                  // } else{
                  //   Navigator.pop(context, true);
                  // }
                  print("hello");
                }
              },
              child: Text("Thêm", style: AppTextStyle.greenS16,))
        ],
      );
    });
  }

  Widget _buildTextLabel(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 28),
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
            text: text,
            style: AppTextStyle.blackS14,
          ),
        ]),
      ),
    );
  }
  Widget _buildContentInput() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: AppTextField(
        autoValidateMode: AutovalidateMode.onUserInteraction,
        hintText: "Nhập vào tên công việc",
        controller: _contentController,
        validator: (value) {
          if (Validator.validateNullOrEmpty(value!))
            return "Chưa nhập tên công việc";
          else
            return null;
        },
      ),
    );
  }
  Widget _buildUnitPriceInput() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: AppTextField(
        autoValidateMode: AutovalidateMode.onUserInteraction,
        hintText: "Nhập vào đơn giá",
        controller: _unitPriceController,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (Validator.validateNullOrEmpty(value!))
            return "Chưa nhập đơn giá";
          else
            return null;
        },
      ),
    );
  }
  Widget _buildConfirmCreateButton() {
    // return BlocBuilder<ContractWorkListCubit, ContractWorkListState>(
    //   bloc: _cubit,
    //   buildWhen: (prev, current) {
    //     return (prev.getListWorkStatus != current.getListWorkStatus);
    //   },
    //   builder: (context, state) {
    return Container(
      height: 40,
      child: AppButton(
        color: AppColors.main,
        title: "Thêm",
        textStyle: AppTextStyle.whiteS16Bold,
        onPressed: () async {
          // if (_formKey.currentState!.validate()) {
          //   await _cubit!.createZone(_nameZoneController.text);
          //   if(state.createZoneStatus == LoadStatus.FAILURE){
          //     Navigator.pop(context, false);
          //   } else{
          //     Navigator.pop(context, true);
          //   }
          //}
        },
      ),
    );
    //   },
    // );
  }

  Future<void> _onRefreshData() async {
    // _cubit!.fetchAccountList();
    print("refreshData");
  }
  void handleUnitChange(String value){
    setState(() {
      _unitValue = value;
    });
  }
}
