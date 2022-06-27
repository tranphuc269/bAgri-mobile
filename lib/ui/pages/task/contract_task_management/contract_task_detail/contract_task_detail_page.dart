import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/global/global_data.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/ui/pages/task/contract_task_management/contract_task_detail/contract_task_detail_cubit.dart';
import 'package:flutter_base/ui/pages/task/contract_task_management/widgets/modal_add_material_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_button.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_snackbar.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ContractTaskDetailPage extends StatefulWidget {
  final String? contractTaskId;

  const ContractTaskDetailPage({Key? key, this.contractTaskId})
      : super(key: key);

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
    _cubit!.getContractTaskDetail(widget.contractTaskId!);
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
            GlobalData.instance.role == "GARDEN_MANAGER"
                ? _buildButtonByGardenManager()
                : _buildButtonByAdmin(),
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
          if(state.loadStatus == LoadStatus.LOADING){
            return Center(
                child: CircularProgressIndicator(
                  color: AppColors.main,
                ));
          }else if (state.loadStatus == LoadStatus.FAILURE) {
            return Expanded(
                child: Center(
                  child: Text("Đã có lỗi xảy ra!"),
                ));
          }else {
            _descriptionController = TextEditingController(text: state.contractTask!.description);
          return Expanded(
              child: Padding(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Scrollbar(
              isAlwaysShown: true,
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInformation(
                        title: "Công việc: ", information: "${state.contractTask!.work!.title}"),
                    SizedBox(
                      height: 10,
                    ),
                    _buildInformation(title: "Vườn: ", information:"${state.contractTask!.gardenName}" ),
                    SizedBox(
                      height: 10,
                    ),
                    _buildInformation(
                        title: "Số lượng cây: ", information: "${state.contractTask!.treeQuantity}"),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text("Ngày bắt đầu: ", style: AppTextStyle.greyS16),
                        Text("${formatDate.format(DateTime.parse(state.contractTask!.start.toString()))}", style: AppTextStyle.blackS16)
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Mô tả công việc từ kĩ thuật viên: ",
                        style: AppTextStyle.greyS16),
                    SizedBox(height: 10),
                    if (GlobalData.instance.role == "GARDEN_MANAGER" ||
                        GlobalData.instance.role == "ACCOUNTANT")
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                           state.contractTask!.description != null ? "${state.contractTask!.description}" : "",
                            style: AppTextStyle.greyS16Bold,
                          )),
                    if (GlobalData.instance.role == "ADMIN" ||
                        GlobalData.instance.role == "SUPER_ADMIN")
                      AppTextAreaField(
                        hintText: '',
                        keyboardType: TextInputType.multiline,
                        maxLines: 10,
                        controller: _descriptionController,
                        enable: true,
                        textInputAction: TextInputAction.newline,
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    isAddMaterial == true ?
                   Padding(
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
                          changeNameDesStage();
                        },
                      ),
                    ) : Container()
                  ],
                ),
              ),
            ),
          ));
        }});
  }
  changeNameDesStage(){
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
          child: ModalAddMaterialWidget(onPressed: (String name, String quantity, String unit) { print("hello"); },),
        )
    );
  }

  Widget _buildInformation({String? title, String? information}) {
    return Row(
      children: [
        Text(title!, style: AppTextStyle.greyS16),
        Text(information!, style: AppTextStyle.blackS16)
      ],
    );
  }

  Widget _buildButtonByGardenManager() {
    return Container(
      height: 40,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 28),
      child: AppButton(
        color: AppColors.main,
        title: isAddMaterial ? "Hoàn tất" :'Hoàn thành công việc',
        onPressed: () async {
          if(isAddMaterial == false){
            showDialog(
                context: context,
                builder: (context) => _dialogFinish(
                  onConfirm: (){
                    setState(() {
                      isAddMaterial = true;
                      Navigator.pop(context, true);
                    });
                  }
                ));
          }
          // _cubit.createContractTask(treeQuantityController.text);
          // Navigator.of(context).pop(true);
        },
      ),
    );
  }
  Widget _dialogFinish({VoidCallback? onConfirm,
    VoidCallback? notAddMaterial,}
      ){
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
                  onTap: () {
                    notAddMaterial;
                  },
                  child: Text(
                    'Không',
                    style: TextStyle(
                        color: AppColors.redLighterTextButton, fontSize: 16),
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: onConfirm,
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
                  await _cubit!.addDescriptionForContrackTask(_cubit!.state.contractTask,_descriptionController.text );
                  if(_cubit!.state.updateContractTaskStatus == LoadStatus.SUCCESS){
                    showSnackBarSuccess("Thay đổi thông tin thành công!");
                    Navigator.of(context).pop(true);
                    }else{
                    showSnackBarError("Đã có lỗi xảy ra");
                  }
                  }
              ),
            )
          ],
        ));
  }
  void showSnackBarSuccess(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(AppSnackBar(
      message: message, typeSnackBar: 'success',
    ));
  }
  void showSnackBarError(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(AppSnackBar(
      message: message, typeSnackBar: 'error',
    ));
  }
}
class ContractTaskDetailArgument {
  String? contractTask_id;

  ContractTaskDetailArgument({
    this.contractTask_id,
  });
}


