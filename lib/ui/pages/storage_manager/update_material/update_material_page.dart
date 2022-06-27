import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/ui/pages/storage_manager/update_material/update_material_cubit.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_button.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_circular_progress_indicator.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_error_list_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_snackbar.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_text_field.dart';
import 'package:flutter_base/utils/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateMaterialPage extends StatefulWidget {
  final String? materialId;

  UpdateMaterialPage({Key? key, this.materialId}) : super(key: key);

  @override
  _UpdateMaterialPageState createState() {
    return _UpdateMaterialPageState();
  }
}

class _UpdateMaterialPageState extends State<UpdateMaterialPage> {
  late TextEditingController quantityController;
  UpdateMaterialCubit? _cubit;

  @override
  void initState() {
    _cubit = BlocProvider.of<UpdateMaterialCubit>(context);
    _cubit?.getMaterialById(widget.materialId);
    quantityController = TextEditingController(
      text: _cubit!.state.quantity.toString(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: 'Thay đổi vật tư',
          context: context,
        ),
        body: SingleChildScrollView(
          child: BlocBuilder<UpdateMaterialCubit, UpdateMaterialState>(
              builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  Text(
                    'Thông tin chi tiết: ',
                    style: AppTextStyle.blackS18Bold,
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Tên vật tư: ${state.name}',
                      style: AppTextStyle.greyS16,
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Đơn vị: ${state.unit}',
                      style: AppTextStyle.greyS16,
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Đơn giá: ${state.unitPrice.toString()}',
                      style: AppTextStyle.greyS16,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Số lượng: ',
                    style: AppTextStyle.blackS18Bold,
                  ),
                  SizedBox(height: 15),
                  BlocConsumer<UpdateMaterialCubit, UpdateMaterialState>(
                    listener: (context, state) {
                      quantityController = TextEditingController(
                        text: _cubit!.state.quantity.toString(),
                      );
                    },
                    builder: (context, state) {
                      return AppTextField(
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        hintText: 'Nhập vào số lượng',
                        controller: quantityController,
                        validator: (value) {
                          if (Validator.validateNullOrEmpty(value!))
                            return "Chưa nhập số lượng";
                          else
                            return null;
                        },
                      );
                    },
                  ),
                  SizedBox(height: 30),
                  BlocConsumer<UpdateMaterialCubit, UpdateMaterialState>(
                    bloc: _cubit,
                    listenWhen: (prev, current) {
                      return prev.loadingStatus != current.loadingStatus;
                    },
                    listener: (context, state) {
                      if (state.loadingStatus == LoadStatus.SUCCESS) {
                        _showCreateSuccess();
                      }
                      if (state.loadingStatus == LoadStatus.FAILURE) {
                        showSnackBar('Có lỗi xảy ra!');
                      }
                    },
                    builder: (context, state) {
                      final isLoading =
                          (state.loadingStatus == LoadStatus.LOADING);
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: AppButton(
                              color: AppColors.redButton,
                              title: 'Hủy bỏ',
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          SizedBox(width: 40),
                          Expanded(
                            child: AppButton(
                              width: 100,
                              color: AppColors.main,
                              title: 'Xác nhận',
                              onPressed: () {
                                  _cubit?.changeQuantity(int.parse(quantityController.text.length == 0 ? '0' : quantityController.text));
                                  _cubit?.updateMaterial(widget.materialId!);
                                },
                              isLoading: isLoading,
                            ),
                          ),
                        ],
                      );
                    },
                  )
                ],
              ),
            );
          }),
        ));
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(AppSnackBar(
      message: message,
      typeSnackBar: '',
    ));
  }

  void _showCreateSuccess() async {
    showSnackBar('Thay đổi vật tư thành công!');
    Navigator.of(context).pop(true);
  }
}
