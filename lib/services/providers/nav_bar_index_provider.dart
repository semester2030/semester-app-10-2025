import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'nav_bar_index_provider.g.dart';

@riverpod
class ActiveIndex extends _$ActiveIndex {
  @override
  int build() {
    return 0; // Default index
  }

  void setIndex(int index) {
    state = index; // Update the active index
  }
}
