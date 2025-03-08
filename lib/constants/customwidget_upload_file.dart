// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/service/FileUploadService.dart';

// Import your utils file where Utils is defined
class FileUploader {
  Future<String?> uploadFile(
      BuildContext context, List<String> allowExt, String folder) async {
    Utils.showLoaderDialog(context, "");

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowExt,
      withReadStream: true,
    );

    if (result != null && result.files.isNotEmpty) {
      try {
        var file = result.files.first;
        if (file.bytes == null && file.path == null) {
          throw Exception("File data is missing");
        }

        var res = await FileUploadService().uploadSingleFile(folder, file);
        var resultD = Utils.parseResponse(res);

        if (resultD.resultKey == 'SUCCESS' &&
            resultD.resultData?['files'] != null &&
            resultD.resultData['files'].isNotEmpty) {
          String? filename = resultD.resultData['files'][0]["fileName"];

          if (filename != null) {
            Navigator.pop(context);
          }

          // Close the loader dialog
          return filename;
        } else {
          Navigator.pop(context); // Close the loader dialog
          _showErrorDialog(context, "Error while uploading file");
          return null;
        }
      } catch (e) {
       // Navigator.pop(context); // Close the loader dialog
        print("Error during file upload: $e");
        _showErrorDialog(context, "An error occurred: $e");
        return null;
      }
    } else {
      Navigator.pop(context); // Close the loader dialog
      return null;
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Ok"),
            ),
          ],
        );
      },
    );
  }
}
/* class FileUploader {
  Future<String?> uploadFile(
      BuildContext context, List<String> allowExt, String folder) async {
    Utils.showLoaderDialog(context, "");
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowExt,
      withReadStream: true,
    );

    if (result != null && result.files.isNotEmpty) {
      try {
        var res = await FileUploadService()
            .uploadSingleFile(folder, result.files.first);
        var resultD = Utils.parseResponse(res);

        if (resultD.resultKey == 'SUCCESS') {
          // String filePath = result.files.first.path ?? '';
          String filename = resultD.resultData['files'][0]["fileName"];

          Navigator.of(context).pop();
          return filename;
        } else {
          Navigator.pop(context); // Close the loader dialog
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error while uploading file"),
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
        Navigator.pop(context); // Close the loader dialog
        print("Error during file upload: $e");
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text("An error occurred: $e"),
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
    } else {
      Navigator.pop(context); // Close the loader dialog
      return null;
    }
  }
}
 */
/* class FileUploader {
  Future<String?> uploadFile(
      BuildContext context, List<String> allowExt,String folder) async {
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
          String filename = resultD.resultData['files'][0]["fileName"];
          print(filename);
          print("Filename: $filePath");
          return filename;
        } else {
          // Close the loading dialog when there is an error
      
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
       

        // Handle any exceptions that occur during the upload
        print("Error during file upload: $e");
        return null;
      }
    } else {
      // Close the loading dialog when the user cancels file selection
    

      // Handle the case where the user cancels file selection
      return null;
    }
  }
}
 */