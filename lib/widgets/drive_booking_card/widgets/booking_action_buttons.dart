import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/models/user_signup_model.dart';
import 'package:semester_student_ride_app/enums/booking_status.dart';
import 'package:semester_student_ride_app/providers/driver_booking_card_provider.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';

class BookingActionButtons extends ConsumerWidget {
  final RequestBookingModel booking;
  final UserSignupModel? userProfile;
  final AppLocalizations l10n;

  const BookingActionButtons({
    super.key,
    required this.booking,
    required this.userProfile,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BookingStatus status = booking.status ?? BookingStatus.draft;
    // Watch the provider state to keep it alive during operations
    final cardState = ref.watch(driverBookingCardProvider);
    final cardNotifier = ref.read(driverBookingCardProvider.notifier);

    // Build buttons based on booking status
    List<Widget> actionButtons = [];

    switch (status) {
      case BookingStatus.draft:
        // Draft bookings are not usually shown to drivers
        break;

      case BookingStatus.pending:
        actionButtons = [
          NormalCustomButton(
            width: 165,
            height: 40,
            titleStyle: montserrat(12, whiteColor, FontWeight.w500),
            label: cardState.isProcessingAction
                ? 'Processing...'
                : l10n.acceptBooking,
            syncCallback: cardState.isProcessingAction
                ? null
                : () async {
                    log('DEBUG: Accept booking button clicked - Button works!');
                    try {
                      final result = await cardNotifier.handleAcceptBooking(
                          context, booking, l10n, userProfile);
                      log('DEBUG: Accept booking result: $result');
                    } catch (e) {
                      log('DEBUG: Error in accept booking: $e');
                    }
                  },
          ),
          NormalCustomButton(
            label: cardState.isProcessingAction
                ? 'Processing...'
                : l10n.declineBooking,
            width: 165,
            height: 40,
            buttonColor: containerbackground,
            titleStyle: montserrat(12, grey56, FontWeight.w500),
            syncCallback: cardState.isProcessingAction
                ? null
                : () async {
                    await cardNotifier.handleDeclineBooking(
                        context, booking, l10n, userProfile);
                  },
          ),
        ];
        break;

      case BookingStatus.active:
        // Active status: Show "I'm Coming", "Chat with User", "Close Booking"
        actionButtons = [
          _buildActiveStatusButtons(
              context, ref, l10n, userProfile, cardNotifier, cardState),
        ];
        break;

      case BookingStatus.driverComing:
        // Driver coming status: Check proximity and show appropriate buttons
        actionButtons = [
          _buildDriverComingButtons(
              context, ref, l10n, userProfile, cardNotifier, cardState),
        ];
        break;

      case BookingStatus.tripStarted:
        // Trip started: Check if within destination range
        actionButtons = [
          _buildTripStartedButtons(
              context, ref, l10n, userProfile, cardNotifier, cardState),
        ];
        break;

      case BookingStatus.completed:
        actionButtons = [
          // Future: Add review and book again functionality
        ];
        break;

      case BookingStatus.cancelled:
        actionButtons = [
          // Future: Add book again functionality
        ];
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actionButtons,
    );
  }

  // Build buttons for active status: "I'm Coming", "Chat with User", "Close Booking"
  Widget _buildActiveStatusButtons(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    UserSignupModel? userProfile,
    DriverBookingCardNotifier cardNotifier,
    DriverBookingCardState cardState,
  ) {
    return Row(
      children: [
        NormalCustomButton(
          width: 100,
          height: 40,
          titleStyle: montserrat(12, whiteColor, FontWeight.w500),
          label: cardState.isProcessingAction ? "Processing..." : "I'm Coming",
          buttonColor: cardState.isProcessingAction ? Colors.grey : Colors.blue,
          syncCallback: cardState.isProcessingAction
              ? null
              : () async {
                  await cardNotifier.handleDriverIsComing(
                      context, booking, l10n, userProfile);
                },
        ),
        16.horizontalSpace,
        NormalCustomButton(
          width: 110,
          height: 40,
          titleStyle: montserrat(12, whiteColor, FontWeight.w500),
          label: l10n.chatWithUser,
          syncCallback: () async {
            cardNotifier.handleChatWithUser(context, userProfile, ref);
          },
        ),
        16.horizontalSpace,
        NormalCustomButton(
          label: l10n.closeBooking,
          width: 110,
          height: 40,
          buttonColor: containerbackground,
          titleStyle: montserrat(12, grey56, FontWeight.w500),
          syncCallback: () async {
            await cardNotifier.handleCloseBooking(context);
          },
        ),
      ],
    );
  }

  // Build buttons for driver coming status: Check proximity and show appropriate buttons
  Widget _buildDriverComingButtons(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    UserSignupModel? userProfile,
    DriverBookingCardNotifier cardNotifier,
    DriverBookingCardState cardState,
  ) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || booking.pickupAddress == null) {
      return _buildDefaultDriverComingButtons(
          context, ref, l10n, userProfile, cardNotifier);
    }

    final pickupLocation = booking.pickupAddress!.coordinates;

    return FutureBuilder<bool>(
      future: cardNotifier.checkDriverWithinPickupRange(
        currentUser.uid,
        pickupLocation,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildDefaultDriverComingButtons(
              context, ref, l10n, userProfile, cardNotifier);
        }

        if (snapshot.hasError) {
          log('DEBUG: Distance check ERROR: ${snapshot.error}');
          return _buildDefaultDriverComingButtons(
              context, ref, l10n, userProfile, cardNotifier);
        }

        final isWithinRange = snapshot.data ?? false;
        log('DEBUG: Driver within pickup range: $isWithinRange');

        if (isWithinRange) {
          // Within 500m of pickup - show Start Trip button
          return Row(
            children: [
              NormalCustomButton(
                width: 100,
                height: 40,
                titleStyle: montserrat(12, whiteColor, FontWeight.w500),
                label: cardState.isProcessingAction
                    ? "Processing..."
                    : 'Start Trip',
                buttonColor:
                    cardState.isProcessingAction ? Colors.grey : Colors.green,
                syncCallback: cardState.isProcessingAction
                    ? null
                    : () async {
                        await cardNotifier.handleStartTrip(
                            context, booking, l10n, userProfile);
                      },
              ),
              16.horizontalSpace,
              NormalCustomButton(
                width: 110,
                height: 40,
                titleStyle: montserrat(12, whiteColor, FontWeight.w500),
                label: l10n.chatWithUser,
                syncCallback: () async {
                  cardNotifier.handleChatWithUser(context, userProfile, ref);
                },
              ),
              16.horizontalSpace,
              NormalCustomButton(
                label: l10n.closeBooking,
                width: 110,
                height: 40,
                buttonColor: containerbackground,
                titleStyle: montserrat(12, grey56, FontWeight.w500),
                syncCallback: () async {
                  await cardNotifier.handleCloseBooking(context);
                },
              ),
            ],
          );
        } else {
          // Not within range - show default driver coming buttons
          return _buildDefaultDriverComingButtons(
              context, ref, l10n, userProfile, cardNotifier);
        }
      },
    );
  }

  // Build buttons for trip started status: Check destination proximity
  Widget _buildTripStartedButtons(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    UserSignupModel? userProfile,
    DriverBookingCardNotifier cardNotifier,
    DriverBookingCardState cardState,
  ) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || booking.dropOffAddress == null) {
      return _buildDefaultTripButtons(
          context, ref, l10n, userProfile, cardNotifier);
    }

    final destinationLocation = booking.dropOffAddress!.coordinates;

    return FutureBuilder<bool>(
      future: cardNotifier.checkDriverWithinDestinationRange(
        currentUser.uid,
        destinationLocation,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildDefaultTripButtons(
              context, ref, l10n, userProfile, cardNotifier);
        }

        if (snapshot.hasError) {
          log('DEBUG: Destination distance check ERROR: ${snapshot.error}');
          return _buildDefaultTripButtons(
              context, ref, l10n, userProfile, cardNotifier);
        }

        final isWithinDestinationRange = snapshot.data ?? false;
        log('DEBUG: Driver within destination range: $isWithinDestinationRange');

        if (isWithinDestinationRange) {
          // Within 500m of destination - show End Trip button
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NormalCustomButton(
                label:
                    cardState.isProcessingAction ? "Processing..." : 'End Trip',
                width: 150,
                height: 40,
                buttonColor:
                    cardState.isProcessingAction ? Colors.grey : Colors.red,
                titleStyle: montserrat(12, whiteColor, FontWeight.w500),
                syncCallback: cardState.isProcessingAction
                    ? null
                    : () async {
                        await cardNotifier.handleEndTrip(
                            context, booking, l10n, userProfile);
                      },
              ),
            ],
          );
        } else {
          // Not within destination range - show regular trip buttons
          return _buildDefaultTripButtons(
              context, ref, l10n, userProfile, cardNotifier);
        }
      },
    );
  }

  // Default buttons for driver coming status when not within range
  Widget _buildDefaultDriverComingButtons(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    UserSignupModel? userProfile,
    DriverBookingCardNotifier cardNotifier,
  ) {
    return Row(
      children: [
        NormalCustomButton(
          width: 110,
          height: 40,
          titleStyle: montserrat(12, whiteColor, FontWeight.w500),
          label: l10n.chatWithUser,
          syncCallback: () async {
            cardNotifier.handleChatWithUser(context, userProfile, ref);
          },
        ),
        16.horizontalSpace,
        NormalCustomButton(
          label: l10n.closeBooking,
          width: 110,
          height: 40,
          buttonColor: containerbackground,
          titleStyle: montserrat(12, grey56, FontWeight.w500),
          syncCallback: () async {
            await cardNotifier.handleCloseBooking(context);
          },
        ),
      ],
    );
  }

  // Helper method to build default trip buttons when not within destination range
  Widget _buildDefaultTripButtons(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    UserSignupModel? userProfile,
    DriverBookingCardNotifier cardNotifier,
  ) {
    return Row(
      children: [
        NormalCustomButton(
          width: 140,
          height: 40,
          titleStyle: montserrat(12, whiteColor, FontWeight.w500),
          label: l10n.chatWithUser,
          syncCallback: () async {
            cardNotifier.handleChatWithUser(context, userProfile, ref);
          },
        ),
        8.horizontalSpace,
        NormalCustomButton(
          label: l10n.closeBooking,
          width: 140,
          height: 40,
          buttonColor: containerbackground,
          titleStyle: montserrat(12, grey56, FontWeight.w500),
          syncCallback: () async {
            await cardNotifier.handleCloseBooking(context);
          },
        ),
      ],
    );
  }
}
