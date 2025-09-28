import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Provider for the currently focused booking index
final focusedBookingIndexProvider = StateProvider<int>((ref) => 0);

// Provider for map controller
final rideMapControllerProvider =
    StateProvider<GoogleMapController?>((ref) => null);
