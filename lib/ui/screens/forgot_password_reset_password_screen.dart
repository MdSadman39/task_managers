import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_managers/data/services/network_caller.dart';
import 'package:task_managers/ui/widgets/snack_bar_message.dart';
import '../../data/utils/urls.dart';
import '../utils/app_colors.dart';
import '../widgets/screen_background.dart';
import 'sign_in_screen.dart';

class ForgotPasswordResetPasswordScreen extends StatefulWidget {
  const ForgotPasswordResetPasswordScreen({super.key, this.email, this.otp});
  final String? email;
  final String? otp;

  static const String name = '/forgot-password/reset-password';

  @override
  State<ForgotPasswordResetPasswordScreen> createState() =>
      _ForgotPasswordResetPasswordScreenState();
}

class _ForgotPasswordResetPasswordScreenState
    extends State<ForgotPasswordResetPasswordScreen> {
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _resetPasswordInProgress = false;

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
                  Text('Set Password', style: textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text(
                    'Minimum length of password 8 characters with latter and number combination',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordTEController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(hintText: 'Password'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter new password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirmPasswordTEController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(hintText: 'Confirm Password'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter confirm password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      _onTapResetPassword();
                    },
                    child: const Text('Confirm'),
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

  void _onTapResetPassword() {
    if (_formKey.currentState!.validate()) {
      _resetPassword();
    }
  }

  Future<void> _resetPassword() async {
    _resetPasswordInProgress = true;
    setState(() {});
    if (_passwordTEController.text == _confirmPasswordTEController.text) {
      Map<String, dynamic> requestBody = {
        "email": widget.email.toString(),
        "OTP": widget.otp.toString(),
        "password": _passwordTEController.text,
      };
      final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.resetPasswordUrl,
        body: requestBody,
      );
      if (response.isSuccess) {
        widget.email.toString();
        widget.otp.toString();
        Navigator.pushNamed(context, SignInScreen.name);
        showSnackBarMessage(context, 'Password reset successful');
      } else {
        showSnackBarMessage(context, response.errorMessage);
      }
    } else {
      showSnackBarMessage(context, 'Don\'t match password');
    }
    _resetPasswordInProgress = false;
    setState(() {});
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
    _passwordTEController.dispose();
    _confirmPasswordTEController.dispose();
    super.dispose();
  }
}
