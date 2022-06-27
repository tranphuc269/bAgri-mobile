import 'package:flutter/material.dart';
import 'package:flutter_base/blocs/app_cubit.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_shadow.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/models/entities/material/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppMaterialPicker extends StatefulWidget {
  String? hintText;
  AutovalidateMode? autoValidateMode;
  String? materialId;
  bool centerItem;
  TextStyle? textStyle;
  ValueChanged<MaterialEntity?>? onChange;
  // FormFieldValidator<String>? validator;
  AppMaterialPicker(
      {Key? key,
        this.autoValidateMode,
        this.textStyle,
        this.hintText,
        this.materialId,
        this.onChange,
        // this.validator,
        this.centerItem = false})
      : super(key: key);

  @override
  State<AppMaterialPicker> createState() => _AppMaterialPickerState();
}

class _AppMaterialPickerState extends State<AppMaterialPicker> {
  late List<MaterialEntity> _materialList;
  late AppCubit _appCubit;
  MaterialEntity? value;

  @override
  void initState() {
    _appCubit = BlocProvider.of<AppCubit>(context);
    _materialList = _appCubit.state.listMaterials!;
    // _gardenList = _appCubit.state.gardens!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.materialId != null) {
      value = _materialList
          .firstWhere((element) => element.materialId == widget.materialId);
    }
    return Stack(
      children: [
        Container(
          height: 48,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [AppShadow.appBoxShadow],
              borderRadius: BorderRadius.circular(5)),
        ),
        DropdownButtonFormField(
            value: value,
            autovalidateMode: widget.autoValidateMode,
            style: widget.textStyle ?? AppTextStyle.blackS14SemiBold,
            icon: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(Icons.keyboard_arrow_down)),
            onChanged: widget.onChange,
            decoration: InputDecoration(
              hintText: widget.hintText ?? 'Chọn vật tư',
              hintStyle: AppTextStyle.greyS14,
              contentPadding:
              EdgeInsets.only(top: 10, right: 10, bottom: 10, left: 20),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.mainDarker),
                  borderRadius: BorderRadius.circular(5)),
              focusColor: AppColors.main,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.main),
                  borderRadius: BorderRadius.circular(5)),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.main),
                  borderRadius: BorderRadius.circular(5)),
            ),
            isExpanded: true,
            items: _materialList.map((value) {
              return DropdownMenuItem<MaterialEntity>(
                alignment: widget.centerItem
                    ? Alignment.center
                    : AlignmentDirectional.centerStart,
                child: Text(value.name ?? ""),
                value: value,
              );
            }).toList()),
      ],
    );
  }
}
