import 'package:flutter/material.dart';

class AppDropdown<T> extends StatefulWidget {
  /// the child widget for the button, this will be ignored if text is supplied
  final Widget child;

  /// onChange is called when the selected option is changed.;
  /// It will pass back the value and the index of the option.
  final void Function(int) onChange;
  final void Function()? onClick;

  /// list of DropdownItems
  final List<DropdownItem<T>> items;

  /// dropdown button icon defaults to caret
  final IconData? icon;
  final bool hideIcon;
  final bool isEnabled;
  final bool isError;

  /// if true the dropdown icon will as a leading icon, default to false
  final bool leadingIcon;

  const AppDropdown({
    required this.child,
    required this.items,
    required this.onChange,
    this.onClick,
    super.key,
    this.hideIcon = false,
    this.icon,
    this.leadingIcon = false,
    this.isEnabled = true,
    this.isError = false,
  });

  @override
  State<AppDropdown> createState() => _AppDropdownState();
}

class _AppDropdownState<T> extends State<AppDropdown<T>>
    with TickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0);
  late OverlayEntry _overlayEntry;
  bool _isOpen = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _rotateAnimation = Tween(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.isError == true ? Colors.red : Colors.grey,
            width: 1,
          ),
          borderRadius: !_isOpen
              ? BorderRadius.circular(8)
              : const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
        ),
        child: InkWell(
          borderRadius: !_isOpen
              ? const BorderRadius.all(Radius.circular(8))
              : const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
          onTap: widget.items.isEmpty || widget.isEnabled == false
              ? null
              : () {
                  _closeKeyboard();
                  _toggleDropdown.call();
                  widget.onClick?.call();
                },
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: widget.child),
                        if (widget.items.isNotEmpty &&
                            widget.isEnabled &&
                            !widget.hideIcon &&
                            widget.icon != null)
                          RotationTransition(
                            turns: _rotateAnimation,
                            child: Icon(widget.icon!),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_isOpen) ...[
                Positioned(
                  bottom: 2,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Container(
                        height: 1,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  OverlayEntry _createOverlayEntry() {
    // find the size and position of the current widget
    final RenderBox renderBox = context.findRenderObject()! as RenderBox;
    final size = renderBox.size;

    final offset = renderBox.localToGlobal(Offset.zero);
    final topOffset = offset.dy + size.height;
    return OverlayEntry(
      // full screen GestureDetector to register when a
      // user has clicked away from the dropdown
      builder: (context) => GestureDetector(
        onTap: () => _toggleDropdown(close: true),
        behavior: HitTestBehavior.translucent,
        onVerticalDragUpdate: (_) => _toggleDropdown(close: true),
        // full screen container to register taps anywhere and close drop down
        child: OverlayDropdown<T>(
          onTap: (key) {
            widget.onChange(key);
            _toggleDropdown();
          },
          expandAnimation: _expandAnimation,
          items: widget.items,
          layerLink: _layerLink,
          offset: offset,
          scrollController: _scrollController,
          size: size,
          topOffset: topOffset,
          isError: widget.isError,
        ),
      ),
    );
  }

  void _closeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> _toggleDropdown({bool close = false}) async {
    if (_isOpen || close) {
      await _animationController.reverse();
      _overlayEntry.remove();
      setState(() {
        _isOpen = false;
      });
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry);
      setState(() => _isOpen = true);
      _animationController.forward();
    }
  }
}

/// DropdownItem is just a wrapper for each child in the dropdown list.\n
/// It holds the value of the item.
class DropdownItem<T> extends StatelessWidget {
  final T? value;
  final Widget child;

  const DropdownItem({
    required this.child,
    super.key,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class CustomBorderPainter extends CustomPainter {
  final Color borderColor;
  final double borderWidth;
  final double cornerRadius;

  CustomBorderPainter({
    required this.borderColor,
    required this.borderWidth,
    required this.cornerRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    final halfBorderWidth = borderWidth / 2;
    if (size.height - cornerRadius > 0) {
      final path = Path()
        ..moveTo(halfBorderWidth, 0)
        ..lineTo(halfBorderWidth, size.height - cornerRadius)
        ..quadraticBezierTo(
          halfBorderWidth,
          size.height - halfBorderWidth,
          cornerRadius,
          size.height - halfBorderWidth,
        )
        ..lineTo(
          size.width - cornerRadius - halfBorderWidth,
          size.height - halfBorderWidth,
        )
        ..quadraticBezierTo(
          size.width - halfBorderWidth,
          size.height - halfBorderWidth,
          size.width - halfBorderWidth,
          size.height - cornerRadius,
        )
        ..lineTo(size.width - halfBorderWidth, 0);

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class OverlayDropdown<T> extends StatelessWidget {
  final Offset offset;
  final double topOffset;
  final Size size;
  final List<DropdownItem<T>> items;
  final ScrollController scrollController;
  final Function(int) onTap;
  final LayerLink layerLink;
  final Animation<double> expandAnimation;
  final bool isEnabled;
  final bool isError;

  const OverlayDropdown({
    required this.offset,
    required this.topOffset,
    required this.size,
    required this.items,
    required this.scrollController,
    required this.onTap,
    required this.layerLink,
    required this.expandAnimation,
    this.isEnabled = true,
    this.isError = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double safeAreaBottomPadding =
        View.of(context).viewPadding.bottom / 3;

    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Positioned(
            left: offset.dx,
            top: topOffset,
            width: size.width,
            child: CompositedTransformFollower(
              offset: Offset(0, size.height - 2),
              link: layerLink,
              showWhenUnlinked: false,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  boxShadow: [],
                ),
                child: CustomPaint(
                  foregroundPainter: CustomBorderPainter(
                    borderColor: isError == true ? Colors.red : Colors.grey,
                    borderWidth: 1,
                    cornerRadius: 8,
                  ),
                  child: SizeTransition(
                    axisAlignment: 1,
                    sizeFactor: expandAnimation,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight:
                            (MediaQuery.sizeOf(context).height - topOffset - 10)
                                    .isNegative
                                ? 100
                                : MediaQuery.sizeOf(context).height -
                                    topOffset -
                                    10 -
                                    safeAreaBottomPadding,
                      ),
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: RawScrollbar(
                          mainAxisMargin: 16,
                          thumbVisibility: true,
                          crossAxisMargin: 16,
                          minThumbLength: 1,
                          radius: const Radius.circular(24),
                          thickness: 4,
                          thumbColor: Colors.grey,
                          controller: scrollController,
                          child: ListView(
                            padding: const EdgeInsets.all(5), // or 0
                            shrinkWrap: true,
                            controller: scrollController,
                            children: items.asMap().entries.map((item) {
                              return Material(
                                child: InkWell(
                                  onTap: () => onTap(item.key),
                                  child: Ink(
                                    color: Colors.grey,
                                    child: item.value,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
