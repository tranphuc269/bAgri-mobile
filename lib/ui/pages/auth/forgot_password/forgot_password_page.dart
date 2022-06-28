import 'package:flutter/material.dart';
import 'package:flutter_base/commons/app_colors.dart';
import 'package:flutter_base/commons/app_images.dart';
import 'package:flutter_base/commons/app_text_styles.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/router/application.dart';
import 'package:flutter_base/router/routers.dart';
import 'package:flutter_base/ui/pages/auth/forgot_password/forgot_password_cubit.dart';
import 'package:flutter_base/ui/pages/auth/otp_authentication/otp_authentication_page.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_button.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_snackbar.dart';
import 'package:flutter_base/ui/widgets/b_agri/app_text_field.dart';
import 'package:flutter_base/utils/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  ForgotPasswordCubit? _cubit;
  final _emailController = TextEditingController(text: "");
  final _passwordController = TextEditingController(text: "");
  final _confirmPasswordController = TextEditingController(text: "");

  bool _visiblePassword = false;
  bool _visibleConfirmPassword = false;

  @override
  void initState() {
    _cubit = BlocProvider.of<ForgotPasswordCubit>(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBarWidget(
        title: "Quên mật khẩu",
        context: context,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      child: _buildLogo(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                          child: Text(
                        "Nhập vào địa chỉ email liên kết với tài khoản của bạn ",
                        style: AppTextStyle.greenS18Bold,
                        textAlign: TextAlign.center,
                      )),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Địa chỉ email",
                      style: AppTextStyle.greyS14,
                    ),
                    SizedBox(height: 10),
                    AppTextField(
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      hintText: 'Nhập vào địa chỉ email',
                      controller: _emailController,
                      validator: (value) {
                        if (Validator.validateNullOrEmpty(value!))
                          return "Vui lòng nhập địa chỉ email";
                        else
                          return null;
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    _buildChangePassword(),
                  ],
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }

  _buildLogo() {
    return Container(
      width: 180,
      height: 180,
      alignment: Alignment.center,
      child: Image.asset(AppImages.icBAgri, width: 180),
    );
  }

  Widget _buildChangePassword() {
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      bloc: _cubit,
      listenWhen: (prev, current) {
        return (prev.loadStatus != current.loadStatus);
      },
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.SUCCESS) {
          _showSuccess();
        }
        if (state.loadStatus == LoadStatus.FAILURE) {
          showSnackBar('Có lỗi xảy ra!');
        }
      },
      builder: (context, state) {
        final isLoading = state.loadStatus == LoadStatus.LOADING;
        return AppButton(
          width: double.infinity,
          title: 'Thay đổi mật khẩu',
          color: AppColors.main,
          isLoading: isLoading,
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => const PinCodeVerificationScreen()),
            // );
            if (_formKey.currentState!.validate()) {
              _cubit!.forgotPassword(_emailController.text);
            }
          },
        );
      },  );
  }

  void _showSuccess() async {
    showSnackBar('Mã OTP đã được gửi đến email của bạn!');
    Application.router!.navigateTo(
      context,
      Routes.OtpAuth,
      routeSettings: RouteSettings(arguments: _emailController.text)
    );
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(AppSnackBar(
      typeSnackBar: "success",
      message: message,
    ));
  }
}
