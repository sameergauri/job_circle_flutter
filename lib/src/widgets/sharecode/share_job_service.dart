// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/model/job_model/job_detail_page_model.dart';
import 'package:job_circle/src/widgets/sharecode/share_job_card_landscape.dart';
import 'package:job_circle/src/widgets/sharecode/share_job_card_square.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareJobService {
  /// Shows format picker bottom sheet, then generates + shares the chosen card.
  static Future<void> showOptions({
    required BuildContext context,
    required JobDetailPageModel job,
    required String shareUrl,
  }) async {
    final colors = context.appColors;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.bottomsheetbgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _ShareOptionsSheet(
        job: job,
        shareUrl: shareUrl,
        parentContext: context,
      ),
    );
  }

  // ── Internal helpers ────────────────────────────────────────────────────────

  static Future<Uint8List?> _captureCard(
    BuildContext context,
    Widget card,
    double width,
    double height,
  ) async {
    final repaintKey = GlobalKey();
    final completer = Completer<Uint8List?>();
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => Positioned(
        top: -(height + 200),
        left: 0,
        width: width,
        height: height,
        child: MediaQuery(
          // Lock text scale to 1.0 so font sizes are identical on every device
          // regardless of the user's system accessibility text-size setting.
          data: const MediaQueryData(textScaler: TextScaler.noScaling),
          child: Material(
            type: MaterialType.transparency,
            child: RepaintBoundary(key: repaintKey, child: card),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(entry);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 600), () async {
        try {
          final boundary =
              repaintKey.currentContext?.findRenderObject()
                  as RenderRepaintBoundary?;
          if (boundary != null) {
            final img = await boundary.toImage(pixelRatio: 1.0);
            final bd = await img.toByteData(format: ui.ImageByteFormat.png);
            completer.complete(bd?.buffer.asUint8List());
          } else {
            completer.complete(null);
          }
        } catch (_) {
          completer.complete(null);
        } finally {
          entry.remove();
        }
      });
    });

    return completer.future;
  }

  static Future<void> _shareImage(
    Uint8List bytes,
    String shareUrl,
    String jobTitle,
  ) async {
    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/job_share_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await file.writeAsBytes(bytes);
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'image/png')],
        text: 'Apply here: $shareUrl',
        subject: jobTitle,
      ),
    );
  }
}

// ── Bottom sheet widget ───────────────────────────────────────────────────────

class _ShareOptionsSheet extends StatefulWidget {
  final JobDetailPageModel job;
  final String shareUrl;
  final BuildContext parentContext;

  const _ShareOptionsSheet({
    required this.job,
    required this.shareUrl,
    required this.parentContext,
  });

  @override
  State<_ShareOptionsSheet> createState() => _ShareOptionsSheetState();
}

class _ShareOptionsSheetState extends State<_ShareOptionsSheet> {
  bool _generating = false;

  Future<void> _onSelect(String format) async {
    if (_generating) return;
    setState(() => _generating = true);

    // Close sheet first
    Navigator.of(context).pop();

    // Show loading on the parent page
    showDialog<void>(
      context: widget.parentContext,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 14),
                customText(
                  title: 'Generating image…',
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Widget card;
    double w;
    double h;

    switch (format) {
      case '1080x644':
        card = ShareJobCardLandscape(
          job: widget.job,
          shareUrl: widget.shareUrl,
        );
        w = 1080;
        h = 644;
      default:
        // 1080x1080 and 1080x2026 both use the square card
        card = ShareJobCardSquare(job: widget.job, shareUrl: widget.shareUrl);
        w = 1080;
        h = 1080;
    }

    final bytes = await ShareJobService._captureCard(
      widget.parentContext,
      card,
      w,
      h,
    );

    // Dismiss loading
    if (widget.parentContext.mounted) {
      Navigator.of(widget.parentContext).pop();
    }

    if (bytes != null && widget.parentContext.mounted) {
      await ShareJobService._shareImage(
        bytes,
        widget.shareUrl,
        widget.job.roleName ?? widget.job.jobHeadline ?? 'Job',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colors.darkBlue,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 18),
          customText(
            title: 'Share Job',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
          const SizedBox(height: 4),
          customText(
            title: 'Choose image format',
            fontSize: 12,
            color: colors.subTitleColor,
          ),
          const SizedBox(height: 20),
          _tile(
            '1080x644',
            'Landscape',
            'WhatsApp chat/group, Feed banner',
            Icons.crop_landscape_rounded,
            colors,
          ),
          const SizedBox(height: 12),
          _tile(
            '1080x1080',
            'Square',
            'Instagram Posts, Facebook Feed, LinkedIn Feed & WhatsApp Status',
            Icons.crop_square_rounded,
            colors,
          ),
          /* const SizedBox(height: 12),
          _tile(
            '1080x2026',
            'Story / Portrait',
            'WhatsApp Status, FB Stories, Insta Reels, YouTube shorts',
            Icons.crop_portrait_rounded,
            colors,
          ), */
        ],
      ),
    );
  }

  Widget _tile(
    String format,
    String title,
    String subtitle,
    IconData icon,
    AppColors? colors,
  ) {
    return InkWell(
      onTap: _generating ? null : () => _onSelect(format),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Constants.darkBlue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Constants.darkBlue, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    title: title,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: colors?.textPrimary,
                  ),
                  customText(
                    title: subtitle,
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ],
              ),
            ),
            /*  customText(
              title: format,
              fontSize: 11,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ), */
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
