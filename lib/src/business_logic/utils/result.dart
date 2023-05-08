import '../../views/messenger.dart';

enum Status {
  LOADING,
  SUCCEED,
  ERROR,
}

class Result<T> {
  Status status;
  T? data;
  String? message;
  ErrorCode? errorCode;

  Result.loading({this.message}) : status = Status.LOADING;

  Result.success({required this.data}) : status = Status.SUCCEED;

  Result.error({this.message, this.errorCode = ErrorCode.unidentified})
      : status = Status.ERROR;

  bool isSuccessful() => status == Status.SUCCEED;

  @override
  String toString() {
    return 'ApiResponse{status: $status, data: $data, message: $message}';
  }
}