import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/service/FileUploadService.dart';
import 'package:job_circle/themes/colors.dart';

class ProfileCv {
  String? cv_link;
  String? cv_upladted_date;
  String? profile_cv_file;
  String? profile_cv_link;
  ProfileCv(
      {this.cv_link,
      this.cv_upladted_date,
      this.profile_cv_file,
      this.profile_cv_link});
}

class CVWidget extends StatefulWidget {
  final ProfileCv profileCv;
  final Function(String fileName, Map<String, Object> payload) onUpload;
  const CVWidget({Key? key, required this.profileCv, required this.onUpload})
      : super(key: key);

  @override
  State<CVWidget> createState() => _CVWidgetState();
}

class _CVWidgetState extends State<CVWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 3, right: 3),
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.profileCv.cv_link != null &&
                  widget.profileCv.cv_link != "")
                Row(
                  children: [
                    Image.asset('./assets/images/cv_doc.png', height: 50),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            widget.profileCv.profile_cv_file!.length >= 25
                                ? widget.profileCv.profile_cv_file!
                                    .replaceRange(
                                        25,
                                        widget
                                            .profileCv.profile_cv_file!.length,
                                        '...')
                                : widget.profileCv.profile_cv_file.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 16)),
                        if (widget.profileCv.cv_upladted_date != null &&
                            widget.profileCv.cv_upladted_date != "")
                          Text(
                              "Last Updated On ${DateFormat('dd MMMM yyyy').format(DateTime.parse(widget.profileCv.cv_upladted_date.toString()))}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14))
                      ],
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () async {
                        var data = await uploadFile(['pdf', 'doc']);
                        var payload = {
                          "stage": "upload_cv",
                          "data": {
                            "id": await Utils.getPreferencesValue(
                                null, ESharedPreferences.user_id.name),
                            "cv_link": data['fileName']
                          }
                        };
                        widget.onUpload(data['fileName'], payload);
                        setState(() {
                          widget.profileCv.cv_link = data['fileName'];
                          widget.profileCv.profile_cv_file = data['fileName'];
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Constants.themeBgColor)),
                        child: const Text(
                          "Replace",
                          style: TextStyle(
                              color: Constants.themeBgColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              widget.profileCv.cv_link != null
                  ? const SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Image.asset('./assets/images/cv_doc.png',
                                  height: 50),
                            ],
                          ),
                        ),
                        Text(
                          "let recruiter learn more about you.",
                          style: TextStyle(
                              fontSize: 13.sp, color: Colors.grey.shade500),
                        ),
                        InkWell(
                          onTap: () async {
                            var data = await uploadFile(['pdf', 'doc']);
                            var payload = {
                              "stage": "upload_cv",
                              "data": {
                                "id": await Utils.getPreferencesValue(
                                    null, ESharedPreferences.user_id.name),
                                "cv_link": data['fileName']
                              }
                            };
                            widget.onUpload(data['fileName'], payload);
                            setState(() {
                              widget.profileCv.cv_link = data['fileName'];
                              widget.profileCv.profile_cv_file =
                                  data['fileName'];
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(color: Constants.themeBgColor)),
                            child: const Text(
                              "Upload",
                              style: TextStyle(
                                  color: Constants.themeBgColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ],
      ),
    );
  }

  uploadFile(allowExt) async {
    Utils.showLoaderDialog(context, "");
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowExt,
        withReadStream: true);

    if (result != null) {
      var res =
          await FileUploadService().uploadSingleFile("cv", result.files.single);

      var resultD = Utils.parseResponse(res);
      Navigator.pop(context);
      if (resultD.resultKey == 'SUCCESS') {
        return resultD.resultData[0];
      }
      // File file = File(result.files.single.readStream.first!);
    } else {
      Navigator.pop(context);
      return null;
      // User canceled the picker
    }
  }
}
