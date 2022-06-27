import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/ui/pages/task/temporary_task_management/temporary_task_add/temporary_task_add_cubit.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_text_field.dart';
import 'package:flutter_base/ui/widgets/b_agri/page_picker/process_picker/app_process_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TemporaryTaskAddPage extends StatefulWidget{
  String? garden;

  @override
  _TemporaryTaskAddPageState createState() {
    return _TemporaryTaskAddPageState();
  }

}
class _TemporaryTaskAddPageState extends State<TemporaryTaskAddPage>{
  final _formKey3 = GlobalKey<FormState>();
  late TextEditingController nameController;

  @override
  void initState() {
    nameController = TextEditingController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBarWidget(
        title: 'Tạo công nhật', context: context,
      ),
      body: SafeArea(
        child: SingleChildScrollView(

          physics: ClampingScrollPhysics(),
          child: Form(
              key: _formKey3,
              child: Column(
              children: [
                SizedBox(height: 20.15),
                _buildTextLabel('Tên công viêc: '),
                SizedBox(height: 5),
                BlocBuilder<TemporaryTaskAddCubit, TemporaryTaskAddState>(
                  buildWhen: (prev, current) =>
                  prev.loadStatus != current.loadStatus,
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppTextField(
                        controller: nameController,
                        onChanged: (value) {},
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
  Widget _buildTextLabel(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 28),
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
            text: text,
            style: AppTextStyle.blackS16,
          ),
        ]),
      ),
    );
  }
}