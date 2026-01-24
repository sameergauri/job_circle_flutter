// ignore_for_file: non_constant_identifier_names, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/widgets/button/custom_call_sms_new_button.dart'
    show CustomcallsmsButton;
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/pdf_doc_view/docs_webview.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomPDFViewerDialog extends StatelessWidget {
  final String pdfUrl;
  final bool isFromAts;
  final Function? onDelete;
  final String? contact_no, alternate_no;
  final String title;
  final bool? enableDelete;

  CustomPDFViewerDialog({
    super.key,
    required this.pdfUrl,
    required this.isFromAts,
    this.onDelete,
    this.contact_no,
    this.alternate_no,
    this.title = "Resume Viewer",
    this.enableDelete = true,
  });
  bool _isPdfFile() {
    final lowerUrl = pdfUrl.toLowerCase();
    return lowerUrl.contains('.pdf');
  }

  bool _isDocxFile() {
    final lowerUrl = pdfUrl.toLowerCase();
    return lowerUrl.contains('.docx') || lowerUrl.contains('.doc');
  }

  // final GlobalKey<SfPdfViewerState> _pdfViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.white,
      floatingActionButton: enableDelete != null && enableDelete == true
          ? _buildFloatingActionButton()
          : null,
      appBar: AppBar(
        title: customText(
          title: title,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: _buildViewer(),
    );
  }

  //
  Widget _buildViewer() {
    if (_isPdfFile()) {
      return PdfViewerScreen(pdfUrl: pdfUrl);
    } else if (_isDocxFile()) {
      return DocxViewerWidget(docxUrl: pdfUrl);
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.file_present, size: 60, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Unsupported file format',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              'Only PDF and DOCX files are supported',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }
  }
  //

  Widget? _buildFloatingActionButton() {
    if (isFromAts && contact_no != null) {
      return FabWithMenu(contact_no: contact_no, alternateno: alternate_no);
    } else if (isFromAts && contact_no == null) {
      return const SizedBox.shrink();
    } else {
      return FloatingActionButton(
        heroTag: 'btn6',
        onPressed: () {
          onDelete?.call();
          NavigationService.pop();
        },
        backgroundColor: Constants.borderColor,
        child: Image.network(
          CustomIconUrl.deleteicon,
          height: 30,
          color: Colors.red,
        ),
      );
    }
  }
}

class FabWithMenu extends StatefulWidget {
  final String? contact_no, alternateno;
  const FabWithMenu({this.contact_no, this.alternateno, super.key});

  @override
  State<FabWithMenu> createState() => _FabWithMenuState();
}

class _FabWithMenuState extends State<FabWithMenu> {
  bool isMenue = false;
  @override
  Widget build(BuildContext context) {
    return isMenue
        ? const SizedBox()
        : CustomcallsmsButton(
            buttonColor: Constants.darkBlue,
            isCircle: true,
            height: 40.0,
            width: 40.0,
            iconColor: Constants.white,
            imageUrl: CustomIconUrl.callmessageicon,
            label: "Call",
            onTap: () async {
              setState(() {
                isMenue = true;
              });
              final RenderBox button = context.findRenderObject() as RenderBox;
              final RenderBox overlay =
                  Overlay.of(context).context.findRenderObject() as RenderBox;

              final RelativeRect position = RelativeRect.fromRect(
                Rect.fromPoints(
                  button.localToGlobal(Offset.zero, ancestor: overlay),
                  button.localToGlobal(
                    button.size.bottomRight(Offset.zero),
                    ancestor: overlay,
                  ),
                ),
                Offset.zero & overlay.size,
              );
              await showMenu(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.45,
                ),
                color: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                context: context,
                position: position,
                shadowColor: Colors.transparent,
                items: [
                  customButton(
                    CustomIconUrl.callicon,
                    () {
                      FlutterPhoneDirectCaller.callNumber(
                        widget.contact_no.toString(),
                      );
                    },
                    Constants.darkBlue,
                    widget.contact_no.toString(),
                  ),
                  customButton(
                    CustomIconUrl.whatsappicon,
                    () async {
                      int phone = int.tryParse(widget.contact_no.toString())!;
                      var whatsappUrl = "whatsapp://send?phone=91$phone";
                      await launchUrl(Uri.parse(whatsappUrl));
                    },
                    Constants.darkgreen,
                    widget.contact_no.toString(),
                  ),
                  if (widget.alternateno != null)
                    customButton(
                      CustomIconUrl.callicon,
                      () {
                        FlutterPhoneDirectCaller.callNumber(
                          widget.alternateno.toString(),
                        );
                      },
                      Constants.darkBlue,
                      widget.alternateno.toString(),
                    ),
                  if (widget.alternateno != null)
                    customButton(
                      CustomIconUrl.whatsappicon,
                      () async {
                        int phone = int.tryParse(
                          widget.alternateno.toString(),
                        )!;
                        var whatsappUrl = "whatsapp://send?phone=91$phone";
                        await launchUrl(Uri.parse(whatsappUrl));
                      },
                      Constants.darkgreen,
                      widget.alternateno.toString(),
                    ),
                ],
              );
              setState(() {
                isMenue = false;
              });
            },
          );
  }

  String maskPhoneNumber(String phone) {
    if (phone.length <= 3) return phone;

    // Extract country code if present
    final countryCodeMatch = RegExp(r'^(\+\d+\s?)').firstMatch(phone);
    String countryCode = '+91';
    String number = phone;

    if (countryCodeMatch != null) {
      countryCode = countryCodeMatch.group(0)!;
      number = phone.substring(countryCode.length);
    }

    // Mask all digits except last 3
    String masked = number.replaceAll(RegExp(r'\d'), '*');
    String lastThree = number.substring(number.length - 3);

    // Reconstruct the masked number
    return countryCode + masked.substring(0, masked.length - 3) + lastThree;
  }

  PopupMenuItem<dynamic> customButton(
    String icon,
    Function() onTab,
    Color color,
    String contactno,
  ) {
    return PopupMenuItem(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      onTap: () {
        onTab();
      }, // default padding hatao
      child: IntrinsicWidth(
        // jitni width content ko chahiye utni hi lega
        child: Row(
          mainAxisSize: MainAxisSize.min, // content ke hisaab se shrink hoga
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
              decoration: BoxDecoration(
                color: Constants.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: customText(
                monst: false,
                title: maskPhoneNumber(contactno),
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 6),
            CircleAvatar(
              backgroundColor: color,
              child: CustomNetworkImage(
                color: Constants.white,
                imageUrl: icon,
                defaultIcon: Icons.call,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
