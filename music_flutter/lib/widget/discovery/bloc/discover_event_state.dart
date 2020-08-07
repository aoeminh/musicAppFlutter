/// events
class DiscoverEvent {}

class DiscoverGetListEvent extends DiscoverEvent {
  final int count;

  DiscoverGetListEvent(this.count);
}

/// states
class DiscoveryState {}

class DiscoveryLoadingState extends DiscoveryState {}

class DiscoveryResultState<T> extends DiscoveryState {
  final T result;

  DiscoveryResultState(this.result);
}
