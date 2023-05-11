class RequestResult {
  String resultcode;
  String resultKey;
  String errorMessage;
  dynamic resultData;
  RequestResult(
      this.resultcode, this.resultKey, this.errorMessage, this.resultData);
}
