import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/profileSummary.dart';
import 'package:job_circle/screens/home.dart';
import 'package:job_circle/service/FileUploadService.dart';
import 'package:job_circle/service/UserDataService.dart';
import 'package:job_circle/themes/colors.dart';

class AddCv extends StatefulWidget {
  /*  final Map<String, dynamic> params;
  final int userID; */
  // const AddCv({super.key, required this.params, required this.userID});
  const AddCv({super.key});

  @override
  State<AddCv> createState() => _AddCvState();
}

class _AddCvState extends State<AddCv> {
  late ProfileSummaryModel profilemodel = ProfileSummaryModel();
  String? resume;

  @override
  Widget build(BuildContext context) {
    return resume != null
        ? Scaffold(
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () async {
                    resume = await Delete(true);
                    var payload = {
                      "stage": "upload_cv",
                      "data": {
                        "id": await Utils.getPreferencesValue(
                            null, ESharedPreferences.user_id.name),
                        "cv_link": null
                      }
                    };
                    save(null, payload);
                    // Navigator.pop(context);
                    setState(() {});

                    /*  setState(() {
                                    resume = Delete(true).toString();
                                  }); */
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.r),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Constants.themeBgColor)),
                    child: Row(
                      children: [
                        Icon(
                          Icons.cancel_outlined,
                          size: 15.h,
                          color: Constants.themeBgColor,
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        const Text("Remove"),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    resume = await uploadFile(['pdf'], "cv");
                    var payload = {
                      "stage": "upload_cv",
                      "data": {
                        "id": await Utils.getPreferencesValue(
                            null, ESharedPreferences.user_id.name),
                        "cv_link": resume
                      }
                    };
                    save(resume, payload);
                    // Navigator.pop(context);
                    setState(() {});
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 20.w),
                    padding:
                        EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.r),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Constants.themeBgColor)),
                    child: Row(
                      children: [
                        Icon(
                          Icons.upload_file,
                          size: 15.h,
                          color: Constants.themeBgColor,
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        const Text("Replace"),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                    /* resume = await uploadFile(['pdf'], "cv");
                    var payload = {
                      "stage": "upload_cv",
                      "data": {
                        "id": await Utils.getPreferencesValue(
                            null, ESharedPreferences.user_id.name),
                        "cv_link": resume
                      }
                    };
                    save(resume, payload);
                    Navigator.pop(context);
                    setState(() {}); */
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 20.w),
                    padding:
                        EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.r),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Constants.themeBgColor)),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 15.h,
                          color: Constants.themeBgColor,
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        const Text("Submit"),
                      ],
                    ),
                  ),
                )
              ],
            ),
            body: Container(
              child: FutureBuilder<PDFDocument>(
                future: PDFDocument.fromURL(
                    "https://s3.ap-south-1.amazonaws.com/job-circle-2/$resume"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return PDFViewer(
                        scrollDirection: Axis.vertical,
                        panLimit: 1.1,
                        document: snapshot.data!,
                        zoomSteps: 3,
                        showNavigation: false,
                        showPicker: false,

                        // numberPickerConfirmWidget: f,
                      );
                    } else {
                      return const Center(child: Text('Failed to load PDF'));
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Text(
                          "Skip",
                          style:
                              GoogleFonts.varela(color: Constants.themeBgColor),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Constants.themeBgColor,
              child: const Icon(Icons.add),
              onPressed: () async {
                resume = await uploadFile(['pdf'], "cv");
                var payload = {
                  "stage": "upload_cv",
                  "data": {
                    "id": await Utils.getPreferencesValue(
                        null, ESharedPreferences.user_id.name),
                    "cv_link": resume
                  }
                };
                save(resume, payload);
                setState(() {});
              },
            ),
            body: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade400,
                        //  blurRadius: 10,
                        blurRadius: 15.0,
                        offset: const Offset(1, 1))
                  ],
                ),
                child: Image.network(
                    "https://cdn-icons-png.flaticon.com/128/9836/9836378.png"),
              ),
            ),
          );
  }

  Future<String?> Delete(bool iscv) async {
    try {
      var res = await FileUploadService().deleteSingleFile(iscv
          ? profilemodel.cv_link.toString()
          : profilemodel.profile_pic.toString());
    } catch (e) {
      // Close the loading dialog in case of exceptions
      Navigator.pop(context);

      // Handle any exceptions that occur during the upload
      print("Error during file upload: $e");
      return null;
    }
    return null;
  }

  Future<String?> uploadFile(allowExt, String folder) async {
    Utils.showLoaderDialog(context, "");
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowExt,
      withReadStream: true,
    );

    if (result != null) {
      try {
        var res = await FileUploadService()
            .uploadSingleFile(folder, result.files.single);
        var resultD = Utils.parseResponse(res);

        if (resultD.resultKey == 'SUCCESS') {
          String filePath = result.files.single.path ?? '';
          String filename = resultD.resultData[0]["fileName"];
          print(filename);
          print("Filename: $filePath");

          // Close the loading dialog when the upload is successful
          Navigator.pop(context);
          //save(filename, data);

          return filename;
        } else {
          // Close the loading dialog when there is an error
          Navigator.pop(context);

          // Handle the case where the server returns an error
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error while uploading cv"),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Ok"),
                  ),
                ],
              );
            },
          );
          return null;
        }
      } catch (e) {
        // Close the loading dialog in case of exceptions
        Navigator.pop(context);

        // Handle any exceptions that occur during the upload
        print("Error during file upload: $e");
        return null;
      }
    } else {
      // Close the loading dialog when the user cancels file selection
      Navigator.pop(context);

      // Handle the case where the user cancels file selection
      return profilemodel.profile_pic;
    }
  }

  save(filePath, data) async {
    var result = await UserDataService().saveUserStages(data);
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      if (data['stage'] == 'upload_cv') {
        profilemodel.cv_link = filePath;

        profilemodel.cv_upladted_date =
            DateFormat('MMM dd, yyyy').format(DateTime.now());
      } else if (data['stage'] == 'partnerRequest') {
        profilemodel.partner_request = data['data']['partner_request'];
      }
    }
    setState(() {});
  }
}
