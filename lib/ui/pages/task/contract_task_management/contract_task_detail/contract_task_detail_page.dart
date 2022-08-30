
import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/global/global_data.dart';
import 'package:flutter_base/models/entities/material/material.dart';
import 'package:flutter_base/models/entities/task/contract_task.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/ui/pages/task/contract_task_management/contract_task_detail/contract_task_detail_cubit.dart';
import 'package:flutter_base/ui/pages/task/contract_task_management/widgets/modal_add_material_widget.dart';
import 'package:flutter_base/ui/pages/task/contract_task_management/widgets/modal_modify_material_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_button.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_delete_dialog.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_snackbar.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ContractTaskDetailPage extends StatefulWidget {
  final ContractTask? contractTask;
 // final String? seasonId;

  const ContractTaskDetailPage({Key? key, this.contractTask}) : super(key: key);

  @override
  _ContractTaskDetailPageState createState() => _ContractTaskDetailPageState();
}

class _ContractTaskDetailPageState extends State<ContractTaskDetailPage> {
  ContractTaskDetailCubit? _cubit;
  bool isAddMaterial = false;

  DateFormat formatDate = DateFormat("dd-MM-yyyy");
  var _descriptionController = TextEditingController(text: "");


  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<ContractTaskDetailCubit>(context);
    _cubit!.getContractTaskDetail(widget.contractTask!.id!);
    _cubit!.getSeasonDetail(widget.contractTask!.season!);
    _descriptionController.addListener(() {
      // _cubit!.changeName(nameController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBarWidget(
        context: context,
        title: 'Chi tiết công việc',
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildInput(),
            BlocBuilder<ContractTaskDetailCubit, ContractTaskDetailState>(
                bloc: _cubit,
                builder: (context, state) {
                  if (state.getFinishStatus == LoadStatus.SUCCESS || GlobalData.instance.role == "ACCOUNTANT" ) {
                    return Container();
                  } else {
                    return GlobalData.instance.role == "GARDEN_MANAGER"
                        ? _buildButtonByGardenManager(
                            widget.contractTask!.id, _cubit!.state.materials)
                        : _buildButtonByAdmin();
                  }
                }),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInput() {
    return BlocBuilder<ContractTaskDetailCubit, ContractTaskDetailState>(
        bloc: _cubit,
        builder: (context, state) {
          if (state.loadStatus == LoadStatus.LOADING || state.getSeasonStatus == LoadStatus.LOADING) {
            return Center(
                child: CircularProgressIndicator(
              color: AppColors.main,
            ));
          } else if (state.loadStatus == LoadStatus.FAILURE || state.getSeasonStatus == LoadStatus.FAILURE) {
            return Expanded(
                child: Center(
              child: Text("Đã có lỗi xảy ra!"),
            ));
          } else {
            _descriptionController =
                TextEditingController(text: state.contractTask!.description);
            return Expanded(
                child: Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Scrollbar(
                // thumbVisibility: true,
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInformation(
                          title: "Công việc: ",
                          information: "${state.contractTask!.work!.title}"),
                      SizedBox(
                        height: 10,
                      ),
                      _buildInformation(
                          title: "Vườn: ",
                          information: "${state.seasonEntity!.gardenEntity!.name}"),
                      SizedBox(
                        height: 10,
                      ),
                      _buildInformation(
                          title: "Số lượng: ",
                          information: "${state.contractTask!.quantity}"),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text("Ngày bắt đầu: ", style: AppTextStyle.greyS16),
                          Text(
                              "${formatDate.format(DateTime.parse(state.contractTask!.start.toString()))}",
                              style: AppTextStyle.blackS16)
                        ],
                      ),
                      state.getFinishStatus == LoadStatus.SUCCESS
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text("Ngày kết thúc: ",
                                        style: AppTextStyle.greyS16),
                                    Text(
                                        "${formatDate.format(DateTime.parse(state.contractTask!.end.toString()))}",
                                        style: AppTextStyle.blackS16)
                                  ],
                                ),
                              ],
                            )
                          : Container(),
                      SizedBox(
                        height: 10,
                      ),
                      _buildInformation(
                          title: "Trạng thái: ",
                          information: state.contractTask!.end != null
                              ? "Đã hoàn thành"
                              : "Đang thực hiện"),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Mô tả công việc từ kĩ thuật viên: ",
                          style: AppTextStyle.greyS16),
                      SizedBox(height: 10),
                      BlocConsumer<ContractTaskDetailCubit,
                          ContractTaskDetailState>(listener: (context, state) {
                        if (state.loadStatus == LoadStatus.SUCCESS) {}
                      }, builder: (context, state) {
                        if(state.contractTask?.description != null){
                          _descriptionController = TextEditingController(text: state.contractTask?.description);
                        }
                        return Container(
                          margin: EdgeInsets.only(left: 10, right: 10, bottom: 0),
                          child: AppTextAreaField(
                            controller: _descriptionController,
                            onSaved: (value){
                              _cubit?.changeDescription(value);
                            },
                            hintText: state.contractTask?.description ?? ' Hiện chưa có',
                            keyboardType: TextInputType.multiline,
                            enable: state.getFinishStatus == LoadStatus.SUCCESS ? false : (
                                GlobalData.instance.role == "ADMIN" ? true :
                            (GlobalData.instance.role == "ADMIN" ||
                                GlobalData.instance.role == "SUPER_ADMIN" )),
                            textInputAction: TextInputAction.newline,
                          ),
                        );
                      }),
                      // BlocConsumer(
                      //     builder: builder,
                      //     listener: listener)
                      // if (GlobalData.instance.role == "GARDEN_MANAGER" ||
                      //     GlobalData.instance.role == "ACCOUNTANT")
                      //   AppTextAreaField(
                      //     hintText: state.contractTask?.description ??
                      //         "Chưa có mô tả từ kĩ thuật viên",
                      //     keyboardType: TextInputType.multiline,
                      //     controller: _descriptionController,
                      //     enable: false,
                      //     textInputAction: TextInputAction.newline,
                      //   ),
                      // if (GlobalData.instance.role == "ADMIN" ||
                      //     GlobalData.instance.role == "SUPER_ADMIN")
                      //   AppTextAreaField(
                      //     hintText: state.contractTask?.description ??
                      //         "Chưa có mô tả từ kĩ thuật viên",
                      //     keyboardType: TextInputType.multiline,
                      //     maxLines: 10,
                      //     controller: _descriptionController,
                      //     enable: true,
                      //     textInputAction: TextInputAction.newline,
                      //   ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Danh sách vật tư đã sử dụng: ",
                          style: AppTextStyle.greyS16),
                      SizedBox(
                        height: 10,
                      ),
                      (isAddMaterial == true && state.contractTask!.end == null)
                          ? Padding(
                              padding: EdgeInsets.only(left: 180),
                              child: AppButton(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Thêm vật tư'),
                                    FittedBox(
                                        child: Icon(
                                      Icons.add,
                                      color: Color(0xFF373737),
                                    )),
                                  ],
                                ),
                                color: Color(0xFF8FE192),
                                height: 30,
                                width: double.infinity,
                                onPressed: () {
                                  addMaterial();
                                },
                              ),
                            )
                          : Container(),
                      SizedBox(
                        height: 20,
                      ),
                      BlocBuilder<ContractTaskDetailCubit,
                          ContractTaskDetailState>(
                        builder: (context, state) {
                          if (state.loadStatus == LoadStatus.LOADING) {
                            return Center(
                                child: CircularProgressIndicator(
                              color: AppColors.main,
                            ));
                          } else if (state.loadStatus == LoadStatus.FAILURE) {
                            return Container();
                          } else if (state.loadStatus == LoadStatus.SUCCESS) {
                            return state.materials!.length != 0
                                ? Column(
                                    children: List.generate(
                                        state.materials!.length,
                                        (index) => materialItem(
                                            state.materials![index], index)),
                                  )
                                : Container();
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ));
          }
        });
  }

  addMaterial() {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20))),
        builder: (context) => Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20))),
              child: ModalAddMaterialWidget(
                onPressed: (String name, String quantity, String unit, int? unitPrice) {
                  setState(() {
                    // print(name);
                    _cubit!.state.materials!.add(MaterialUsedByTask(
                        name: name,
                        quantity: int.parse(quantity.toString()),
                        unitPrice: unitPrice,
                        unit: unit));
                  })
                  ;
                },
              ),
            ));
  }
  modifyMaterial({String? name, int? quantity, String? unit, int? index}) {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20))),
        builder: (context) => Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20))),
          child: ModalModifyMaterialWidget(
            materialEntity: MaterialEntity(name: name, quantity: quantity, unit: unit),
            onPressed: (String name, String quantity, String unit) {
              setState(() {
                _cubit!.state.materials!.removeAt(index!.toInt());
                _cubit!.state.materials!.insert(index,MaterialUsedByTask(
                    name: name,
                    quantity: int.parse(quantity.toString()),
                    unit: unit));
              });
            },
          ),
        ));
  }
  Widget _buildInformation({String? title, String? information}) {
    return Row(
      children: [
        Flexible(child: Text(
          "${title!} $information", style: AppTextStyle.blackS16, overflow: TextOverflow.ellipsis, maxLines: 1,))
      ],
    );
  }

  Widget _buildButtonByGardenManager(
      String? contractTaskId, List<MaterialUsedByTask>? materials) {
    return BlocBuilder<ContractTaskDetailCubit, ContractTaskDetailState>(
      bloc: _cubit,
      builder: (context, state) {
        final isLoading = state.finishContractTaskStatus == LoadStatus.LOADING;
        return Container(
          height: 40,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 28),
          child: AppButton(
            color: AppColors.main,
            title: isAddMaterial ? "Hoàn tất" : 'Hoàn thành công việc',
            isLoading: isAddMaterial ? isLoading : false,
            onPressed: () async {
              if (isAddMaterial == false) {
                showDialog(
                    context: context,
                    builder: (context) => _dialogFinish(
                        onConfirm: () {
                          setState(() {
                            isAddMaterial = true;
                            Navigator.pop(context, true);
                          });
                        },
                        close: () {
                          print("close");
                          setState(() {
                            Navigator.pop(context, false);
                          });

                        })
                );
              }
              if (isAddMaterial == true) {
                setState(() async {
                  await _cubit!.finishContractTask(contractTaskId, materials!);
                  _cubit!.getContractTaskDetail(widget.contractTask!.id!);
                });
                showSnackBarSuccess("Hoàn thành công viêc");
              }
              // _cubit.createContractTask(treeQuantityController.text);
              // Navigator.of(context).pop(true);
            },
          ),
        );
      },
    );
  }

  Widget _dialogFinish({
    VoidCallback? onConfirm,
    VoidCallback? close,
  }) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 20, left: 20, right: 15, bottom: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Thông báo',
              style: AppTextStyle.blackS16Bold,
            ),
            SizedBox(height: 18),
            Text('Thêm vật tư đã sử dụng', style: AppTextStyle.blackS16),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: close,
                  child: Text(
                    'Đóng',
                    style: TextStyle(
                        color: AppColors.redLighterTextButton, fontSize: 16),
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: onConfirm,
                  // onTap: (){
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => AppMaterialPickerPage()),
                  //   );
                  // },
                  child: Text(
                    'Thêm',
                    style: TextStyle(
                        color: AppColors.greenLighterTextButton, fontSize: 16),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildButtonByAdmin() {
    return Container(
        height: 40,
        width: double.infinity,
        margin: EdgeInsets.only(top: 25),
        padding: EdgeInsets.symmetric(horizontal: 28),
        child: Row(
          children: [
            Expanded(
              child: AppButton(
                color: AppColors.redButton,
                title: 'Hủy bỏ',
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ),
            SizedBox(width: 25),
            Expanded(
              child: AppButton(
                  color: AppColors.main,
                  title: 'Xác nhận',
                  onPressed: () async {
                    print(_descriptionController.text);
                    await _cubit!.addDescriptionForContrackTask(
                        _cubit!.state.contractTask,
                        _descriptionController.text);
                    if (_cubit!.state.updateContractTaskStatus ==
                        LoadStatus.SUCCESS) {
                      showSnackBarSuccess("Thay đổi thông tin thành công!");
                      Navigator.of(context).pop(true);
                    } else {
                      showSnackBarError("Đã có lỗi xảy ra");
                    }
                  }),
            )
          ],
        ));
  }

  void showSnackBarSuccess(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(AppSnackBar(
      message: message,
      typeSnackBar: 'success',
    ));
  }

  void showSnackBarError(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(AppSnackBar(
      message: message,
      typeSnackBar: 'error',
    ));
  }

  Widget materialItem(MaterialUsedByTask? material, int? index) {
    return GestureDetector(
      onLongPress: (){
        _cubit!.state.getFinishStatus == LoadStatus.SUCCESS ? null :
        showDialog(
            context: context,
            builder: (context) => AppDeleteDialog(
              onConfirm: () {
                setState(() {
                  _cubit!.state.materials!.removeAt(index!);
                });
                Navigator.pop(context, true);
              },
            ));
      },

        onTap: () {
          _cubit!.state.getFinishStatus == LoadStatus.SUCCESS ? null :
         modifyMaterial(name: material!.name, unit: material.unit, quantity: material.quantity, index: index);
        },
        child: Container(
          height: 60,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              color: Color(0xFFF1F7E7),
              border: Border.all(color:Color(0xFF9D9D9D) ),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Tên vật tư:  ${material!.name}",
                // "Tên vật tư: Phân bón",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Text('Số lượng: ${material.quantity} ${material.unit}'),
                  SizedBox(
                    width: 3,
                  ),
                ],
              )
            ],
          ),
        ));
  }
  // Widget _buildMaterialPicker() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(25.0),
  //     ),
  //     child: AppPageMaterialPicker(
  //       controller: materialController,
  //       onChanged: (value) {},
  //     ),
  //   );
  // }
}

class ContractTaskDetailArgument {
  ContractTask? contractTask;

  ContractTaskDetailArgument({
    this.contractTask,
  });
}
