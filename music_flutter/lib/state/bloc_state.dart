enum BlocErrorType { unknow, connectivity, timeout }

abstract class BlocState<T> {}

class BlocLoadingState<T> extends BlocState<T> {}

class BlocEmptyState<T> extends BlocState<T> {}

class BlocResultState<T> extends BlocState<T> {
  final T result;

  BlocResultState(this.result);
}

class BlocErrorState<T> extends BlocState<T> {
  final BlocErrorType result;

  BlocErrorState(this.result);
}
