import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:semester_student_ride_app/services/cloud_functions_service.dart';

final cloudFunctionsServiceProvider = Provider<CloudFunctionsService>((ref) {
  return CloudFunctionsService();
});
