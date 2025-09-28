import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompanyData {
  final List<Map<String, dynamic>> drivers;
  final List<Map<String, dynamic>> vehicles;
  const CompanyData({this.drivers = const [], this.vehicles = const []});

  CompanyData copyWith({List<Map<String, dynamic>>? drivers, List<Map<String, dynamic>>? vehicles}) {
    return CompanyData(
      drivers: drivers ?? this.drivers,
      vehicles: vehicles ?? this.vehicles,
    );
  }
}

class CompanyDataNotifier extends StateNotifier<CompanyData> {
  CompanyDataNotifier() : super(const CompanyData());

  void seedDrivers(List<Map<String, dynamic>> items) {
    if (state.drivers.isEmpty) {
      state = state.copyWith(drivers: List<Map<String, dynamic>>.from(items));
    }
  }

  void seedVehicles(List<Map<String, dynamic>> items) {
    if (state.vehicles.isEmpty) {
      state = state.copyWith(vehicles: List<Map<String, dynamic>>.from(items));
    }
  }

  void addDriver(Map<String, dynamic> driver) {
    final updated = List<Map<String, dynamic>>.from(state.drivers)..add(driver);
    state = state.copyWith(drivers: updated);
  }

  void addVehicle(Map<String, dynamic> vehicle) {
    final updated = List<Map<String, dynamic>>.from(state.vehicles)..add(vehicle);
    state = state.copyWith(vehicles: updated);
  }
}

final companyDataNotifierProvider = StateNotifierProvider<CompanyDataNotifier, CompanyData>((ref) {
  return CompanyDataNotifier();
});

final totalVehiclesProvider = Provider<int>((ref) {
  return ref.watch(companyDataNotifierProvider).vehicles.length;
});

final activeDriversCountProvider = Provider<int>((ref) {
  final drivers = ref.watch(companyDataNotifierProvider).drivers;
  return drivers.where((d) => d['status'] == 'online' || d['status'] == 'busy').length;
});


