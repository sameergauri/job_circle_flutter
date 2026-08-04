import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/provider/digi_locker/digilocker_status_provider.dart';
import 'package:job_circle/src/provider/user_profile/user_profile_provider.dart';
import 'package:job_circle/src/screen/user_profile/user_profile.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:provider/provider.dart';

class ComeBackFromDigiLocker extends StatelessWidget {
  final String status;
  final String userid;
  const ComeBackFromDigiLocker({
    super.key,
    required this.status,
    required this.userid,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: colors.appbarColor,
        elevation: 0,
        titleSpacing: 0.0,
        iconTheme: IconThemeData(color: colors.headingColor),
        title: customText(
          title: "Verification",
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: colors.headingColor,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ================= SUCCESS UI =================
            if (status == "SUCCESS")
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      customText(
                        title:
                            "Job Circle has received the data you shared from Digilocker",
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: colors.headingColor,
                      ),
                      const SizedBox(height: 28),
                      customText(
                        title: "What's next?",
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: colors.headingColor,
                      ),
                      const SizedBox(height: 14),
                      customText(
                        title:
                            "Next you'll be asked to take a live selfie. By continuing, you consent to Job Circle processing your live selfie, DigiLocker photo, and biometric data from the matching of these images, to verify your identity. Job Circle will use this information, and other data from DigiLocker (name, date of birth, unique identifier, and confirmation that your DigiLocker account is linked to an Aadhaar), to add a verification and information about it to your profile (ex: verification date). Job Circle may display the country that issued your ID on your profile.",
                        fontSize: 14,
                        color: colors.headingColor,
                      ),
                      const SizedBox(height: 18),
                      customText(
                        title:
                            "We'll promptly delete the data from DigiLocker and your live selfie and biometric information promptly after verification, but will retain limited DigiLocker data (name and unique identifier) for security purposes. Job Circle manages your data in accordance with our Privacy Policy.",
                        fontSize: 14,
                        color: colors.headingColor,
                      ),
                      const SizedBox(height: 18),
                      GestureDetector(
                        onTap: () {
                          // TODO: Open article / help page
                        },
                        child: Text.rich(
                          TextSpan(
                            text:
                                "Learn more about how to exercise your rights related to this data by ",
                            style: GoogleFonts.merriweather(
                              fontSize: 14,
                              color: colors.headingColor,
                              height: 1.5,
                            ),
                            children: [
                              TextSpan(
                                text: "visiting this article.",
                                style: GoogleFonts.merriweather(
                                  color: colors.headingColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),

            // ================= FAILED UI (Image wala) =================
            if (status != "SUCCESS")
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      const Spacer(flex: 2),

                      // Warning Icon
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3E0),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFFFB74D),
                            width: 2.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.priority_high_rounded,
                          color: Color(0xFFFFA000),
                          size: 36,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Title
                      customText(
                        title: "ID verification wasn't added to your profile",
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: colors.headingColor,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 16),

                      // Description
                      customText(
                        title:
                            "You can still use your Job Circle account as you normally would.\nIf you change your mind, you can restart the verification process.",
                        fontSize: 15,
                        color: colors.headingColor,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      // Learn more
                      /*   GestureDetector(
                        onTap: () {
                          // TODO: Learn more
                        },
                        child: customText(
                          title: "Learn more",
                          fontSize: 15,
                          color: const Color(0xFF0A66C2),
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.center,
                        ),
                      ), */
                      const Spacer(flex: 3),
                    ],
                  ),
                ),
              ),

            // ================= Bottom Buttons =================
            if (status == "SUCCESS")
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      verifyAndNavigate(context);
                      // TODO: Continue to selfie
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.darkBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const customText(
                      title: "Continue to verify",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            if (status != "SUCCESS")
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                child: Column(
                  children: [
                    // Restart verification
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          NavigationService.push(const UserProfile());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A66C2),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const customText(
                          title: "Restart verification",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Close
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () {
                          NavigationService.pop();
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: colors.headingColor!,
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: customText(
                          title: "Close",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colors.headingColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> verifyAndNavigate(BuildContext context) async {
    final colors = context.appColors;
    final digilockerProvider = context.read<DigilockerProvider>();
    final userProvider = context
        .read<ProfileProvider>(); // apna provider name daalo

    // Loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 1. DigiLocker data fetch
      await digilockerProvider.fetchDigilockerStatus();

      // 2. User Profile fetch
      await userProvider.fetchProfile(); // apna function name

      // Loading band karo
      if (context.mounted) Navigator.pop(context);

      // 3. Local data
      final localName =
          "${userProvider.profile!.firstName} "
          "${userProvider.profile!.middleName} "
          "${userProvider.profile!.lastName}";
      final localDob = userProvider.profile!.dob; // "18081997"
      final localGender = userProvider.profile!.gender ?? ''; // "M" / "F"

      // 4. Compare
      final isVerified = digilockerProvider.verifyWithLocalData(
        localName: localName,
        localDob: localDob!,
        localGender: localGender,
      );

      if (!context.mounted) return;

      // 5. Result Dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return PopScope(
            canPop: false,
            child: Dialog(
              backgroundColor: colors.bottomsheetbgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: isVerified
                            ? Constants.borderColor
                            : const Color(0xFFFFEBEE),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isVerified
                            ? Icons.verified_rounded
                            : Icons.cancel_rounded,
                        color: isVerified
                            ? colors.darkBlue
                            : const Color(0xFFD32F2F),
                        size: 44,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      isVerified
                          ? "Verified Successfully"
                          : "Verification Failed",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isVerified
                            ? colors.darkBlue
                            : const Color(0xFFD32F2F),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isVerified
                          ? "Your details matched with DigiLocker.\nYou are now verified."
                          : "Your details did not match with DigiLocker.\nPlease verify again later.",
                      style: TextStyle(
                        fontSize: 14,
                        color: colors.subTitleColor,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (isVerified) {
                            final success = await digilockerProvider
                                .updateVerifiedStatus(
                                  isVerified: true, // ya false
                                );
                            if (success) {
                              await userProvider.fetchProfile();
                              NavigationService.pop(); // Close dialog
                              NavigationService.pop();
                            }else{
                              NavigationService.pop(); // Close dialog
                              NavigationService.pop();
                              CustomSnackbar.show("Failed to update verification status. Please try again.", false);
                            }
                          } else {
                            await digilockerProvider.deleteDigilockerData();
                            await userProvider.fetchProfile();
                            NavigationService.pop(); // Close dialog
                            NavigationService.pop(); // Go back to previous screen
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isVerified
                              ? colors.darkBlue
                              : colors.darkBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "OK",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      if (context.mounted) Navigator.pop(context); // loading band

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error"),
            content: Text("Something went wrong: $e"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    }
  }
}
