// Create a provider for easy access to SharedPreferenceService instance
import 'package:semester_student_ride_app/services/shared_preference_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shared_pref.g.dart';

@Riverpod(keepAlive: true)
SharedPreferenceService sharedPreferenceService(
    SharedPreferenceServiceRef ref) {
  throw UnimplementedError(
      'SharedPreferenceService must be initialized before use');
}
