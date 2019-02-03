class CustomError extends Error {
  String _message = 'Error';

  CustomError([String message]) {
    this._message = message;
  }

  @override
  String toString() {
    return this._message;
  }


}