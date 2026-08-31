import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_check_box_row.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/provider/business_page/business_comapny_provider.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';
import 'package:job_circle/src/widgets/button/custom_full_size_button.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:job_circle/src/widgets/text_field/custom_textfield_for_business_company.dart';
import 'package:provider/provider.dart';

class Page4IdentityVerification extends StatefulWidget {
  const Page4IdentityVerification({super.key});

  @override
  State<Page4IdentityVerification> createState() =>
      _Page4IdentityVerificationState();
}

class _Page4IdentityVerificationState extends State<Page4IdentityVerification> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userMobile = SharedPrefsHelper.getInt(
        ESharedPreferences.user_mobile,
      );
      if (userMobile != 0) {
        context.read<BusinessCompanyProvider>().initUserContactNumber(
          userMobile.toString(),
        );
      }
    });
  }

  void _showChangeContactBottomSheet(
    BuildContext context,
    BusinessCompanyProvider provider,
    AppColors colors,
  ) {
    provider.resetBottomSheetPhoneForm();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.bottomsheetbgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return Consumer<BusinessCompanyProvider>(
          builder: (context, p, _) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customText(
                        title: "Update Official Contact Number",
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: colors.headingColor,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(bottomSheetContext),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  customText(
                    title: "New Mobile Number*",
                    color: colors.headingColor,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AbsorbPointer(
                          absorbing: p.isPhoneOtpSent,
                          child: Opacity(
                            opacity: p.isPhoneOtpSent ? 0.7 : 1.0,
                            child: CustomTextFieldForEmailverification(
                              focusNode: p.newContactFocusNode,
                              controller: p.newContactController,
                              hint: "10-digit number",
                              isNumber: true,
                              maxLength: 10,
                              onChanged: (val) {
                                p.onNewContactChanged(val);
                              },
                            ),
                          ),
                        ),
                      ),
                      if (p.isPhoneOtpSent)
                        InkWell(
                          onTap: () {
                            p.resetPhoneOtpState();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Icon(
                              Icons.edit,
                              color: colors.headingColor,
                              size: 20,
                            ),
                          ),
                        ),
                      if (!p.isPhoneOtpSent &&
                          p.newContactController.text.trim().length == 10) ...[
                        const SizedBox(width: 8),
                        if (p.isPhoneOtpSending)
                          const SizedBox(
                            width: 32,
                            height: 32,
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        else
                          CustomToggleButton(
                            rightPaddingDissable: true,
                            title: "Verify",
                            onTap: () async {
                              final error = await p.sendPhoneOtp(
                                SharedPrefsHelper.getString(
                                  ESharedPreferences.user_firstName,
                                ),
                              );
                              if (bottomSheetContext.mounted) {
                                if (error == null) {
                                  CustomSnackbar.show(
                                    "OTP sent to new mobile number!",
                                    false,
                                  );
                                } else {
                                  CustomSnackbar.show(error, true);
                                }
                              }
                            },
                          ),
                      ],
                    ],
                  ),
                  if (p.isPhoneOtpSent) ...[
                    const SizedBox(height: 15),
                    customText(
                      title: "Enter Mobile OTP*",
                      color: colors.headingColor,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CustomTextFieldForEmailverification(
                            controller: p.phoneOtpController,
                            hint: "4-digit OTP",
                            isNumber: true,
                            maxLength: 4, // 4-digit mobile OTP
                            onChanged: (val) {
                              p.onPhoneOtpChanged(val);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Validate appears when exactly 4 digits are entered
                        if (p.phoneOtpController.text.trim().length == 4)
                          p.isPhoneOtpVerifying
                              ? const SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : CustomToggleButton(
                                  rightPaddingDissable: true,
                                  title: "Validate",
                                  onTap: () async {
                                    final success = await p.verifyPhoneOtp();
                                    if (bottomSheetContext.mounted) {
                                      if (success) {
                                        Navigator.pop(bottomSheetContext);
                                        CustomSnackbar.show(
                                          "Mobile number updated & verified!",
                                          false,
                                        );
                                      } else {
                                        CustomSnackbar.show(
                                          "Invalid OTP",
                                          true,
                                        );
                                      }
                                    }
                                  },
                                )
                        else if (p.canResendPhoneOtp)
                          p.isPhoneOtpSending
                              ? const SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : CustomToggleButton(
                                  rightPaddingDissable: true,
                                  title: "Resend",
                                  onTap: () async {
                                    final error = await p.sendPhoneOtp(
                                      SharedPrefsHelper.getString(
                                        ESharedPreferences.user_firstName,
                                      ),
                                    );
                                    if (bottomSheetContext.mounted) {
                                      if (error == null) {
                                        CustomSnackbar.show(
                                          "OTP re-sent!",
                                          false,
                                        );
                                      } else {
                                        CustomSnackbar.show(error, true);
                                      }
                                    }
                                  },
                                )
                        else
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: colors.bottomsheetbgColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: customText(
                              title: p.formattedPhoneTimer,
                              fontWeight: FontWeight.bold,
                              color: colors.headingColor,
                            ),
                          ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BusinessCompanyProvider>();
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (provider.memberRole != "OWNER") ...[
            customText(
              title: "Your Company / Agency Name*",
              color: colors.headingColor,
            ),
            CustomTextFieldForBusinessCompany(
              controller: provider.suggestionSelectedFirmController,
              hintText: "Company name",
              title: "Company / Agency Name*",
              onIdSelected: (p0) {
                provider.setCompanyId(p0);
              },
              onChanged: (p0) {},
            ),
            const SizedBox(height: 10),
          ],

          customText(title: "Designation*", color: colors.headingColor),
          CustomTextFieldforAll(
            controller: provider.designationController,
            hint: "Hr Manager",
          ),
          const SizedBox(height: 10),

          // Official Contact No Field (Prefilled, non-editable, with Change button)
          customText(
            title: "Work / Official Contact No*",
            color: colors.headingColor,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: AbsorbPointer(
                  absorbing: true,
                  child: CustomTextFieldForEmailverification(
                    isPrimaryNumber: true,
                    controller: provider.officialContactController,
                    hint: "XXXXXXXX86",
                    isNumber: true,
                    sufix: CustomToggleButton(
                      rightPaddingDissable: true,
                      title: "Change Number",
                      onTap: () {
                        _showChangeContactBottomSheet(
                          context,
                          provider,
                          colors,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          customText(
            title: "Candidate can contact you on this number",
            color: colors.subTitleColor,
            fontSize: 11,
          ),
          const SizedBox(height: 10),
          // Hide Official Email section if "I don't have company domain" is checked
          if (!provider.isNoDomainEmail) ...[
            customText(
              title: "Official E-Mail ID*",
              color: colors.headingColor,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: AbsorbPointer(
                    // Disable email editing once OTP is sent or email is verified
                    absorbing: provider.isOtpSent || provider.isEmailVerified,
                    child: Opacity(
                      opacity: (provider.isOtpSent || provider.isEmailVerified)
                          ? 0.7
                          : 1.0,
                      child: CustomTextFieldForEmailverification(
                        controller: provider.officialEmailController,
                        hint: "XXXXX@domain.com",
                        isGmail: true,
                        onChanged: (val) {
                          provider.onEmailChanged(val);
                        },
                        sufix: provider.isEmailVerified
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 24,
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
                if (provider.isOtpSent)
                  InkWell(
                    onTap: () {
                      provider.resetEmailVerificationState();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.edit,
                        color: colors.headingColor,
                        size: 20,
                      ),
                    ),
                  ),
                // Show "Verify" button only when email is not empty, OTP is not sent, and email is not verified
                if (!provider.isOtpSent &&
                    !provider.isEmailVerified &&
                    provider.officialEmailController.text
                        .trim()
                        .isNotEmpty) ...[
                  const SizedBox(width: 8),
                  if (provider.isEmailSending)
                    const SizedBox(
                      width: 32,
                      height: 32,
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  else
                    CustomToggleButton(
                      rightPaddingDissable: true,
                      title: "Verify",
                      onTap: () async {
                        final errorMessage = await provider.sendEmailOtp(
                          SharedPrefsHelper.getString(
                            ESharedPreferences.user_firstName,
                          ),
                        );
                        if (context.mounted) {
                          if (errorMessage == null) {
                            CustomSnackbar.show(
                              "OTP sent successfully to your company email!",
                              false,
                            );
                          } else {
                            CustomSnackbar.show(errorMessage, true);
                          }
                        }
                      },
                    ),
                ],
              ],
            ),

            // OTP Input Field & Conditional Action (Timer / Resend / Validate)
            if (provider.isOtpSent && !provider.isEmailVerified) ...[
              const SizedBox(height: 10),
              customText(title: "Enter Email OTP*", color: colors.headingColor),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: CustomTextFieldForEmailverification(
                      controller: provider.emailOtpController,
                      hint: "6-digit OTP",
                      isNumber: true,
                      maxLength: 6,
                      onChanged: (val) {
                        provider.onOtpChanged(val);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Case 1: Exactly 6 digits entered -> Show Validate Button
                  if (provider.emailOtpController.text.trim().length == 6)
                    provider.isEmailVerifying
                        ? const SizedBox(
                            width: 32,
                            height: 32,
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : CustomToggleButton(
                            rightPaddingDissable: true,
                            title: "Validate",
                            onTap: () async {
                              final success = await provider.verifyEmailOtp();
                              if (context.mounted) {
                                CustomSnackbar.show(
                                  success
                                      ? "Email verified successfully!"
                                      : "Invalid OTP",
                                  !success,
                                );
                              }
                            },
                          )
                  // Case 2: Less than 6 digits & Timer Expired -> Show Resend
                  else if (provider.canResend)
                    provider.isEmailSending
                        ? const SizedBox(
                            width: 32,
                            height: 32,
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : CustomToggleButton(
                            rightPaddingDissable: true,
                            title: "Resend",
                            onTap: () async {
                              final errorMessage = await provider.sendEmailOtp(
                                SharedPrefsHelper.getString(
                                  ESharedPreferences.user_firstName,
                                ),
                              );
                              if (context.mounted) {
                                if (errorMessage == null) {
                                  CustomSnackbar.show(
                                    "OTP re-sent successfully!",
                                    false,
                                  );
                                } else {
                                  CustomSnackbar.show(errorMessage, true);
                                }
                              }
                            },
                          )
                  // Case 3: Less than 6 digits & Timer Running -> Show Countdown Timer
                  else
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: colors.bottomsheetbgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: customText(
                        title: provider.formattedTimer,
                        fontWeight: FontWeight.bold,
                        color: colors.headingColor,
                      ),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 20),
          ],

          CustomCheckboxRow(
            title: "I don't have a company domain Email ID.",
            value: provider.isNoDomainEmail,
            onChanged: (value) {
              provider.toggleNoDomainEmail(value ?? false);
            },
          ),
        ],
      ),
    );
  }
}
