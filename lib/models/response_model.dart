class ResponseModel {
  final bool _isSuccess;
  final String _message;
  final int? _userId;

  ResponseModel(this._isSuccess, this._message, [this._userId]);

  bool get isSuccess => _isSuccess;
  String get message => _message;
  int? get userId => _userId;
}
