import 'package:flutter/material.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';

class SearchableDropdownField extends StatefulWidget {
  final String? title;
  final String? hint;
  final String value;
  final List<String> items;
  final Function(String) onChanged;
  final String? prefixIcon;
  final bool enabled;
  final String? errorText;
  final Function(String)? onSearch;

  const SearchableDropdownField({
    super.key,
    this.title,
    this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.prefixIcon,
    this.enabled = true,
    this.errorText,
    this.onSearch,
  });

  @override
  State<SearchableDropdownField> createState() =>
      _SearchableDropdownFieldState();
}

class _SearchableDropdownFieldState extends State<SearchableDropdownField> {
  late TextEditingController _searchController;
  List<String> _filteredItems = [];
  bool _isDropdownOpen = false;
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.value);
    _filteredItems = widget.items;

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showDropdown();
      }
    });
  }

  @override
  void didUpdateWidget(SearchableDropdownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _searchController.text = widget.value;
    }
    if (widget.items != oldWidget.items) {
      _filteredItems = widget.items;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _hideDropdown();
    super.dispose();
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });

    if (widget.onSearch != null) {
      widget.onSearch!(query);
    }

    _updateDropdown();
  }

  void _showDropdown() {
    if (!widget.enabled || _isDropdownOpen) return;

    _isDropdownOpen = true;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideDropdown() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    _isDropdownOpen = false;
  }

  void _updateDropdown() {
    if (_isDropdownOpen && _overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12.r),
            color: Colors.white,
            shadowColor: accentPurple.withOpacity(0.2),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: 200.h,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: accentPurple.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: _filteredItems.isEmpty
                  ? Container(
                      padding: EdgeInsets.all(16.w),
                      child: Text(
                        'No items found',
                        style: montserrat(14, grey5F63, FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        final isSelected = item == widget.value;

                        return InkWell(
                          onTap: () {
                            widget.onChanged(item);
                            _searchController.text = item;
                            _hideDropdown();
                            _focusNode.unfocus();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? accentPurple.withOpacity(0.1)
                                  : Colors.transparent,
                              border: index < _filteredItems.length - 1
                                  ? Border(
                                      bottom: BorderSide(
                                        color: grey5E5E5E.withOpacity(0.1),
                                        width: 0.5,
                                      ),
                                    )
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item,
                                    style: montserrat(
                                      14,
                                      isSelected ? accentPurple : grey36,
                                      isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check,
                                    color: accentPurple,
                                    size: 16.sp,
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
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (widget.title != null) ...[
        //   Text(
        //     widget.title!,
        //     style: montserrat(14, grey36, FontWeight.w500),
        //   ),
        //   8.verticalSpace,
        // ],
        CompositedTransformTarget(
          link: _layerLink,
          child: Container(
            height: 54.h,
            decoration: BoxDecoration(
              color:
                  widget.enabled ? Colors.white : grey5E5E5E.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: widget.errorText != null
                    ? Colors.red.withOpacity(0.5)
                    : (widget.enabled
                        ? grey5E5E5E.withOpacity(0.2)
                        : grey5E5E5E.withOpacity(0.1)),
                width: 1,
              ),
              boxShadow: widget.enabled
                  ? [
                      BoxShadow(
                        color: grey5E5E5E.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                if (widget.prefixIcon != null) ...[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    height: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          widget.prefixIcon!,
                          width: 20.w,
                          height: 20.w,
                          color: accentPurple,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 32.h,
                    color: grey5E5E5E.withOpacity(0.2),
                  ),
                ],
                Expanded(
                  child: TextFormField(
                    controller: _searchController,
                    focusNode: _focusNode,
                    enabled: widget.enabled,
                    style: montserrat(
                      14,
                      widget.enabled ? grey36 : grey5E5E5E.withOpacity(0.5),
                      FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      hintStyle: montserrat(
                        14,
                        grey5E5E5E.withOpacity(0.6),
                        FontWeight.w400,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      isDense: true,
                    ),
                    onChanged: _filterItems,
                    onTap: () {
                      if (widget.enabled) {
                        _showDropdown();
                      }
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Icon(
                    _isDropdownOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: widget.enabled
                        ? accentPurple
                        : grey5E5E5E.withOpacity(0.5),
                    size: 20.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (widget.errorText != null) ...[
          8.verticalSpace,
          Row(
            children: [
              Icon(
                Icons.error_outline,
                size: 16.sp,
                color: Colors.red.withOpacity(0.8),
              ),
              SizedBox(width: isRTL ? 4.w : 8.w),
              Expanded(
                child: Text(
                  widget.errorText!,
                  style: montserrat(
                    12,
                    Colors.red.withOpacity(0.8),
                    FontWeight.w500,
                  ),
                  textAlign: isRTL ? TextAlign.right : TextAlign.left,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
