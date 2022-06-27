import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  late TextEditingController nameController;

  @override
  void initState() {
    nameController = TextEditingController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Tạo công nhật', context: context,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 5),
              BlocBuilder<TemporaryTaskAddCubit, TemporaryTaskAddState>(
                buildWhen: (prev, current) =>
                prev.loadStatus != current.loadStatus,
                builder: (context, state) {
                  return AppTextField(
                    controller: nameController,
                    onChanged: (value) {},
                  );
                },
              ),
            ],
          ),
        )
      ),
    );
  }

}