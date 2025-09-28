import 'dart:developer';

import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:http/http.dart' as http;

class CustomGooglePlacesAutoCompleteTextField extends StatefulWidget {
  final String titleText;
  final TextEditingController controller;
  final Function(String, String, String, String, double, double)
      onPlaceSelected;
  final TextStyle? titleStyle;
  final String?
      prefixIcon; // Changed from IconData? to String? to match CustomTextField
  final bool applyMargin;

  const CustomGooglePlacesAutoCompleteTextField(
      {super.key,
      this.titleStyle,
      required this.titleText,
      required this.controller,
      this.prefixIcon,
      this.applyMargin = false,
      required this.onPlaceSelected});

  @override
  State<CustomGooglePlacesAutoCompleteTextField> createState() =>
      _CustomGooglePlacesAutoCompleteTextFieldState();
}

class _CustomGooglePlacesAutoCompleteTextFieldState
    extends State<CustomGooglePlacesAutoCompleteTextField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Add listener to the controller to track and fix backspace issues
    widget.controller.addListener(_handleTextChange);
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChange);
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleTextChange() {
    // Store the current text for comparison
    widget.controller.text;
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      // When focus is lost, ensure the selection is at the end
      // This prevents strange cursor behavior when returning to the field
      widget.controller.selection = TextSelection.fromPosition(
          TextPosition(offset: widget.controller.text.length));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: widget.applyMargin
              ? EdgeInsets.symmetric(horizontal: 23.w)
              : null,
          height: 48.h, // Match CustomTextField height
          child: GooglePlaceAutoCompleteTextField(
            textEditingController: widget.controller,
            textStyle: montserrat(14, grey36,
                FontWeight.w500), // Match CustomTextField text style
            googleAPIKey: Platform.isAndroid
                ? "AIzaSyDVTlHQCpgj5-UZk-iRooJ61sk4m0fLJjU"
                : "AIzaSyDAuH4p3ZMMccFuxdvhTQoEZMJZUPkvEY0",
            inputDecoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              prefixIconConstraints: const BoxConstraints(maxHeight: 20),
              suffixIconConstraints: const BoxConstraints(maxHeight: 30),
              filled: true,
              fillColor: whiteColor, // Match CustomTextField fill color
              counterText: "",
              hintText: widget.titleText,
              hintStyle: montserrat(14, grey36,
                  FontWeight.w500), // Match CustomTextField hint style
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                    color: borderGrey,
                    width: 1), // Match CustomTextField border
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Padding(
                      padding: EdgeInsets.only(left: 10.w, right: 5.w),
                      child: SvgPicture.asset(
                        widget.prefixIcon!,
                        color: accentPurple,
                        height: 24.h,
                      ),
                    )
                  : null,
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                    color: borderGrey), // Match CustomTextField border
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                    color: borderGrey), // Match CustomTextField border
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              // Add back the clear button (X icon)
              suffixIcon: widget.controller.text.isNotEmpty
                  ? GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Icon(Icons.clear, color: accentPurple, size: 18),
                      ),
                      onTap: () {
                        // Clear text and notify
                        widget.controller.clear();
                        widget.onPlaceSelected('', '', '', '', 0.0, 0.0);
                      },
                    )
                  : null,
            ),

            // Custom focus node to better manage focus
            focusNode: _focusNode,
            boxDecoration:
                const BoxDecoration(), // Remove transparent border to match CustomTextField
            debounceTime: 400,
            countries: const ['SA'],
            isLatLngRequired: true,
            getPlaceDetailWithLatLng: (Prediction prediction) {
              // Your implementation for getting place details
            },
            itemClick: (Prediction prediction) {
              FocusScope.of(context).unfocus();
              getLatLngFromPlaceId(prediction.placeId!);
            },
            containerHorizontalPadding: 0,
            // Filter suggestions based on user input
            itemBuilder: (context, index, Prediction prediction) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        SvgPicture.asset(
                          AppIcons.address,
                          height: 20.h,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Text(
                          prediction.description ?? "",
                          style: openSans(13, grey36, FontWeight.w400)
                              .copyWith(letterSpacing: 0.6),
                        )),
                      ],
                    ),
                  ),
                  const Divider()
                ],
              );
            },
            // Keep isCrossBtnShown false to hide the circular cross button from GooglePlacesAutoCompleteTextField
            isCrossBtnShown: false,
          ),
        ),
      ],
    );
  }

  Future getLatLngFromPlaceId(String placeId) async {
    final apiKey = Platform.isAndroid
        ? "AIzaSyDVTlHQCpgj5-UZk-iRooJ61sk4m0fLJjU"
        : "AIzaSyDAuH4p3ZMMccFuxdvhTQoEZMJZUPkvEY0";

    final response = await http.get(
      Uri.parse(
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      final Map<String, dynamic> location =
          data['result']['geometry']['location'] ?? {};
      final double lat = location['lat'] ?? 0.0;
      final double lng = location['lng'] ?? 0.0;
      final result = data['result'];

      log('Result: ${result['formatted_address']}');

      String fulladdress = result['formatted_address'];

      // Initialize variables for address, city, state, and zip
      String city = '';
      String state = '';
      String zip = '';

      // Iterate through the address components to find the street address
      for (var component in result['address_components']) {
        if (component['types'].contains('locality')) {
          city = component['long_name'];
        } else if (component['types'].contains('administrative_area_level_1')) {
          state = component['short_name'];
        } else if (component['types'].contains('postal_code')) {
          zip = component['long_name'];
        }
      }

      // Update text in a controlled way with proper selection
      if (mounted) {
        setState(() {
          widget.controller.value = TextEditingValue(
            text: fulladdress,
            selection: TextSelection.collapsed(offset: fulladdress.length),
          );
        });
      }

      // Pass the data to the callback function (onPlaceSelected)
      widget.onPlaceSelected(fulladdress, city, state, zip, lat, lng);
    } else {
      widget.onPlaceSelected('', '', '', '', 0.00, 0.00);
      return null;
    }
  }
}
