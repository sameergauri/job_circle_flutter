// ignore_for_file: prefer_final_fields, use_build_context_synchronously, unused_element, use_full_hex_values_for_flutter_colors, deprecated_member_use
// ignore_for_file: prefer_final_fields, use_build_context_synchronously, unused_element, use_full_hex_values_for_flutter_colors
import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/provider/login_signup_provider/login_provider.dart';
import 'package:job_circle/src/screen/login_and_signup/login/otp.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    // ✅ Automatically detect phone numbers on page load
    Future.delayed(Duration.zero, () {
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      loginProvider.getPhoneNumbers();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colors = context.appColors;
    final loginProvider = Provider.of<LoginProvider>(context);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: colors.bgColor,
          body: Column(
            children: [
              /// JC Logo
              Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 8,
                ),
                width: MediaQuery.of(context).size.width / 1.8,
                child: Image.asset(
                  isDarkMode
                      ? CustomAssetUrl
                            .jcLogoForDark // Image for Dark Theme
                      : CustomAssetUrl.jclogoicon, // Image for Light Theme
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 40),

              /// Title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: customText(
                  title: "Select your Mobile Number",
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                  color: colors.headingColor,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: customText(
                  title: "We will send you a 4 digit verification code",
                  fontSize: 14,
                  color: colors.subTitleColor,
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 30),

              /// ✅ SIM Cards - Direct Display (No Bottom Sheet!)
              Expanded(
                child: loginProvider.isLoadingNumbers
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            customText(title: 'Detecting SIM cards...'),
                          ],
                        ),
                      )
                    : loginProvider.phoneNumbers.isEmpty
                    ? _buildNoPhoneView(loginProvider)
                    : _buildSimCardsView(loginProvider, colors),
              ),

              /// Footer
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      customText(
                        title: "Made in",
                        fontWeight: FontWeight.bold,
                        color: colors.headingColor,
                      ),
                      const SizedBox(width: 6),
                      Image.asset(CustomAssetUrl.indiaicon, height: 22),
                      const SizedBox(width: 6),
                      customText(
                        title: "with",
                        fontWeight: FontWeight.bold,
                        color: colors.headingColor,
                      ),
                      const SizedBox(width: 6),
                      Image.asset(CustomAssetUrl.hearticon, height: 22),
                    ],
                  ),
                  const SizedBox(height: 8),
                  customText(
                    title: "@ All rights reserved - 2026-27",
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colors.headingColor,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ],
          ),
        ),

        if (loginProvider.isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  /// ✅ SIM Cards Display - Automatic Cards
  Widget _buildSimCardsView(LoginProvider provider, AppColors colors) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: provider.phoneNumbers.length,
      itemBuilder: (context, index) {
        final simData = provider.phoneNumbers[index];
        final phoneNumber = simData['number'] ?? '';
        final carrier = simData['carrier'] ?? 'Unknown';
        final slot = index == 0 ? "Slot 1" : "Slot 2";

        final isSelected = provider.selectedPhoneNumber == phoneNumber;

        return GestureDetector(
          onTap: () => _selectAndSendOTP(provider, phoneNumber),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
              top: 10,
              bottom: 10,
            ),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        Constants.darkBlue.withOpacity(0.1),
                        Constants.darkBlue.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [colors.appbarColor!, colors.appbarColor!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              // color: isSelected ? null : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? Constants.darkBlue : Colors.grey.shade300,
                width: isSelected ? 0.9 : 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? Constants.darkBlue.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.1),
                  blurRadius: isSelected ? 12 : 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // SIM Icon with Animation
                Icon(
                  Icons.sim_card_outlined,
                  color: colors.subTitleColor,
                  size: 32,
                ),
                const SizedBox(width: 18),

                // Phone Number & Carrier Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                        monst: true,
                        title: phoneNumber,
                        fontSize: 16,
                        // fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Constants.darkBlue
                            : colors.textPrimary,
                        letterspacing: 0.5,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          customText(
                            title: "$slot : $carrier",
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: colors.subTitleColor,
                            fontStyle: FontStyle.italic,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Check Icon
                AnimatedScale(
                  scale: isSelected ? 1.0 : 0.8,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isSelected ? Icons.check_circle : Icons.circle_outlined,
                    color: isSelected
                        ? Constants.darkBlue
                        : Colors.grey.shade400,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// No Phone Detected View
  Widget _buildNoPhoneView(LoginProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sim_card_alert_rounded,
              size: 100,
              color: Colors.orange.shade400,
            ),
            const SizedBox(height: 24),
            const customText(
              title: 'No SIM Card Detected',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            customText(
              title:
                  'Please check the SIM card in your phone\nor allow permissions',
              fontSize: 14,
              color: Colors.grey.shade600,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => provider.getPhoneNumbers(),
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const customText(
                title: 'Retry',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Constants.darkBlue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Select Phone and Send OTP
  Future<void> _selectAndSendOTP(
    LoginProvider provider,
    String phoneNumber,
  ) async {
    // Set selected phone number
    provider.setSelectedPhoneNumber(phoneNumber);

    // Extract only digits for backend
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    // Take last 10 digits
    if (cleanNumber.length > 10) {
      cleanNumber = cleanNumber.substring(cleanNumber.length - 10);
    }

    // Set in mobileController
    provider.mobileController.text = cleanNumber;

    // Send OTP
    final success = await provider.generateOTP(context);

    if (success) {
      // Navigate to OTP screen
      NavigationService.pushReplacement(const OTPScreen());
    } else {
      CustomSnackbar.show("Failed to send OTP", true);
    }
  }
}

/* // ignore_for_file: prefer_final_fields, use_build_context_synchronously, unused_element, use_full_hex_values_for_flutter_colors
import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/bottom_dialogue.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
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
                    } else {
                      CustomSnackbar.show("Failed to generate OTP", true);
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
 */
