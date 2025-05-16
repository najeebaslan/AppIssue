class ResponseResult<F, S> {
  final F? failure;
  final S? success;
  ResponseResult({this.failure, this.success});
}

class Success<F, S> implements ResponseResult<F, S> {
  @override
  final S success;
  Success(this.success);

  @override
  F? get failure => null;
}

class Failure<F, S> implements ResponseResult<F, S> {
  @override
  final F failure;
  Failure(this.failure);

  @override
  S? get success => null;
}
