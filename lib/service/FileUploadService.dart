import 'package:http/http.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/service/DataService.dart';
import 'package:job_circle/service/ServiceBase.dart';

class FileUploadService extends ServiceBase {
  uploadSingleFile(String folder, List<int> data) {
    return httpSingleFile(
        GlobalConstants.API_files_v1_multiUpload +
            "?folder=" +
            folder.toString(),
        data);
  }
}
