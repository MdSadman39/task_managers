import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_managers/data/services/network_caller.dart';
import 'package:task_managers/ui/widgets/snack_bar_message.dart';
import '../../data/utils/urls.dart';
import '../utils/app_colors.dart';
import '../widgets/screen_background.dart';
import 'forgot_password_reset_password_screen.dart';
import 'sign_in_screen.dart';

class ForgotPasswordVerifyOtpScreen extends StatefulWidget {
  const ForgotPasswordVerifyOtpScreen({super.key, this.email});
  final String? email;

  static const String name = '/forgot-password/verify-otp';

  @override
  State<ForgotPasswordVerifyOtpScreen> createState() =>
      _ForgotPasswordVerifyOtpScreenState();
}

class _ForgotPasswordVerifyOtpScreenState
    extends State<ForgotPasswordVerifyOtpScreen> {
  final TextEditingController _otpTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _verifyOtpInProgress = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Text('Pin Verification', style: textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text(
                    'A 6 digit of OTP has been sent to your email',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildPinCodeTextField(),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      _onTapForgotPasswordOtp();
                    },
                    child: const Text('Verify'),
                  ),
                  const SizedBox(height: 48),
                  Center(child: _buildSignInSection()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapForgotPasswordOtp() {
    if (_formKey.currentState!.validate()) {
      _verifyOtp();
    }
  }

  Future<void> _verifyOtp() async {
    _verifyOtpInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.forgotVerifyOtpUrl(
        widget.email.toString(),
        _otpTEController.text,
      ),
    );

    if (response.responseData?['status'] != 'success') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return ForgotPasswordResetPasswordScreen(
              email: widget.email,
              otp: _otpTEController.text,
            );
          },
        ),
      );
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
    _verifyOtpInProgress = false;
    setState(() {});
  }

  Widget _buildPinCodeTextField() {
    return PinCodeTextField(
      length: 6,
      animationType: AnimationType.fade,
      keyboardType: TextInputType.number,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 50,
        activeFillColor: Colors.white,
        inactiveFillColor: Colors.white,
        selectedFillColor: Colors.white,
      ),
      animationDuration: Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      enableActiveFill: true,
      controller: _otpTEController,
      appContext: context,
    );
  }

  Widget _buildSignInSection() {
    return RichText(
      text: TextSpan(
        children: [
          const TextSpan(
            text: ' have an account? ',
            style: TextStyle(color: Colors.black),
          ),
          TextSpan(
            text: 'Sign in',
            style: const TextStyle(color: AppColors.themeColor),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  SignInScreen.name,
                  (value) => false,
                );
              },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _otpTEController.dispose();
    super.dispose();
  }
}
