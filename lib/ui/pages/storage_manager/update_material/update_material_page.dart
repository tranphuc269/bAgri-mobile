import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/ui/pages/storage_manager/update_material/update_material_cubit.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_button.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_text_field.dart';
import 'package:flutter_base/utils/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateMaterialPage extends StatefulWidget {
  String materialId;

  UpdateMaterialPage({Key? key, required this.materialId}) : super(key: key);

  @override
  _UpdateMaterialPageState createState() {
    return _UpdateMaterialPageState();
  }
}

class _UpdateMaterialPageState extends State<UpdateMaterialPage> {
  final _formKey2 = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController unitPriceController;
  late TextEditingController quantityController;
  late TextEditingController unitController;
  UpdateMaterialCubit? _cubit;

  @override
  void initState() {
    _cubit = BlocProvider.of<UpdateMaterialCubit>(context);
    _cubit!.getInformationMaterialById(widget.materialId);
    nameController = TextEditingController(text: '');
    unitPriceController = TextEditingController(text: '');
    unitController = TextEditingController();
    quantityController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    unitPriceController.dispose();
    unitController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: 'Thay đổi vật tư',
          context: context,
        ),
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: SingleChildScrollView(
                    child:
                        BlocConsumer<UpdateMaterialCubit, UpdateMaterialState>(
                            listenWhen: (prev, current) =>
                                prev.loadingStatus != current.loadingStatus,
                            listener: (context, state) {
                              nameController.text = state.name ?? "";
                              unitController.text = state.unit.toString();
                              unitPriceController.text =
                                  state.unitPrice.toString();
                              quantityController.text =
                                  state.quantity.toString();
                            },
                            builder: (context, state) {
                              return Form(
                                key: _formKey2,
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Tên vật tư',
                                        style: AppTextStyle.greyS18,
                                      ),
                                      SizedBox(height: 10),
                                      AppTextField(
                                        controller: nameController,
                                        hintText: 'Nhập vào tên vật tư',
                                        enable:
                                        state.loadingStatus == LoadStatus.LOADING ? false : true,
                                        validator: (value) {
                                          if (Validator.validateNullOrEmpty(value!))
                                            return "Chưa nhập tên vật tư";
                                          else
                                            return null;
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Số lượng',
                                        style: AppTextStyle.greyS18,
                                      ),
                                      SizedBox(height: 10),
                                      AppTextField(
                                        controller: quantityController,
                                        validator: (value) {
                                          if (Validator.validateNullOrEmpty(value!))
                                            return "Chưa nhập số lượng";
                                          else
                                            return null;
                                        },
                                        hintText: 'Nhập vào số lượng',
                                        enable:
                                        state.loadingStatus == LoadStatus.LOADING ? false : true,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Đơn vị',
                                        style: AppTextStyle.greyS18,
                                      ),
                                      SizedBox(height: 10),
                                      AppTextField(
                                        controller: unitController,
                                        validator: (value) {
                                          if (Validator.validateNullOrEmpty(value!))
                                            return "Chưa nhập đơn vị";
                                          else
                                            return null;
                                        },
                                        hintText: 'Nhập vào đơn vị',
                                        enable:
                                        state.loadingStatus == LoadStatus.LOADING ? false : true,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Đơn giá',
                                        style: AppTextStyle.greyS18,
                                      ),
                                      SizedBox(height: 10),
                                      AppTextField(
                                        controller: unitPriceController,
                                        validator: (value) {
                                          if (Validator.validateNullOrEmpty(value!))
                                            return "Chưa nhập đơn giá";
                                          else
                                            return null;
                                        },
                                        hintText: 'Nhập vào đơn giá',
                                        enable:
                                        state.loadingStatus == LoadStatus.LOADING ? false : true,
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
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
                                          BlocBuilder<UpdateMaterialCubit, UpdateMaterialState>(
                                            builder: (context, state) {
                                              return Expanded(
                                                child: AppButton(
                                                  color: AppColors.main,
                                                  isEnabled: state.buttonEnabled,
                                                  isLoading:
                                                  state.loadingStatus == LoadStatus.LOADING
                                                      ? true
                                                      : false,
                                                  title: 'Xác nhận',
                                                  onPressed: () async {
                                                    if(_formKey2.currentState!.validate()){
                                                      _cubit!.changeName(nameController.text);
                                                      _cubit!.changeUnit(unitController.text);
                                                      _cubit!.changeUnitPrice(int.parse(unitPriceController.text));
                                                      _cubit!.changeQuantity(int.parse(quantityController.text));
                                                      await _cubit!.updateMaterial(widget.materialId);
                                                    }

                                                    Navigator.of(context).pop(true);
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                    ]),
                              );
                            })))));
  }
}
