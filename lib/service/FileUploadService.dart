// ignore_for_file: unused_import, avoid_print, prefer_interpolation_to_compose_strings, file_names

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/service/ServiceBase.dart';

class FileUploadService extends ServiceBase {
  uploadSingleFile(String folder, data) {
    return httpSingleFile(
        GlobalConstants.API_files_v1_multiUpload +
            "?folder=" +
            folder.toString(),
        data);
  }

  Future<void> deleteSingleFile(String filename) async {
    const String baseUrl =
        "http://${GlobalConstants.API_Host}/api/files/v1/multiUpload";
    final String encodedFileName =
        Uri.encodeComponent(filename); // Encode file name
    final Uri url = Uri.parse("$baseUrl?fileName=%22$encodedFileName%22");

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print("File deleted successfully");
      } else {
        print(
            "Failed to delete file: ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      print("Error deleting file: $e");
    }
  }
}
