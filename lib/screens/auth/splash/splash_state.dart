import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash_state.g.dart';

@riverpod
class SplashState extends _$SplashState {
  @override
  bool build() {
    // Start with splash state active
    return true;
  }

  void completeSplash() {
    // When the splash process is complete, update the state
    state = false;
  }
}
