enum BookingStatus {
  draft,
  pending,
  active,
  driverComing,
  tripStarted,
  completed,
  cancelled;

  String get value {
    switch (this) {
      case BookingStatus.draft:
        return 'draft';
      case BookingStatus.pending:
        return 'pending';
      case BookingStatus.active:
        return 'active';
      case BookingStatus.driverComing:
        return 'driver_coming';
      case BookingStatus.tripStarted:
        return 'trip_started';
      case BookingStatus.completed:
        return 'completed';
      case BookingStatus.cancelled:
        return 'cancelled';
    }
  }

  String get displayName {
    switch (this) {
      case BookingStatus.draft:
        return 'Draft';
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.active:
        return 'Active';
      case BookingStatus.driverComing:
        return 'Driver Coming';
      case BookingStatus.tripStarted:
        return 'Trip Started';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  // Localized display name - requires context/l10n
  String getLocalizedDisplayName(dynamic l10n) {
    switch (this) {
      case BookingStatus.draft:
        return l10n.draft;
      case BookingStatus.pending:
        return l10n.pending;
      case BookingStatus.active:
        return l10n.active;
      case BookingStatus.driverComing:
        return 'Driver Coming'; // Add to localization if needed
      case BookingStatus.tripStarted:
        return 'Trip Started'; // Add to localization if needed
      case BookingStatus.completed:
        return l10n.completed;
      case BookingStatus.cancelled:
        return l10n.cancelled;
    }
  }

  static BookingStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'draft':
        return BookingStatus.draft;
      case 'pending':
        return BookingStatus.pending;
      case 'active':
        return BookingStatus.active;
      case 'driver_coming':
        return BookingStatus.driverComing;
      case 'trip_started':
        return BookingStatus.tripStarted;
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
        return BookingStatus.cancelled;
      default:
        return BookingStatus.draft; // Default fallback to draft
    }
  }

  // Helper method to check if booking is active (active, driverComing or tripStarted)
  bool get isActive =>
      this == BookingStatus.active ||
      this == BookingStatus.driverComing ||
      this == BookingStatus.tripStarted;

  // Helper method to check if booking is finished (completed or cancelled)
  bool get isFinished =>
      this == BookingStatus.completed || this == BookingStatus.cancelled;

  // Helper method to check if booking can be cancelled
  bool get canBeCancelled =>
      this == BookingStatus.pending || this == BookingStatus.active;

  // Helper method to check if booking is a draft
  bool get isDraft => this == BookingStatus.draft;

  // Helper method to check if booking can be edited
  bool get canBeEdited =>
      this == BookingStatus.draft || this == BookingStatus.pending;
}
