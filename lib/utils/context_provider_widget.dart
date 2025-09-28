import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:semester_student_ride_app/services/providers/notification_provider.dart';

/// A widget that provides the current BuildContext to the app
/// Place this widget high in the widget tree, but after the MaterialApp
class ContextProviderWidget extends ConsumerWidget {
  final Widget child;

  const ContextProviderWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Update the context provider whenever this widget rebuilds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentContextProvider.notifier).state = context;
    });

    return child;
  }
}
