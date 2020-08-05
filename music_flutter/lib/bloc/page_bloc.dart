import 'package:music_flutter/bloc/bloc_base.dart';
import 'package:rxdart/rxdart.dart';

class PageBlock extends BlocBase {
  BehaviorSubject<int> page = BehaviorSubject.seeded(0);

  Function(int) get changePage => page.add;

  Stream<int> get currentPage => page.stream;

  @override
  void dispose() {
    page.close();
  }
}
