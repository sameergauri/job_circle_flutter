class FileUploadResponse {
  String? resultKey;
  List<FileUploadData>? resultData;
  String? code;
  String? errorMessage;

  FileUploadResponse({
    this.resultKey,
    this.resultData,
    this.code,
    this.errorMessage,
  });

  factory FileUploadResponse.fromJson(Map<String, dynamic> json) {
    return FileUploadResponse(
      resultKey: json['resultKey'],
      resultData: (json['resultData'] as List<dynamic>?)
          ?.map((data) => FileUploadData.fromJson(data))
          .toList(),
      code: json['code'],
      errorMessage: json['errorMessage'],
    );
  }
}

class FileUploadData {
  int? id;
  String? fileType;
  String? fileExt;
  String? fileName;
  String? uniqueName;
  String? createdOn;

  FileUploadData({
    this.id,
    this.fileType,
    this.fileExt,
    this.fileName,
    this.uniqueName,
    this.createdOn,
  });

  factory FileUploadData.fromJson(Map<String, dynamic> json) {
    return FileUploadData(
      id: json['id'],
      fileType: json['fileType'],
      fileExt: json['fileExt'],
      fileName: json['fileName'],
      uniqueName: json['uniqueName'],
      createdOn: json['createdOn'],
    );
  }
}
