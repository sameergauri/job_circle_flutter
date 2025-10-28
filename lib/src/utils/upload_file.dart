// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:job_circle/src/services/file_upload_service.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/utils.dart';

// Import your utils file where Utils is defined
class FileUploader {
  Future<String?> uploadFile(
    BuildContext context,
    List<String> allowExt,
    String folder,
  ) async {
    Utils.showLoaderDialog(context, "");

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowExt,
      withReadStream: true,
    );

    if (result != null && result.files.isNotEmpty) {
      try {
        File file = File(result.files.first.path!);

        var resultD = await FileUploadService().uploadSingleFile(folder, file);
        if (resultD == null) {
          _showErrorDialog(context, "File size is more than 5MB");
        } else if (resultD['resultKey'] == 'SUCCESS' &&
            resultD['resultData']?['files'] != null &&
            resultD['resultData']['files'].isNotEmpty) {
          String? filename = resultD['resultData']['files'][0]["fileName"];

          NavigationService.pop();

          // Close the loader dialog
          return filename;
        } else {
          NavigationService.pop(); // Close the loader dialog
          _showErrorDialog(context, "Error while uploading file");
          return null;
        }
      } catch (e) {
        //  NavigationService.pop(); // Close the loader dialog
        print("Error during file upload: $e");
        _showErrorDialog(context, "An error occurred: $e");
        return null;
      }
    } else {
      NavigationService.pop(); // Close the loader dialog
      return null;
    }
    return null;
  }

  Future<File?> pickFileFromDevice() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any, // or FileType.custom with allowedExtensions
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      } else {
        // User canceled the picker
        return null;
      }
    } catch (e) {
      print("Error picking file: $e");
      return null;
    }
  }

  Future<FileUploadResult?> pickFileAndUpload(
    BuildContext context, {
    required bool needToUpload,
    List<String> allowedExt = const ['pdf'],
    String folder = 'resume',
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExt,
        withReadStream: true,
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);
        String? uploadedFileName;

        if (needToUpload) {
          var resultD = await FileUploadService().uploadSingleFile(
            folder,
            file,
          );

          if (resultD != null &&
              resultD['resultKey'] == 'SUCCESS' &&
              resultD['resultData']?['files'] != null &&
              resultD['resultData']['files'].isNotEmpty) {
            uploadedFileName = resultD['resultData']['files'][0]["fileName"];
          }
        }

        return FileUploadResult(file: file, uploadedFileName: uploadedFileName);
      } else {
        return null; // user cancelled
      }
    } catch (e) {
      print("Error picking file: $e");
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
              onPressed: () =>  NavigationService.pop(),
              child: const Text("Ok"),
            ),
          ],
        );
      },
    );
  }
}

class FileUploadResult {
  final File file;
  final String? uploadedFileName;

  FileUploadResult({required this.file, this.uploadedFileName});
}
