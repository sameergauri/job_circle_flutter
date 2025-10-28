// ignore_for_file: unused_import, avoid_print, prefer_interpolation_to_compose_strings, file_names, depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:job_circle/global.dart';

class FileUploadService {
  Future<Map<String, dynamic>?> uploadSingleFile(
    String folder,
    File file,
  ) async {
     String baseUrl = GlobalConstants.fileuploadurl;
    final Uri url = Uri.parse("$baseUrl?folder=$folder");

    try {
      var request = http.MultipartRequest('POST', url);

      request.files.add(
        await http.MultipartFile.fromPath(
          'files', // API field name
          file.path,
        ),
      );

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print("✅ File uploaded successfully!");
        return jsonDecode(responseBody);
      } else {
        print("❌ Failed to upload file: ${response.statusCode}, $responseBody");
        return null;
      }
    } catch (e) {
      print("⚠️ Error uploading file: $e");
      return null;
    }
  }

  Future<void> deleteSingleFile(String filename) async {
     String baseUrl = GlobalConstants.fileuploadurl;
    final String encodedFileName = Uri.encodeComponent(
      filename,
    ); // Encode file name
    final Uri url = Uri.parse("$baseUrl?fileName=%22$encodedFileName%22");

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print("File deleted successfully");
      } else {
        print(
          "Failed to delete file: ${response.statusCode}, ${response.body}",
        );
      }
    } catch (e) {
      print("Error deleting file: $e");
    }
  }
}
