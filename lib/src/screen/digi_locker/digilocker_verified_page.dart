import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/provider/digi_locker/digilocker_status_provider.dart';
import 'package:job_circle/src/provider/user_profile/user_profile_provider.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:provider/provider.dart';

class DigiLockerVerifiedPage extends StatefulWidget {
  const DigiLockerVerifiedPage({super.key});

  @override
  State<DigiLockerVerifiedPage> createState() => _DigiLockerVerifiedPageState();
}

class _DigiLockerVerifiedPageState extends State<DigiLockerVerifiedPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DigilockerProvider>().fetchDigilockerStatus();
    });
  }

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
          title: 'Verifications',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: colors.headingColor,
        ),
        /*  actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: colors.headingColor),
            onPressed: () {},
          ),
        ], */
      ),
      body: Consumer<DigilockerProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Constants.darkBlue),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    customText(
                      title: provider.error!,
                      color: colors.subTitleColor,
                      fontSize: 14,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => provider.fetchDigilockerStatus(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.darkBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const customText(title: 'Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final data = provider.statusData?.resultData;

          String formatVerifiedDate(String value) {
            if (value.isEmpty) return '—';
            try {
              final date = DateTime.parse(value);
              const monthNames = [
                'Jan',
                'Feb',
                'Mar',
                'Apr',
                'May',
                'Jun',
                'Jul',
                'Aug',
                'Sep',
                'Oct',
                'Nov',
                'Dec',
              ];
              final day = date.day.toString().padLeft(2, '0');
              return '$day ${monthNames[date.month - 1]} ${date.year}';
            } catch (_) {
              return value;
            }
          }

          if (data == null) {
            return Center(
              child: customText(
                title: 'No verification data found.',
                color: colors.subTitleColor,
                fontSize: 15,
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  title:
                      'These are your verifications. You can delete them at any time. ',
                  color: colors.headingColor,
                  fontSize: 12,
                ),
                // ── Top description ────────────────────────────────────
                const SizedBox(height: 16),

                // ── Verification Card ──────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.bottomsheetbgColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: (colors.subTitleColor ?? Colors.grey).withValues(
                        alpha: 0.3,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customText(
                            title: 'Identity',

                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: colors.headingColor,
                          ),
                          const SizedBox(height: 8),
                          customText(
                            title: 'Verified by DigiLocker',
                            fontSize: 12,
                            color: colors.headingColor,
                          ),
                          const SizedBox(height: 2),
                          customText(
                            title: 'Government ID: IND Government ID',
                            fontSize: 12,
                            color: colors.headingColor,
                          ),
                          const SizedBox(height: 2),
                          customText(
                            title:
                                'Verification Date: ${formatVerifiedDate(data.verifiedAt)}',
                            fontSize: 12,
                            color: colors.headingColor,
                          ),
                          const SizedBox(height: 14),
                          OutlinedButton(
                            onPressed: () => _confirmDelete(context, provider),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 8,
                              ),
                              side: BorderSide(
                                color: (colors.subTitleColor ?? Colors.grey)
                                    .withValues(alpha: 0.6),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: customText(
                              title: 'Delete',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: colors.headingColor,
                            ),
                          ),
                        ],
                      ),
                      Image.asset(CustomAssetUrl.verifyIcon, height: 60),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    DigilockerProvider provider,
  ) async {
    final colors = context.appColors;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: colors.bottomsheetbgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFEBEE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_forever_rounded,
                  color: Color(0xFFD32F2F),
                  size: 34,
                ),
              ),
              const SizedBox(height: 16),
              customText(
                title: 'Delete Verification?',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.center,
                color: colors.headingColor,
              ),
              const SizedBox(height: 8),
              customText(
                title:
                    'This will permanently remove your DigiLocker verification data. You will need to verify again.',
                fontSize: 13,
                color: colors.subTitleColor,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => NavigationService.pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        side: BorderSide(color: colors.darkBlue!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: customText(
                        title: 'Cancel',
                        color: colors.darkBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        NavigationService.pop();
                        final digilockerProvider = context
                            .read<DigilockerProvider>();
                        final userData = context.read<ProfileProvider>();
                        digilockerProvider.deleteDigilockerData();
                        final success = await digilockerProvider
                            .updateVerifiedStatus(
                              isVerified: false, // ya false
                            );
                        if (success) {
                          userData.fetchProfile();
                          NavigationService.pop();
                        } else {
                          CustomSnackbar.show(
                            "Please try after some time",
                            true,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD32F2F),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const customText(
                        title: 'Delete',
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true && mounted) {
      final success = await provider.deleteDigilockerData();
      if (!mounted) return;
      if (success) {
        navigator.pop();
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Verification data deleted successfully.'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Failed to delete. Please try again.'),
            backgroundColor: Color(0xFFD32F2F),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
