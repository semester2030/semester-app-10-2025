enum TransportationServiceType {
  student,
  teacher,
  employee,
  daily;

  String get displayName {
    switch (this) {
      case TransportationServiceType.student:
        return 'Student Transportation';
      case TransportationServiceType.teacher:
        return 'Teacher Transportation';
      case TransportationServiceType.employee:
        return 'Employee Transportation';
      case TransportationServiceType.daily:
        return 'Daily Transportation';
    }
  }

  String get appBarTitle {
    switch (this) {
      case TransportationServiceType.student:
        return 'Student Transport';
      case TransportationServiceType.teacher:
        return 'Teacher Transport';
      case TransportationServiceType.employee:
        return 'Employee Transport';
      case TransportationServiceType.daily:
        return 'Daily Transport';
    }
  }

  // Localized app bar title - requires context/l10n
  String getLocalizedAppBarTitle(dynamic l10n) {
    switch (this) {
      case TransportationServiceType.student:
        return l10n.studentTransport;
      case TransportationServiceType.teacher:
        return l10n.teacherTransport;
      case TransportationServiceType.employee:
        return l10n.employeeTransport;
      case TransportationServiceType.daily:
        return l10n.dailyTransport;
    }
  }

  static TransportationServiceType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'student transportation':
        return TransportationServiceType.student;
      case 'teacher transportation':
        return TransportationServiceType.teacher;
      case 'employee transportation':
        return TransportationServiceType.employee;
      case 'daily transportation':
        return TransportationServiceType.daily;
      default:
        return TransportationServiceType.student;
    }
  }
}
