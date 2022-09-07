import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/generated/l10n.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/router/application.dart';
import 'package:flutter_base/router/routers.dart';
import 'package:flutter_base/ui/pages/auth/otp_authentication/otp_authentication_cubit.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_button.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_snackbar.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_text_field.dart';
import 'package:flutter_base/utils/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'dart:async';

import 'package:flutter/material.dart';

class OtpAuthenticationPage extends StatefulWidget {
  final String? email;

  const OtpAuthenticationPage({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _OtpAuthenticationPageState();
  }
}

class _OtpAuthenticationPageState extends State<OtpAuthenticationPage> {
  TextEditingController textEditingController = TextEditingController();
  final _passwordController = TextEditingController(text: '');
  final _confirmPasswordController = TextEditingController(text: '');
  StreamController<ErrorAnimationType>? errorController;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late StreamSubscription _showMessageSubscription;

  OtpAuthenticationCubit? _cubit;

  bool _visiblePassword = false;
  bool _visibleConfirmPassword = false;
  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _cubit = BlocProvider.of<OtpAuthenticationCubit>(context);
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    super.dispose();
  }

  // snackBar widgets
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void showSnackBarSuccess(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(AppSnackBar(
      typeSnackBar: "success",
      message: message,
    ));
  }

  void showSnackBarError(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(AppSnackBar(
      typeSnackBar: "error",
      message: message,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(
        title: "Quên mật khẩu",
        context: context,
      ),
      body: GestureDetector(
        onTap: () {},
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 20),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Xác thực!',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: AppColors.mainDarker),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                      text: "Mã xác thực đã được gửi về địa chỉ email: ",
                      children: [
                        TextSpan(
                            text: "${widget.email}",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 15)),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 30),
                    child: Column(
                      children: [
                        _buildTextLabel(
                            S.of(context).transaction_progress_enterOTP),
                        SizedBox(
                          height: 10,
                        ),
                        PinCodeTextField(
                          appContext: context,
                          pastedTextStyle: TextStyle(
                            color: Colors.green.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                          length: 6,
                          obscureText: false,
                          blinkWhenObscuring: true,
                          animationType: AnimationType.fade,
                          validator: (v) {
                            if (v!.length < 6) {
                              return "Mã xác thực chưa chính xác";
                            } else {
                              return null;
                            }
                          },
                          pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(5),
                              activeFillColor: Colors.white,
                              inactiveFillColor: Colors.white,
                              selectedFillColor: Colors.white,
                              inactiveColor: AppColors.main,
                              selectedColor: AppColors.mainDarker),
                          cursorColor: AppColors.mainDarker,
                          animationDuration: const Duration(milliseconds: 300),
                          enableActiveFill: true,
                          errorAnimationController: errorController,
                          controller: textEditingController,
                          keyboardType: TextInputType.number,
                          boxShadows: const [
                            BoxShadow(
                              offset: Offset(0, 1),
                              color: Colors.black12,
                              blurRadius: 10,
                            )
                          ],
                          onCompleted: (v) {
                            // print(textEditingController.text);
                            debugPrint("Completed");
                          },
                          // onTap: () {
                          //   print("Pressed");
                          // },
                          onChanged: (value) {
                            debugPrint(value);
                            setState(() {
                              currentText = value;
                            });
                          },
                          beforeTextPaste: (text) {
                            debugPrint("Allowing to paste $text");
                            return true;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        _buildTextLabel(S.of(context).text_new_password),
                        SizedBox(
                          height: 10,
                        ),
                        _buildPasswordInput(),
                        SizedBox(
                          height: 20,
                        ),
                        _buildTextLabel(
                            S.of(context).text_confirm_new_password),
                        SizedBox(
                          height: 10,
                        ),
                        _buildConfirmPasswordInput(),
                      ],
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? "*Please fill up all the cells properly" : "",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              BlocConsumer<OtpAuthenticationCubit, OtpAuthenticationState>(
                  bloc: _cubit,
                  listenWhen: (prev, current) {
                    return (prev.OtpAuthStatus != current.OtpAuthStatus);
                  },
                  listener: (context, state) {
                    if (state.OtpAuthStatus == LoadStatus.SUCCESS) {
                      showSnackBarSuccess("Thay đổi mật khẩu thành công!");
                      Application.router!.navigateTo(
                        context,
                        Routes.login,
                      );
                    }
                    if (state.OtpAuthStatus == LoadStatus.FAILURE) {
                      showSnackBarError("Mã xác thực không chính xác");
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state.OtpAuthStatus == LoadStatus.LOADING;
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 30),
                      child: AppButton(
                        width: double.infinity,
                        title: 'Xác nhận',
                        color: AppColors.main,
                        isLoading: isLoading,
                        onPressed: () async {
                          formKey.currentState!.validate();
                          await _cubit!.AuthOtp(
                              widget.email,
                              textEditingController.text,
                              _passwordController.text);
                          if (currentText.length != 6 ||
                              _cubit!.state.OtpAuthStatus ==
                                  LoadStatus.FAILURE) {
                            errorController!.add(ErrorAnimationType
                                .shake); // Triggering error shake animation
                            setState(() => hasError = true);
                          } else {
                            setState(
                              () {
                                hasError = false;
                              },
                            );
                          }
                        },
                      ),
                    );
                  }),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextLabel(String text) {
    return Container(
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

  Widget _buildPasswordInput() {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Stack(
          children: [
            AppPasswordField(
              autoValidateMode: AutovalidateMode.onUserInteraction,
              hintText: 'Nhập vào mật khẩu mới',
              keyboardType: TextInputType.visiblePassword,
              obscureText: !_visiblePassword,
              controller: _passwordController,
              suffixIcon: InkWell(
                onTap: () {
                  setState(() {
                    _visiblePassword = !_visiblePassword;
                  });
                },
                child: Icon(
                  _visiblePassword ? Icons.visibility : Icons.visibility_off,
                  color:
                      _visiblePassword ? AppColors.main : AppColors.grayIntro,
                ),
              ),
              validator: (value) {
                if (Validator.validateNullOrEmpty(value!))
                  return "Chưa nhập mật khẩu";
                else
                  return null;
              },
            ),
          ],
        ));
  }

  Widget _buildConfirmPasswordInput() {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Stack(
          children: [
            AppPasswordField(
              autoValidateMode: AutovalidateMode.onUserInteraction,
              hintText: 'Nhập lại mật khẩu mới',
              keyboardType: TextInputType.visiblePassword,
              obscureText: !_visibleConfirmPassword,
              controller: _confirmPasswordController,
              suffixIcon: InkWell(
                onTap: () {
                  setState(() {
                    _visibleConfirmPassword = !_visibleConfirmPassword;
                  });
                },
                child: Icon(
                  _visibleConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: _visibleConfirmPassword
                      ? AppColors.main
                      : AppColors.grayIntro,
                ),
              ),
              validator: (value) {
                if (Validator.validateNullOrEmpty(value!))
                  return "Chưa nhập mật khẩu";
                if (_confirmPasswordController.text !=
                    _passwordController.text) {
                  return "Mật khẩu không trùng khớp";
                } else
                  return null;
              },
            ),
          ],
        ));
  }
}
