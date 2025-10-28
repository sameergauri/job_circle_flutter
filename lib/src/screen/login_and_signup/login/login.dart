// ignore_for_file: prefer_final_fields, use_build_context_synchronously, unused_element, use_full_hex_values_for_flutter_colors
import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/bottom_dialogue.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/provider/login_signup_provider/login_provider.dart';
import 'package:job_circle/src/screen/login_and_signup/login/otp.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/widgets/button/theme_button.dart';
import 'package:job_circle/src/widgets/text_field/custom_login_screen_textfield.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode mobileFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    // Page open होते ही bottom sheet show ho
    Future.delayed(Duration.zero, () {
      BottomDialog().showBottomDialog(
        context,
        _buildDialogContent(context),
        false,
      );
      mobileFocus.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// JC Logo
              Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 8,
                ),
                width: MediaQuery.of(context).size.width / 1.8,
                child: Image.asset(
                  CustomAssetUrl.jclogoicon,
                  fit: BoxFit.cover,
                ),
              ),

              /// Footer
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Made in",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 6),
                          Image.asset(CustomAssetUrl.indiaicon, height: 22),
                          const SizedBox(width: 6),
                          const Text(
                            "with",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 6),
                          Image.asset(CustomAssetUrl.hearticon, height: 22),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "@ All rights reserved - 2025-26",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        if (loginProvider.isLoading)
          const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  /// Bottom Sheet UI
  Widget _buildDialogContent(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    return IntrinsicHeight(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Enter Mobile Number",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const Text(
              "We will send you a 4 digit verification code",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            /// TextField
            Form(
              key: _formKey,
              child: customLoginTextField(
                loginProvider: loginProvider,
                mobileFocus: mobileFocus,
              ),
            ),

            const SizedBox(height: 20),

            /// Get OTP Button
            Consumer<LoginProvider>(
              builder: (context, provider, _) => ThemeButton(
                radious: 8,
                text: "Get OTP",
                color: Constants.darkBlue,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final success = await provider.generateOTP(context);
                    if (success) {
                      NavigationService.pushReplacement(OTPScreen());
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
