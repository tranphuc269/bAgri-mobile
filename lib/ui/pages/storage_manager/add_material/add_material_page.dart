import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/ui/pages/storage_manager/add_material/add_material_cubit.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_button.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_snackbar.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_text_field.dart';
import 'package:flutter_base/utils/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddMaterialPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddMaterialPageState();
  }
}

class _AddMaterialPageState extends State<AddMaterialPage> {
  final _formKey1 = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController unitPriceController;
  late TextEditingController quantityController;
  late TextEditingController unitController;
  AddMaterialCubit? _cubit;

  @override
  void initState() {
    nameController = TextEditingController();
    unitPriceController = TextEditingController();
    unitController = TextEditingController();
    quantityController = TextEditingController();
    _cubit = BlocProvider.of<AddMaterialCubit>(context);
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    unitController.dispose();
    unitPriceController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: "Thêm vật tư",
          context: context,
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Form(
                                key: _formKey1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tên vật tư',
                                      style: AppTextStyle.greyS14,
                                    ),
                                    SizedBox(height: 10),
                                    AppTextField(
                                      autoValidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      hintText: 'Tên vật tư',
                                      controller: nameController,
                                      validator: (value) {
                                        if (Validator.validateNullOrEmpty(value!))
                                          return "Chưa nhập tên vật tư";
                                        else
                                          return null;
                                      },
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      'Số lượng',
                                      style: AppTextStyle.greyS14,
                                    ),
                                    SizedBox(height: 10),
                                    AppTextField(
                                      keyboardType: TextInputType.number,
                                      autoValidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      hintText: 'Số lượng',
                                      controller: quantityController,
                                      validator: (value) {
                                        if (Validator.validateNullOrEmpty(value!))
                                          return "Chưa nhập số lượng";
                                        else
                                          return null;
                                      },
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      'Đơn vị',
                                      style: AppTextStyle.greyS14,
                                    ),
                                    SizedBox(height: 10),
                                    AppTextField(
                                      autoValidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      hintText: 'Đơn vị',
                                      controller: unitController,
                                      validator: (value) {
                                        if (Validator.validateNullOrEmpty(value!))
                                          return "Chưa nhập đơn vị";
                                        else
                                          return null;
                                      },
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      'Đơn giá',
                                      style: AppTextStyle.greyS14,
                                    ),
                                    SizedBox(height: 10),
                                    AppTextField(
                                      keyboardType: TextInputType.number,
                                      autoValidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      hintText: 'Đơn giá',
                                      controller: unitPriceController,
                                      validator: (value) {
                                        if (Validator.validateNullOrEmpty(value!))
                                          return "Chưa nhập đơn giá";
                                        else
                                          return null;
                                      },
                                    ),
                                    SizedBox(height: 20),

                                  ],
                                ),
                              ),
                            ])),
                    buildActionCreate()
                  ],
                ))));
  }

  Widget buildActionCreate() {
    return BlocConsumer<AddMaterialCubit, AddMaterialState>(
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
          final isLoading = (state.loadingStatus == LoadStatus.LOADING);
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: AppButton(
                      color: AppColors.redButton,
                      title: 'Hủy bỏ',
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(width: 30),
                  Expanded(
                    child: AppButton(
                      width: 100,
                      color: AppColors.main,
                      title: 'Xác nhận',
                      onPressed: () {
                        if (_formKey1.currentState!.validate()) {
                          print("create");
                          _cubit!.changeName(nameController.text);
                          _cubit!.changeQuantity(int.parse(quantityController.text));
                          _cubit!.changeUnit(unitController.text);
                          _cubit!.changeUnitPrice(int.parse(unitPriceController.text));
                          _cubit!.createMaterial();
                          // _cubit?.createTree(nameController.text);
                        }
                      },
                      isLoading: isLoading,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
            ],
          );
        });
  }

  void _showCreateSuccess() async {
    showSnackBar('Tạo mới thành công!');
    Navigator.of(context).pop(true);
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(AppSnackBar(
      typeSnackBar: "success",
      message: message,
    ));
  }
}
