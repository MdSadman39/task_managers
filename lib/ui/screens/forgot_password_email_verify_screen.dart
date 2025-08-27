import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_managers/data/services/network_caller.dart';
import 'package:task_managers/ui/widgets/snack_bar_message.dart';
import '../../data/utils/urls.dart';
import '../utils/app_colors.dart';
import '../widgets/screen_background.dart';
import 'forgot_pasword_verify_otp_screen.dart';

class ForgotPasswordVerifyEmailScreen extends StatefulWidget {
  const ForgotPasswordVerifyEmailScreen({super.key});

  static const String name = '/forgot-password/verify-email';

  @override
  State<ForgotPasswordVerifyEmailScreen> createState() =>
      _ForgotPasswordVerifyEmailScreenState();
}

class _ForgotPasswordVerifyEmailScreenState
    extends State<ForgotPasswordVerifyEmailScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _getEmailVerifypasswordInProgress = false;

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
                  Text('Your Email Address', style: textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text(
                    'A 6 digit of OTP will be send your email',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailTEController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(hintText: 'Email'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      _onTapEmailVerifyButton();
                    },
                    child: Icon(Icons.arrow_circle_right_outlined),
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

  void _onTapEmailVerifyButton() {
    if (_formKey.currentState!.validate()) {
      _getEmailVerifypassword();
    }
  }

  Future<void> _getEmailVerifypassword() async {
    _getEmailVerifypasswordInProgress = true;
    setState(() {});

    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.forgotVerifyEmailUrl(_emailTEController.text),
    );
    if (response.isSuccess) {
      _emailTEController.text;
      showSnackBarMessage(context, 'check your email');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return ForgotPasswordVerifyOtpScreen(
              email: _emailTEController.text,
            );
          },
        ),
      );
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }

    _getEmailVerifypasswordInProgress = false;
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
                Navigator.pop(context);
              },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }
}
