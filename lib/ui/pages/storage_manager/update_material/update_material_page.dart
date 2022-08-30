import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/ui/components/app_button.dart';
import 'package:flutter_base/ui/pages/storage_manager/update_material/update_material_cubit.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_button.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_snackbar.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_text_field.dart';
import 'package:flutter_base/utils/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
  late TextEditingController nameController;
  late TextEditingController unitController;
  late TextEditingController unitPriceController;
  final _formKey = GlobalKey<FormState>();

  UpdateMaterialCubit? _cubit;

  final formatCurrency = new NumberFormat.currency(locale: 'vi');
  final formatCurrencyNoLabel = new NumberFormat.currency(locale: 'vi', symbol: '');


  @override
  void initState() {
    _cubit = BlocProvider.of<UpdateMaterialCubit>(context);
    _cubit?.getMaterialById(widget.materialId);
    quantityController = TextEditingController(
      text: _cubit!.state.quantity.toString(),
    );
    nameController = TextEditingController(
      text: _cubit!.state.name,
    );
    unitController = TextEditingController(
      text: _cubit!.state.unit,
    );
    unitPriceController = TextEditingController(
      text: _cubit!.state.unitPrice.toString(),
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
              bloc: _cubit,
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Text(
                            'Thông tin chi tiết: ',
                            style: AppTextStyle.blackS18Bold,
                          ),
                          InkWell(
                            child: Icon(Icons.mode_edit_outline,
                                color: AppColors.mainDarker),
                            splashColor: AppColors.main,
                            onTap: () async {
                              showDialog(
                                  context: context,
                                  builder: (context) => _modifyDialog()
                                  // _dialogModifyUnitPrice()
                                  );
                            },
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Tên vật tư:',
                                    style: AppTextStyle.greyS16,
                                  ),
                                  Text(
                                    "${state.name}",
                                    style: AppTextStyle.greyS16,
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Divider(
                                color: Colors.grey,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Đơn vị: ',
                                    style: AppTextStyle.greyS16,
                                  ),
                                  Text(
                                    "${state.unit}",
                                    style: AppTextStyle.greyS16,
                                  )
                                ],
                              ),
                              SizedBox(height: 5),
                              Divider(
                                color: Colors.grey,
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Đơn giá: ',
                                    style: AppTextStyle.greyS16,
                                  ),
                                  Text(
                                    "${formatCurrency.format(state.unitPrice ?? 0).toString()}",
                                    style: AppTextStyle.greyS16,
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Divider(
                                color: Colors.grey,
                              ),
                              SizedBox(height: 10),
                            ],
                          )),
                      Text(
                        'Số lượng: ',
                        style: AppTextStyle.blackS18Bold,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            SizedBox(height: 15),
                            BlocConsumer<UpdateMaterialCubit,
                                UpdateMaterialState>(
                              bloc: _cubit,
                              listener: (context, state) {
                                quantityController = TextEditingController(
                                  text: _cubit!.state.quantity.toString(),
                                );
                                nameController = TextEditingController(text: _cubit!.state.name);
                                unitPriceController = TextEditingController(text: formatCurrencyNoLabel.format(_cubit!.state.unitPrice ?? 0));
                                unitController = TextEditingController(text: _cubit!.state.unit);
                              },
                              builder: (context, state) {
                                return AppTextField(
                                  autoValidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  hintText: 'Nhập vào số lượng',
                                  controller: quantityController,
                                  keyboardType: TextInputType.number,
                                  suffixText: "${state.unit}",
                                  suffixTextStyle: TextStyle(
                                      color: AppColors.mainDarker,
                                      fontSize: 16),
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
                            BlocConsumer<UpdateMaterialCubit,
                                UpdateMaterialState>(
                              bloc: _cubit,
                              listenWhen: (prev, current) {
                                return prev.loadingStatus !=
                                    current.loadingStatus;
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
                                          _cubit?.changeQuantity(int.parse(
                                              quantityController.text.length ==
                                                      0
                                                  ? '0'
                                                  : quantityController.text));
                                          _cubit?.updateMaterial(
                                              widget.materialId!);
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
                      )
                    ],
                  ),
                );
              }),
        ));
  }

  Widget _modifyDialog() {
    return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text("Thay đổi thông tin"),
        content: Container(
          width: MediaQuery.of(context).size.width,
          constraints: BoxConstraints(maxHeight: double.infinity),
          child: Form(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildTextLabel("Tên vật tư"),
                             AppTextField(
                                      autoValidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      hintText: 'Nhập vào tên vật tư',
                                      controller: nameController,
                                      suffixTextStyle: TextStyle(
                                          color: AppColors.mainDarker,
                                          fontSize: 16),
                                      validator: (value) {
                                        if (Validator.validateNullOrEmpty(
                                            value!))
                                          return "Chưa nhập tên vật tư";
                                        else
                                          return null;
                                      },
                                    ),
                                _buildTextLabel("Đơn vị"),
                                Container(
                                  child: AppTextField(
                                    autoValidateMode: AutovalidateMode.onUserInteraction,
                                    hintText: "Nhâp vào đơn vị",
                                    controller: unitController,
                                    validator: (value) {
                                      if (Validator.validateNullOrEmpty(
                                          value!))
                                        return "Chưa nhập đơn vị";
                                      else
                                        return null;
                                    },
                                  ),
                                ),
                                _buildTextLabel("Đơn giá"),
                                Container(
                                  child: AppTextField(
                                    autoValidateMode: AutovalidateMode.onUserInteraction,
                                    hintText: "Nhâp vào đơn giá",
                                    suffixText: "VND",
                                    controller: unitPriceController,
                                    keyboardType: TextInputType.number,
                                    suffixTextStyle:
                                        TextStyle(color: AppColors.main),
                                    inputFormatters: [
                                      CurrencyTextInputFormatter(
                                        locale: 'vi',
                                        symbol: '',
                                      ),
                                    ],
                                    validator: (value) {
                                      if (Validator.validateNullOrEmpty(
                                          value!))
                                        return "Chưa nhập đơn giá";
                                      else
                                        return null;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: BlocConsumer<UpdateMaterialCubit,
                                      UpdateMaterialState>(
                                    bloc: _cubit,
                                    listenWhen: (prev, current) {
                                      return prev.loadingStatus !=
                                          current.loadingStatus;
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
                                              onPressed: () async {
                                                if (_formKey.currentState!.validate()) {
                                                  _cubit?.changeName(nameController.text);
                                                  _cubit?.changeUnit(unitController.text);
                                                  _cubit?.changeUnitPrice(int.parse(formatNumberToDefault(unitPriceController.text)));
                                                  await _cubit?.updateMaterialInformation(widget.materialId!);
                                                }
                                              },
                                              isLoading: isLoading,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                )],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildTextLabel(String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      alignment: Alignment.centerLeft,
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
  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(AppSnackBar(
      message: message,
      typeSnackBar: '',
    ));
  }
  String formatNumberToDefault(String number){
   number = number.replaceAll(".", "");
    return number;
  }

  void _showCreateSuccess() async {
    showSnackBar('Thay đổi vật tư thành công!');
    Navigator.of(context).pop(true);
  }
}
