import 'package:music_flutter/bloc/bloc_base.dart';
import 'package:rxdart/rxdart.dart';

class PageBlock extends BlocBase {

  BehaviorSubject<int> _page = BehaviorSubject<int>.seeded(0);

  Function(int) get changePage => _page.add;

  Stream<int> get currentPage => _page.stream;

  @override
  void dispose() {
    _page.close();
  }
}
