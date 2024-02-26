// ignore_for_file: non_constant_identifier_names, unused_local_variable, avoid_print

import 'package:flutter/material.dart';
import 'package:job_circle/service/FileUploadService.dart';

class ApplicationDeletApi {
  Future<String?> DeleteDocument(String File, BuildContext context) async {
    try {
      var res = await FileUploadService().deleteSingleFile(File);
    } catch (e) {
      // Close the loading dialog in case of exceptions

      // Handle any exceptions that occur during the upload
      print("Error during file upload: $e");
      return null;
    }
    return null;
  }
}
