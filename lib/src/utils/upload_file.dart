// ignore_for_file: use_build_context_synchronously, avoid_print
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:job_circle/src/services/file_upload_service.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/utils.dart';
import 'package:path_provider/path_provider.dart';

class FileUploader {
  Future<String?> uploadFile(
    BuildContext context,
    List<String> allowExt,
    String folder,
  ) async {
    Utils.showLoaderDialog(context, "");

    // v12: returns List<PlatformFile>?
    final List<PlatformFile> files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowExt,
      withReadStream: true,
    );

    if (files.isNotEmpty) {
      try {
        final path = files.first.path;
        if (path == null) {
          NavigationService.pop();
          _showErrorDialog(context, "Could not read file path");
          return null;
        }

        final file = File(path);
        final resultD = await FileUploadService().uploadSingleFile(
          folder,
          file,
        );

        if (resultD == null) {
          NavigationService.pop();
          _showErrorDialog(context, "File size is more than 5MB");
          return null;
        } else if (resultD['resultKey'] == 'SUCCESS' &&
            resultD['resultData']?['files'] != null &&
            resultD['resultData']['files'].isNotEmpty) {
          final String? filename =
              resultD['resultData']['files'][0]["fileName"];
          NavigationService.pop();
          return filename;
        } else {
          NavigationService.pop();
          _showErrorDialog(context, "Error while uploading file");
          return null;
        }
      } catch (e) {
        print("Error during file upload: $e");
        NavigationService.pop();
        _showErrorDialog(context, "An error occurred: $e");
        return null;
      }
    } else {
      NavigationService.pop();
      return null;
    }
  }

  Future<File?> pickFileFromDevice() async {
    try {
      final List<PlatformFile> files = await FilePicker.pickFiles(
        type: FileType.any,
      );

      if (files.isNotEmpty && files.single.path != null) {
        return File(files.single.path!);
      }
      return null;
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
      final List<PlatformFile> files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExt,
        withReadStream: true,
      );

      if (files.isNotEmpty && files.single.path != null) {
        final file = File(files.single.path!);
        String? uploadedFileName;

        if (needToUpload) {
          final resultD = await FileUploadService().uploadSingleFile(
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
      }
      return null;
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
              onPressed: () => NavigationService.pop(),
              child: const Text("Ok"),
            ),
          ],
        );
      },
    );
  }

  Future<String?> uploadGeneratedPdf(
    BuildContext context,
    Uint8List pdfBytes,
  ) async {
    Utils.showLoaderDialog(context, "Uploading Resume...");

    try {
      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/Resume_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
      await file.writeAsBytes(pdfBytes);

      final resultD = await FileUploadService().uploadSingleFile(
        "resumes",
        file,
      );

      if (resultD == null) {
        NavigationService.pop();
        _showErrorDialog(context, "File size is too large or upload failed.");
        return null;
      } else if (resultD['resultKey'] == 'SUCCESS' &&
          resultD['resultData']?['files'] != null &&
          resultD['resultData']['files'].isNotEmpty) {
        final String? filename = resultD['resultData']['files'][0]["fileName"];
        NavigationService.pop();
        return filename;
      } else {
        NavigationService.pop();
        _showErrorDialog(context, "Server Error: Could not retrieve filename.");
        return null;
      }
    } catch (e) {
      NavigationService.pop();
      print("Error during PDF upload: $e");
      _showErrorDialog(context, "An error occurred: $e");
      return null;
    }
  }
}

class FileUploadResult {
  final File file;
  final String? uploadedFileName;

  FileUploadResult({required this.file, this.uploadedFileName});
}
