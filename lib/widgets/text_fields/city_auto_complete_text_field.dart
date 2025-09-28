import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:semester_student_ride_app/config/app_colors.dart';
import 'package:semester_student_ride_app/utils/text_styles.dart';
import 'package:semester_student_ride_app/constants/saudi_cities.dart';

class CityAutoCompleteTextField extends StatefulWidget {
  final TextEditingController controller;
  final String titleText;
  final String? prefixIcon;
  final Function(String)? onCitySelected;
  final double? width;
  final double? height;

  const CityAutoCompleteTextField({
    super.key,
    required this.controller,
    required this.titleText,
    this.prefixIcon,
    this.onCitySelected,
    this.width,
    this.height = 50,
  });

  @override
  State<CityAutoCompleteTextField> createState() =>
      _CityAutoCompleteTextFieldState();
}

class _CityAutoCompleteTextFieldState extends State<CityAutoCompleteTextField> {
  final FocusNode _focusNode = FocusNode();
  List<String> _filteredCities = [];
  bool _showSuggestions = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onTextChanged() {
    final query = widget.controller.text;
    setState(() {
      _filteredCities = SaudiCities.filterCities(query);
      _showSuggestions = query.isNotEmpty && _filteredCities.isNotEmpty;
    });

    if (_showSuggestions && _focusNode.hasFocus) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus && _showSuggestions) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _showOverlay() {
    _removeOverlay();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: widget.width ?? MediaQuery.of(context).size.width - 40.w,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, (widget.height ?? 50).h),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              constraints: BoxConstraints(maxHeight: 200.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: borderGrey, width: 1),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _filteredCities.length,
                itemBuilder: (context, index) {
                  final city = _filteredCities[index];
                  return InkWell(
                    onTap: () => _selectCity(city),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        border: index < _filteredCities.length - 1
                            ? Border(
                                bottom: BorderSide(
                                  color: borderGrey.withOpacity(0.3),
                                  width: 0.5,
                                ),
                              )
                            : null,
                      ),
                      child: Row(
                        children: [
                          if (widget.prefixIcon != null) ...[
                            SvgPicture.asset(
                              widget.prefixIcon!,
                              height: 16.h,
                              color: accentPurple.withOpacity(0.7),
                            ),
                            8.horizontalSpace,
                          ],
                          Expanded(
                            child: Text(
                              city,
                              style: montserrat(
                                13,
                                grey36,
                                FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _selectCity(String city) {
    widget.controller.text = city;
    widget.onCitySelected?.call(city);
    _removeOverlay();
    _focusNode.unfocus();
    setState(() {
      _showSuggestions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: (widget.height ?? 50).h,
            width: widget.width?.w ?? double.infinity,
            child: TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              style: montserrat(14, grey36, FontWeight.w500),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                prefixIconConstraints: const BoxConstraints(maxHeight: 20),
                suffixIconConstraints: const BoxConstraints(maxHeight: 30),
                counterText: "",
                filled: true,
                fillColor: whiteColor,
                hintText: widget.titleText,
                hintStyle: montserrat(14, grey36, FontWeight.w500),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: borderGrey, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: borderGrey),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: borderGrey),
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
                suffixIcon: widget.controller.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          widget.controller.clear();
                          widget.onCitySelected?.call('');
                          _removeOverlay();
                          setState(() {
                            _showSuggestions = false;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Icon(
                            Icons.clear,
                            color: accentPurple,
                            size: 18.sp,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
