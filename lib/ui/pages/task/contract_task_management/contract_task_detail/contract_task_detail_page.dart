import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/global/global_data.dart';
import 'package:flutter_base/ui/pages/task/contract_task_management/contract_task_detail/contract_task_detail_cubit.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_button.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContractTaskDetailPage extends StatefulWidget {
  const ContractTaskDetailPage({Key? key}) : super(key: key);

  @override
  _ContractTaskDetailPageState createState() => _ContractTaskDetailPageState();
}

class _ContractTaskDetailPageState extends State<ContractTaskDetailPage> {
  late ContractTaskDetailCubit _cubit;
  @override
  void initState() {
   _cubit = BlocProvider.of<ContractTaskDetailCubit>(context);
    super.initState();
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
            GlobalData.instance.role == "GARDEN_MANAGER" ? _buildButtonByGardenManager() : _buildButtonByAdmin(),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInput() {
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
              _buildInformation(title: "Công việc: ", information: "Bón phân"),
              SizedBox(
                height: 10,
              ),
              _buildInformation(title: "Vườn: ", information: "Vườn A1"),
              SizedBox(
                height: 10,
              ),
              _buildInformation(title: "Số lượng cây: ", information:  "2000 cây"),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text("Ngày bắt đầu: ", style: AppTextStyle.greyS16),
                  Text("22-06-2022", style: AppTextStyle.blackS16)
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text("Mô tả công việc từ kĩ thuật viên: ", style: AppTextStyle.greyS16),
              SizedBox(height: 10),
             if (GlobalData.instance.role == "GARDEN_MANAGER" || GlobalData.instance.role == "ACCOUNTANT")
               Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Phân bón: 20kg, thuốc trừ sâu: 5 bình, Nước tưới: 500 lit, Hoan thanh trong 3 ngay",
                    style: AppTextStyle.greyS16Bold,)
                ),
              if(GlobalData.instance.role == "ADMIN" || GlobalData.instance.role == "SUPER_ADMIN")
                  AppTextAreaField(
                    hintText: '',
                    keyboardType: TextInputType.multiline,
                    maxLines: 8,
                    enable: true,
                    textInputAction: TextInputAction.newline,
                  ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildInformation({String? title, String? information}) {
    return Row(
      children: [
        Text(title!, style: AppTextStyle.greyS16),
        Text(information!, style: AppTextStyle.blackS16)
      ],
    );
  }

  Widget _buildButtonByGardenManager (){
    return Container(
      height: 40,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 28),
      child: AppButton(
          color: AppColors.main,
          title: 'Hoàn thành công việc',
          onPressed: () async {
            print("Hoàn thành công việc");
            // _cubit.createContractTask(treeQuantityController.text);
            // Navigator.of(context).pop(true);
          },
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
                  // _cubit.createContractTask(treeQuantityController.text);
                  // Navigator.of(context).pop(true);
                },
              ),
            )
          ],
        ));
  }


}
