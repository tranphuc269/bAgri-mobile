import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_images.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/configs/app_config.dart';
import 'package:flutter_base/global/global_data.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_button.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_text_field.dart';
import 'package:flutter_base/utils/validators.dart';
import 'package:flutter_base/utils/date_utils.dart' as Util;

class ModalShowFinishSeasonWidget extends StatefulWidget {
  const ModalShowFinishSeasonWidget(
      {Key? key,
        required this.onEnd,
      })
      : super(key: key);
  final void Function(int turnover) onEnd;



  @override
  State<ModalShowFinishSeasonWidget> createState() =>
      _ModalShowFinishSeasonWidgetState();
}

class _ModalShowFinishSeasonWidgetState extends State<ModalShowFinishSeasonWidget> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController turnoverController = TextEditingController(text: '');
  double heightResize = 0.7;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    turnoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentScope = FocusScope.of(context);
    final viewInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    if (viewInsetsBottom == 0 || currentScope.hasPrimaryFocus == true) {
      setState(() {
        heightResize = 0.7;
      });
    } else {
      setState(() {
        heightResize = 0.95;
      });
    }
    return Container(
      height: MediaQuery.of(context).size.height * heightResize,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20))),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFECE5D5),
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20))),
            height: 40,
            child: Stack(
              children: [
                Center(
                  child: Container(
                      height: 40,
                      padding: EdgeInsets.all(10),
                      child: Text('Kết thúc mùa vụ', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic), textAlign: TextAlign.center,)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Image.asset(
                        AppImages.icCloseCircleShadow,
                        height: 25,
                        width: 25,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  AppTextField(
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    hintText: 'Doanh thu mùa',
                    controller: turnoverController,
                    keyboardType: TextInputType.number,
                  ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            color: AppColors.redButton,
                            title: 'Kết thúc',
                            onPressed: () {
                              widget.onEnd(int.tryParse(turnoverController.text) ?? 0);
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ),
                      ],
                    ),

                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }


}
