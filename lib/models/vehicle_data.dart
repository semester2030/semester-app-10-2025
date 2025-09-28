class VehicleData {
  static const Map<String, Map<String, List<String>>> vehicleDatabase = {
    'Toyota': {
      'Camry': ['2020', '2021', '2022', '2023', '2024'],
      'Corolla': ['2019', '2020', '2021', '2022', '2023', '2024'],
      'RAV4': ['2020', '2021', '2022', '2023', '2024'],
      'Highlander': ['2020', '2021', '2022', '2023', '2024'],
      'Prius': ['2019', '2020', '2021', '2022', '2023', '2024'],
      'Land Cruiser': ['2020', '2021', '2022', '2023', '2024'],
      'Hilux': ['2019', '2020', '2021', '2022', '2023', '2024'],
      'Yaris': ['2020', '2021', '2022', '2023', '2024'],
    },
    'Honda': {
      'Accord': ['2020', '2021', '2022', '2023', '2024'],
      'Civic': ['2019', '2020', '2021', '2022', '2023', '2024'],
      'CR-V': ['2020', '2021', '2022', '2023', '2024'],
      'Pilot': ['2020', '2021', '2022', '2023', '2024'],
      'Odyssey': ['2020', '2021', '2022', '2023', '2024'],
      'Passport': ['2020', '2021', '2022', '2023', '2024'],
      'HR-V': ['2020', '2021', '2022', '2023', '2024'],
    },
    'Hyundai': {
      'Elantra': ['2020', '2021', '2022', '2023', '2024'],
      'Sonata': ['2020', '2021', '2022', '2023', '2024'],
      'Tucson': ['2020', '2021', '2022', '2023', '2024'],
      'Santa Fe': ['2020', '2021', '2022', '2023', '2024'],
      'Accent': ['2020', '2021', '2022', '2023', '2024'],
      'Veloster': ['2020', '2021', '2022'],
      'Creta': ['2020', '2021', '2022', '2023', '2024'],
      'Ioniq': ['2020', '2021', '2022', '2023', '2024'],
    },
    'Kia': {
      'Optima': ['2019', '2020'],
      'K5': ['2021', '2022', '2023', '2024'],
      'Forte': ['2020', '2021', '2022', '2023', '2024'],
      'Sportage': ['2020', '2021', '2022', '2023', '2024'],
      'Sorento': ['2020', '2021', '2022', '2023', '2024'],
      'Soul': ['2020', '2021', '2022', '2023', '2024'],
      'Seltos': ['2020', '2021', '2022', '2023', '2024'],
      'Carnival': ['2022', '2023', '2024'],
    },
    'Nissan': {
      'Altima': ['2020', '2021', '2022', '2023', '2024'],
      'Sentra': ['2020', '2021', '2022', '2023', '2024'],
      'Rogue': ['2020', '2021', '2022', '2023', '2024'],
      'Murano': ['2020', '2021', '2022', '2023'],
      'Pathfinder': ['2022', '2023', '2024'],
      'Armada': ['2020', '2021', '2022', '2023', '2024'],
      'Kicks': ['2020', '2021', '2022', '2023', '2024'],
      'Maxima': ['2020', '2021', '2022', '2023'],
    },
    'Ford': {
      'F-150': ['2020', '2021', '2022', '2023', '2024'],
      'Mustang': ['2020', '2021', '2022', '2023', '2024'],
      'Explorer': ['2020', '2021', '2022', '2023', '2024'],
      'Escape': ['2020', '2021', '2022', '2023', '2024'],
      'Edge': ['2020', '2021'],
      'Bronco': ['2021', '2022', '2023', '2024'],
      'Ranger': ['2020', '2021', '2022', '2023', '2024'],
      'Expedition': ['2020', '2021', '2022', '2023', '2024'],
    },
    'Chevrolet': {
      'Malibu': ['2020', '2021', '2022', '2023'],
      'Equinox': ['2020', '2021', '2022', '2023', '2024'],
      'Traverse': ['2020', '2021', '2022', '2023', '2024'],
      'Tahoe': ['2021', '2022', '2023', '2024'],
      'Suburban': ['2021', '2022', '2023', '2024'],
      'Silverado': ['2020', '2021', '2022', '2023', '2024'],
      'Blazer': ['2020', '2021', '2022', '2023', '2024'],
      'Camaro': ['2020', '2021', '2022', '2023', '2024'],
    },
    'BMW': {
      '3 Series': ['2020', '2021', '2022', '2023', '2024'],
      '5 Series': ['2020', '2021', '2022', '2023', '2024'],
      'X3': ['2020', '2021', '2022', '2023', '2024'],
      'X5': ['2020', '2021', '2022', '2023', '2024'],
      'X1': ['2020', '2021', '2022', '2023', '2024'],
      'X7': ['2020', '2021', '2022', '2023', '2024'],
      '7 Series': ['2020', '2021', '2022', '2023', '2024'],
      'i4': ['2022', '2023', '2024'],
    },
    'Mercedes-Benz': {
      'C-Class': ['2020', '2021', '2022', '2023', '2024'],
      'E-Class': ['2020', '2021', '2022', '2023', '2024'],
      'S-Class': ['2021', '2022', '2023', '2024'],
      'GLC': ['2020', '2021', '2022', '2023', '2024'],
      'GLE': ['2020', '2021', '2022', '2023', '2024'],
      'GLS': ['2020', '2021', '2022', '2023', '2024'],
      'A-Class': ['2020', '2021', '2022'],
      'CLA': ['2020', '2021', '2022', '2023', '2024'],
    },
    'Audi': {
      'A3': ['2020', '2021', '2022', '2023', '2024'],
      'A4': ['2020', '2021', '2022', '2023', '2024'],
      'A6': ['2020', '2021', '2022', '2023', '2024'],
      'Q3': ['2020', '2021', '2022', '2023', '2024'],
      'Q5': ['2020', '2021', '2022', '2023', '2024'],
      'Q7': ['2020', '2021', '2022', '2023', '2024'],
      'Q8': ['2020', '2021', '2022', '2023', '2024'],
      'e-tron': ['2020', '2021', '2022', '2023', '2024'],
    },
    'Lexus': {
      'ES': ['2020', '2021', '2022', '2023', '2024'],
      'IS': ['2021', '2022', '2023', '2024'],
      'LS': ['2020', '2021', '2022', '2023', '2024'],
      'RX': ['2020', '2021', '2022', '2023', '2024'],
      'GX': ['2020', '2021', '2022', '2023', '2024'],
      'LX': ['2021', '2022', '2023', '2024'],
      'NX': ['2022', '2023', '2024'],
      'UX': ['2020', '2021', '2022', '2023', '2024'],
    },
  };

  // Get all available makes
  static List<String> getAllMakes() {
    return vehicleDatabase.keys.toList()..sort();
  }

  // Get models for a specific make
  static List<String> getModelsForMake(String make) {
    if (vehicleDatabase.containsKey(make)) {
      return vehicleDatabase[make]!.keys.toList()..sort();
    }
    return [];
  }

  // Get years for a specific make and model
  static List<String> getYearsForModel(String make, String model) {
    if (vehicleDatabase.containsKey(make) &&
        vehicleDatabase[make]!.containsKey(model)) {
      return vehicleDatabase[make]![model]!
          .reversed
          .toList(); // Show newest first
    }
    return [];
  }

  // Search makes by query
  static List<String> searchMakes(String query) {
    if (query.isEmpty) return getAllMakes();

    return getAllMakes()
        .where((make) => make.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Search models by query for a specific make
  static List<String> searchModels(String make, String query) {
    if (query.isEmpty) return getModelsForMake(make);

    return getModelsForMake(make)
        .where((model) => model.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Search years by query for a specific make and model
  static List<String> searchYears(String make, String model, String query) {
    if (query.isEmpty) return getYearsForModel(make, model);

    return getYearsForModel(make, model)
        .where((year) => year.contains(query))
        .toList();
  }
}
