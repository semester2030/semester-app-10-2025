import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'prefs.g.dart';

@riverpod
Future<SPUtils> prefs(Ref ref) async {
  final spUtils = SPUtils();
  await spUtils.init();
  return spUtils;
}

@riverpod
SPUtils persistentPrefs(Ref ref) {
  final spUtils = ref.watch(prefsProvider).requireValue;
  return spUtils;
}
