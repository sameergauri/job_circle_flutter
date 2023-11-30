
import 'package:file_picker/file_picker.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/service/ServiceBase.dart';
import 'package:http/http.dart' as http;

class FileUploadService extends ServiceBase {
  uploadSingleFile(String folder, data) {
    return httpSingleFile(
        GlobalConstants.API_files_v1_multiUpload +
            "?folder=" +
            folder.toString(),
        data);
  }

  Future<void> deleteSingleFile(String filename) async {
    try {
      final response = await http.delete(
        Uri.parse(
            "http://${GlobalConstants.API_Host}/files/v1/delete?fileName=$filename"), // Provide the API endpoint URL for deleting the image
        headers: {
          // Add any required headers (e.g., authorization headers) here
          'Authorization': 'Bearer YourAccessToken',
        },
      );

      if (response.statusCode == 200) {
        // Image deletion successful
        print('Image deleted successfully');
      } else {
        // Image deletion failed
        print('Failed to delete image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any network or API-related errors here
      print('Error deleting image: $e');
    }
  }
}
