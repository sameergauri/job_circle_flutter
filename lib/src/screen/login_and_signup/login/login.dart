// ignore_for_file: prefer_final_fields, use_build_context_synchronously, unused_element, use_full_hex_values_for_flutter_colors, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show SystemNavigator, FilteringTextInputFormatter;
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/provider/login_signup_provider/login_provider.dart';
import 'package:job_circle/src/screen/login_and_signup/login/otp.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/terms_privacy_codepage.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';
import 'package:job_circle/src/widgets/button/custom_button_for_save.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
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
    Future.delayed(Duration.zero, () async {
      final consented = SharedPrefsHelper.getBool(
        ESharedPreferences.sim_consent_agreed,
      );
      if (!consented) {
        await _showPrivacyConsentDialog();
      }
      if (!mounted) return;
      final provider = Provider.of<LoginProvider>(context, listen: false);
      provider.getPhoneNumbers();
    });
  }

  Future<void> _showPrivacyConsentDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PopScope(
        canPop: false,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF1E1E2E)
                  : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Constants.darkBlue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.verified_user_rounded,
                      color: Constants.darkBlue,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Data Privacy Notice",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : const Color(0xFF1A1A2E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Constants.darkBlue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Constants.darkBlue.withOpacity(0.15),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      "Job Circle collects and transmits your mobile number and SIM identity to enable secure same-device login during account authentication.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : Colors.grey.shade700,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => SystemNavigator.pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey.shade600,
                            side: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1.5,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await SharedPrefsHelper.setPreference(
                              ESharedPreferences.sim_consent_agreed,
                              true,
                            );
                            if (dialogContext.mounted) {
                              Navigator.of(dialogContext).pop();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constants.darkBlue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "I Agree",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colors = context.appColors;
    final loginProvider = Provider.of<LoginProvider>(context);
    final isPhoneListEmpty = loginProvider.phoneNumbers.isEmpty;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: colors.bgColor,
          body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 1.05,
              child: Column(
                children: [
                  /// JC Logo
                  Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 9,
                    ),
                    width: MediaQuery.of(context).size.width / 1.8,
                    child: Image.asset(
                      isDarkMode
                          ? CustomAssetUrl.jcLogoForDark
                          : CustomAssetUrl.jclogoicon,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 32),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: customText(
                      title: "Login or Sign up",
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                      color: colors.headingColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: customText(
                      title: "We will send you a 4 digit verification code",
                      fontSize: 14,
                      color: colors.subTitleColor,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// Main Action Layout Component
                  if (loginProvider.isLoadingNumbers)
                    Expanded(child: Center(child: CircularProgressIndicator()))
                  else if (!isPhoneListEmpty) ...[
                    // SIM Auto Detection Container Block
                    _buildSimCardsView(loginProvider, colors),
                    const SizedBox(
                      height: 30,
                    ), // Explicit 40dp uniform spacing constraint allocation gap
                    _buildBottomActionArea(loginProvider, colors),
                    const Spacer(),
                    /*  Expanded(
                      flex: 2,
                      child: _buildSimCardsView(loginProvider, colors),
                    ),
                    _buildBottomActionArea(loginProvider, colors), */
                  ] else ...[
                    // Manual Fallback Entry Block (Instantly takes minimal space)
                    _buildNoPhoneView(loginProvider, colors),
                    const SizedBox(height: 40),
                    _buildBottomActionArea(loginProvider, colors),
                    const Spacer(),
                  ],

                  /// Footer Structure
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16, top: 8),
                    child: Column(
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
                        const SizedBox(height: 6),
                        customText(
                          title: "@ All rights reserved 2026-27",
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: colors.headingColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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

  /// Extracted Button and Policy Terms Segment
  Widget _buildBottomActionArea(LoginProvider provider, AppColors colors) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButtonForSave(
            buttonColor: colors.darkBlue,
            textColor: Constants.white,
            isPading: false,
            onTap: () async => await _selectAndSendOTP(provider),
            title: provider.phoneNumbers.isNotEmpty ? "Continue" : "Continue",
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: GoogleFonts.merriweather(
                  fontSize: 12,
                  color: colors.textPrimary,
                ),
                children: [
                  const TextSpan(text: "By continuing, I agree to "),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: InkWell(
                      onTap: () =>
                          NavigationService.push(const TermsPrivacyCodePage()),
                      child: Text(
                        "Terms of Service",
                        style: GoogleFonts.merriweather(
                          fontSize: 12,
                          color: colors.darkBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Modern SIM View Block
  Widget _buildSimCardsView(LoginProvider provider, AppColors colors) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: provider.phoneNumbers.length,
      itemBuilder: (context, index) {
        final simData = provider.phoneNumbers[index];
        final phoneNumber = simData['number'] ?? '';
        final isSelected = provider.selectedPhoneNumber == phoneNumber;

        return GestureDetector(
          onTap: () => provider.setSelectedPhoneNumber(phoneNumber),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? colors.darkBlue!.withOpacity(0.04)
                  : colors.bgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? colors.darkBlue!
                    : colors.textPrimary!.withOpacity(0.15),
                width: isSelected ? 1.8 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isSelected ? 0.04 : 0.01),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (isSelected ? colors.darkBlue : colors.textPrimary)
                        ?.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.sim_card_outlined,
                    color: isSelected ? colors.darkBlue : colors.textPrimary,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                        title: phoneNumber,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                      const SizedBox(height: 3),
                      customText(
                        title: "${simData['carrier']} • ${simData['slot']}",
                        fontSize: 12,
                        color: isSelected
                            ? colors.darkBlue
                            : colors.subTitleColor,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ],
                  ),
                ),
                Icon(
                  isSelected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  color: isSelected
                      ? colors.darkBlue
                      : colors.textPrimary?.withOpacity(0.4),
                  size: 24,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Compact Manual Form Entry Fallback
  Widget _buildNoPhoneView(LoginProvider provider, AppColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          //  color: Theme.of(context).cardColor,
          border: Border.all(
            color: colors.textPrimary!.withOpacity(0.2),
            width: 1.2,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                //color: colors.textPrimary!.withOpacity(0.03),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(13),
                  bottomLeft: Radius.circular(13),
                ),
              ),
              alignment: Alignment.center,
              child: CustomNetworkImage(
                height: 40,
                width: 40,
                imageUrl: CustomIconUrl.indiaFlagIcon,
                defaultIcon: Icons.flag_circle_outlined,
              ),
            ),
            Container(
              width: 1.2,
              height: 24,
              color: colors.textPrimary!.withOpacity(0.2),
            ),
            Expanded(
              child: TextField(
                controller: provider.mobileController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: GoogleFonts.merriweather(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
                decoration: InputDecoration(
                  filled: false,
                  fillColor: Colors.transparent,
                  hintText: "Enter mobile number",
                  hintStyle: GoogleFonts.merriweather(
                    color: colors.subTitleColor!.withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  counterText: "",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectAndSendOTP(LoginProvider provider) async {
    String numberToUse =
        provider.selectedPhoneNumber ?? provider.mobileController.text.trim();

    if (numberToUse.isEmpty) {
      CustomSnackbar.show("Please select or enter number", true);
      return;
    }

    String cleanNumber = numberToUse.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanNumber.length > 10) {
      cleanNumber = cleanNumber.substring(cleanNumber.length - 10);
    }

    if (cleanNumber.length != 10) {
      CustomSnackbar.show("Enter valid 10 digit number", true);
      return;
    }

    final firstDigit = cleanNumber[0];
    if (['0', '1', '2', '3', '4', '5'].contains(firstDigit)) {
      CustomSnackbar.show("Number should not start with 0,1,2,3,4,5", true);
      return;
    }

    provider.mobileController.text = cleanNumber;

    final success = await provider.generateOTP(context);
    if (success) {
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
