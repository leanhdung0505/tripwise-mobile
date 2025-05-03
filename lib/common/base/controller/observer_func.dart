class ObserverFunc<T> {
  ObserverFunc({
    required Function onSubscribe,
    required Function(T) onSuccess,
    required Function onError,
    Function? onCompleted,
  }) {
    _onSubscribe = onSubscribe;
    _onSuccess = onSuccess;
    _onError = onError;
    _onCompleted = onCompleted;
  }

  late Function _onSubscribe;
  late Function _onSuccess;
  late Function _onError;
  Function? _onCompleted;

  dynamic onSubscribe() => _onSubscribe.call();

  dynamic onSuccess(T) => _onSuccess.call(T);

  dynamic onError(e) => _onError.call(e);

  dynamic onCompleted() => _onCompleted?.call();
}
