import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_images.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/models/entities/contract_work/contract_work.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/ui/pages/contract_work_management/contract_work_list/contract_work_list_cubit.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_button.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_delete_dialog.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_emty_data_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_error_list_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_snackbar.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_text_field.dart';
import 'package:flutter_base/ui/widgets/b_agri/custome_slidable_widget.dart';
import 'package:flutter_base/utils/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

enum Unit { Cong, Dong }

class ContractWorkListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ContractWorkListState();
}

class _ContractWorkListState extends State<ContractWorkListPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final formatCurrency = new NumberFormat.currency(locale: 'vi');
  ContractWorkListCubit? _cubit;

  Unit unit = Unit.Dong;
  String _unitValue = "Đồng/bầu";

  final _unitPriceController = TextEditingController(text: '');
  final _contentController = TextEditingController(text: '');
  final _unitController = TextEditingController(text: '');

  var _contentModifyController = TextEditingController(text: '');
  var _unitPriceModifyController = TextEditingController(text: '');
  var _unitModifyController = TextEditingController(text: '');
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<ContractWorkListCubit>(context);
    _cubit!.fetchContractWorkList();

    //set initial cubit
    _cubit!.changeTitle(_contentController.text);
    _cubit!.changeUnitPrice(_unitPriceController.text);

    _contentController.addListener(() {
      _cubit!.changeTitle(_contentController.text);
    });
    _unitPriceController.addListener(() {
      _cubit!.changeUnitPrice(_unitPriceController.text);
    });
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
        child: BlocBuilder<ContractWorkListCubit, ContractWorkListState>(
          bloc: _cubit,
          buildWhen: (previous, current) =>
              previous.getListWorkStatus != current.getListWorkStatus,
          builder: (context, state) {
            if (state.getListWorkStatus == LoadStatus.LOADING) {
              return Center(
                  child: CircularProgressIndicator(
                color: AppColors.main,
              ));
            } else if (state.getListWorkStatus == LoadStatus.FAILURE) {
              return AppErrorListWidget(
                onRefresh: _onRefreshData,
              );
            } else if (state.getListWorkStatus == LoadStatus.SUCCESS) {
              return state.listContractWork!.length != 0
                  ? RefreshIndicator(
                      color: AppColors.main,
                      onRefresh: _onRefreshData,
                      child: ListView.separated(
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 25),
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: state.listContractWork!.length,
                        shrinkWrap: true,
                        primary: false,
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          ContractWorkEntity contractWork =
                              state.listContractWork![index];
                          return _buildItem(
                              title: contractWork.title ?? "",
                              unit: contractWork.unit ?? "",
                              unitPrice: contractWork.unitPrice.toString(),
                              onUpdate: () async {
                                // bool isModify = await showDialog(
                                //     context: context,
                                //     builder: (context) => _dialogModify(
                                //         contractWork: contractWork));
                                //
                                // if (isModify) {
                                //   _onRefreshData();
                                //   showSnackBar(
                                //       'Thay đổi thông tin thành công!');
                                // }
                                showModifyDialog(contractWork: contractWork);
                              },
                              onDelete: () async {
                                bool isDelete = await showDialog(
                                    context: context,
                                    builder: (context) => AppDeleteDialog(
                                          onConfirm: () async {
                                            await _cubit!.deleteContractWork(
                                                contractWork.id);
                                            Navigator.pop(context, true);
                                          },
                                        ));

                                if (isDelete) {
                                  _onRefreshData();
                                  showSnackBar('Xóa công việc thành công!');
                                }
                              });
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 10);
                        },
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [EmptyDataWidget()],
                      ),
                    );
            } else {
              return Container();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "btn2",
        onPressed: () {
          showCreateDialog();
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
      VoidCallback? onPressed,
      VoidCallback? onUpdate,
      VoidCallback? onDelete}) {
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
                    onUpdate?.call();
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
                    onDelete?.call();
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
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nội dung: $title",
                            style: AppTextStyle.greyS16Bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: Text(
                                'Đơn giá: ${formatCurrency.format(num.parse(unitPrice))}',
                                style: AppTextStyle.greyS14,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(
                                'Đơn vị: $unit',
                                style: AppTextStyle.greyS14,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ])
                        ],
                      ),
                      fit: FlexFit.tight,
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

  Widget _buildTextLabel(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 10),
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

  Widget _buildContentInput(TextEditingController? controller) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: AppTextField(
        autoValidateMode: AutovalidateMode.onUserInteraction,
        hintText: "Nhập vào tên công việc",
        controller: controller,
        validator: (value) {
          if (Validator.validateNullOrEmpty(value!))
            return "Chưa nhập tên công việc";
          else
            return null;
        },
      ),
    );
  }

  Widget _buildUnitPriceInput(TextEditingController controller) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: AppTextField(
        autoValidateMode: AutovalidateMode.onUserInteraction,
        hintText: "Nhập vào đơn giá",
        controller: controller,
        suffixText: "VND",
        suffixTextStyle: TextStyle(
          color: AppColors.mainDarker,
        ),
        inputFormatters: [
          CurrencyTextInputFormatter(
            locale: 'vi',
            symbol: '',
          ),
        ],
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

  Widget _buildUnitInput(TextEditingController controller) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: AppTextField(
        autoValidateMode: AutovalidateMode.onUserInteraction,
        hintText: "Nhập vào đơn vị",
        controller: controller,
        validator: (value) {
          if (Validator.validateNullOrEmpty(value!))
            return "Chưa nhập đơn vị";
          else
            return null;
        },
      ),
    );
  }

  void showCreateDialog() {
    showGeneralDialog(
        context: context,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              ),
              title: Text("Thêm công việc khoán",
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      fontFamily: "Helvetica")),
              content: Container(
                padding: EdgeInsets.all(7),
                constraints: BoxConstraints(
                  maxHeight: double.infinity,
                ),
                width: MediaQuery.of(context).size.width,
                child: Form(
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.zero,
                          child: Container(
                              child: Form(
                                  key: _formKey,
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildTextLabel("Nội dung:"),
                                        _buildContentInput(_contentController),
                                        _buildTextLabel("Đơn giá:"),
                                        _buildUnitPriceInput(
                                            _unitPriceController),
                                        _buildTextLabel("Đơn vị:"),
                                        _buildUnitInput(_unitController),
                                      ])),
                            ),
                          ),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: AppButton(
                                  color: AppColors.redButton,
                                  title: 'Hủy bỏ',
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: AppButton(
                                    color: AppColors.main,
                                    title: 'Xác nhận',
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        await _cubit!
                                            .createContractWork(_unitValue);
                                        if (_cubit!
                                                .state.createContractWorkStatus ==
                                            LoadStatus.SUCCESS) {
                                          Navigator.pop(context, true);
                                          showSnackBar(
                                              "Tạo công việc thành công");
                                          _onRefreshData();
                                          _contentController.clear();
                                          _unitPriceController.clear();
                                        } else {
                                          Navigator.pop(context, false);
                                          showErrorSnackBar(
                                              "Công việc đã tồn tại");
                                        }
                                      }
                                    }),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

  void showModifyDialog({
    ContractWorkEntity? contractWork,
    Text? title,
  }) {
    _contentModifyController = TextEditingController(text: contractWork!.title);
    _unitPriceModifyController =
        TextEditingController(text: contractWork.unitPrice.toString());
    _unitModifyController = TextEditingController(text: contractWork.unit);
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                title: Text("Thay đổi thông tin",
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontFamily: "Helvetica")),
                content: Container(
                  width: MediaQuery.of(context).size.width,
                  // padding: EdgeInsets.all(7),
                  constraints: BoxConstraints(maxHeight: double.infinity),
                  child: Form(
                    child: SingleChildScrollView(
                      physics: ClampingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.zero,
                            child: Container(
                                child: SingleChildScrollView(
                              physics: ClampingScrollPhysics(),
                              child: Container(
                                child: Form(
                                    key: _formKey,
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildTextLabel("Nội dung:"),
                                          _buildContentInput(
                                              _contentModifyController),
                                          _buildTextLabel("Đơn giá:"),
                                          _buildUnitPriceInput(
                                              _unitPriceModifyController),
                                          _buildTextLabel("Đơn vị:"),
                                          _buildUnitInput(
                                              _unitModifyController),
                                        ])),
                              ),
                            )),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: AppButton(
                                    color: AppColors.redButton,
                                    title: 'Hủy bỏ',
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: AppButton(
                                      color: AppColors.main,
                                      title: 'Xác nhận',
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          await _cubit!.modifyContractWork(
                                              contractWork.id,
                                              _contentModifyController.text,
                                              _unitModifyController.text,
                                              _unitPriceModifyController.text);
                                          if (_cubit!.state
                                                  .modifyContractWorKStatus ==
                                              LoadStatus.SUCCESS) {
                                            Navigator.pop(context, true);
                                            _onRefreshData();
                                            showSnackBar(
                                                "Thay đổi thông tin thành công");
                                            _contentModifyController.clear();
                                            _unitPriceModifyController.clear();
                                          } else {
                                            Navigator.pop(context, false);
                                            showErrorSnackBar(
                                                "Thông tin đã trùng");
                                          }
                                        }
                                      }),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ));
          });
        });
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(AppSnackBar(
      typeSnackBar: "success",
      message: message,
    ));
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(AppSnackBar(
      typeSnackBar: "error",
      message: message,
    ));
  }

  Future<void> _onRefreshData() async {
    _cubit!.fetchContractWorkList();
  }

  void handleUnitChange(String value) {
    setState(() {
      _unitValue = value;
    });
  }
// void Test(){
//   showGeneralDialog(
//       context: context,
//       barrierDismissible: true,
//       barrierLabel: MaterialLocalizations.of(context)
//           .modalBarrierDismissLabel,
//       barrierColor: Colors.black45,
//       transitionDuration: const Duration(milliseconds: 200),
//       pageBuilder: (BuildContext buildContext,
//           Animation animation,
//           Animation secondaryAnimation) {
//         return Center(
//             child: Container(
//               padding: EdgeInsets.all(7),
//               height: 400,
//               child: Card(
//                 shape: RoundedRectangleBorder(
//                     borderRadius:
//                     BorderRadius.circular(20.0)),
//                 child: Stack(
//                   clipBehavior: Clip.none, children: <Widget>[
//                     Form(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: <Widget>[
//                           Container(
//                             height: 60,
//                             width: MediaQuery.of(context).size.width,
//                             child: Center(child: Text("Thêm công việc khoán", style:TextStyle(color: Colors.black54, fontWeight: FontWeight.w700, fontSize: 20, fontStyle: FontStyle.italic, fontFamily: "Helvetica"))),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.zero,
//                             child: Container(
//                                 child: SingleChildScrollView(
//                                   physics: ClampingScrollPhysics(),
//                                   child: Container(
//                                     child: Form(
//                                         key: _formKey,
//                                         child: Column(
//                                           mainAxisSize: MainAxisSize.min,
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               _buildTextLabel("Nội dung:"),
//                                               _buildContentInput(),
//                                               _buildTextLabel("Đơn giá:"),
//                                               _buildUnitPriceInput(),
//                                               _buildTextLabel("Đơn vị:"),
//                                               Theme(
//                                                 data: Theme.of(context).copyWith(
//                                                     unselectedWidgetColor: AppColors.main
//                                                 ),
//                                                 child:Row(
//                                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                                   children: [
//                                                     Flexible(
//                                                       flex: 1,
//                                                       child: RadioListTile(
//                                                         activeColor: AppColors.main,
//                                                         title: Text("Đồng/bầu", style: AppTextStyle.greyS16Bold),
//                                                         value: Unit.Dong,
//                                                         groupValue: unit,
//                                                         onChanged: (value){
//                                                           setState(() {
//                                                             unit = value as Unit;
//                                                             handleUnitChange("Đồng/bầu");
//                                                             print(_unitValue);
//                                                           });
//                                                         },
//                                                       ),
//                                                     ),
//                                                     Flexible(
//                                                         flex: 1,
//                                                         child: RadioListTile(
//                                                           activeColor: AppColors.main,
//                                                           title: Text("Công", style: AppTextStyle.greyS16Bold),
//                                                           value: Unit.Cong,
//                                                           groupValue: unit,
//                                                           onChanged:(value){
//                                                             setState(() {
//                                                               unit = value as Unit;
//                                                               handleUnitChange("Công");
//                                                               print(_unitValue);
//                                                             });
//                                                           },
//                                                         )
//                                                     ),
//                                                   ],
//                                                 ) ,
//                                               )
//
//                                             ])
//                                     ),
//                                   ),
//                                 )
//                             ),
//                           ),
//                           Container(
//                             padding: const EdgeInsets.all(10.0),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                   children: [
//                                     Expanded(
//                                       child: AppButton(
//                                         color: AppColors.redButton,
//                                         title: 'Hủy bỏ',
//                                         onPressed: (){
//                                           Navigator.pop(context);
//                                         },
//                                       ),
//                                     ),
//                                     SizedBox(width: 20),
//                                     Expanded(
//                                       child: AppButton(
//                                         color: AppColors.main,
//                                         title: 'Xác nhận',
//                                         onPressed: () {}
//                                       ),
//                                     ),
//                                   ],
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//         ),
//               ),
//             ),
//           );
//       });
// }

}
