import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinite_listview/infinite_listview.dart';
import 'package:sizer/sizer.dart';
import 'package:waterreminder/constant/color_constant.dart';
import 'package:waterreminder/constant/text_style_constant.dart';
import 'package:waterreminder/widgets/custom_divider.dart';

typedef TextMapper = String Function(String numberText);

class NumberPicker extends StatefulWidget {
  final int minValue;
  bool? time = false;
  bool? twoDot = false;
  final int maxValue;

  final int value;

  final ValueChanged<int> onChanged;

  final int itemCount;

  final int step;

  final double itemHeight;

  final double itemWidth;

  final Axis axis;

  final TextStyle? textStyle;

  final TextStyle? selectedTextStyle;

  final bool haptics;

  final TextMapper? textMapper;

  final bool zeroPad;

  final Decoration? decoration;

  final bool infiniteLoop;

  NumberPicker({
    Key? key,
    this.time = false,
    this.twoDot = false,
    required this.minValue,
    required this.maxValue,
    required this.value,
    required this.onChanged,
    this.itemCount = 3,
    this.step = 1,
    this.itemHeight = 50,
    this.itemWidth = 100,
    this.axis = Axis.vertical,
    this.textStyle,
    this.selectedTextStyle,
    this.haptics = false,
    this.decoration,
    this.zeroPad = false,
    this.textMapper,
    this.infiniteLoop = false,
  })  :
        super(key: key);

  @override
  _NumberPickerState createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final initialOffset =
        (widget.value - widget.minValue) ~/ widget.step * itemExtent;
    if (widget.infiniteLoop) {
      _scrollController =
          InfiniteScrollController(initialScrollOffset: initialOffset);
    } else {
      _scrollController = ScrollController(initialScrollOffset: initialOffset);
    }
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    var indexOfMiddleElement = (_scrollController.offset / itemExtent).round();
    if (widget.infiniteLoop) {
      indexOfMiddleElement %= itemCount;
    } else {
      indexOfMiddleElement = indexOfMiddleElement.clamp(0, itemCount - 1);
    }
    final intValueInTheMiddle =
        _intValueFromIndex(indexOfMiddleElement + additionalItemsOnEachSide);

    if (widget.value != intValueInTheMiddle) {
      widget.onChanged(intValueInTheMiddle);
      if (widget.haptics) {
        HapticFeedback.selectionClick();
      }
    }
    Future.delayed(
      const Duration(milliseconds: 100),
      () => _maybeCenterValue(),
    );
  }

  @override
  void didUpdateWidget(NumberPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _maybeCenterValue();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool get isScrolling => _scrollController.position.isScrollingNotifier.value;

  double get itemExtent =>
      widget.axis == Axis.vertical ? widget.itemHeight : widget.itemWidth;

  int get itemCount => (widget.maxValue - widget.minValue) ~/ widget.step + 1;

  int get listItemsCount => itemCount + 2 * additionalItemsOnEachSide;

  int get additionalItemsOnEachSide => (widget.itemCount - 1) ~/ 2;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.axis == Axis.vertical
          ? widget.itemWidth
          : widget.itemCount * widget.itemWidth,
      height: widget.axis == Axis.vertical
          ? widget.itemCount * widget.itemHeight
          : widget.itemHeight,
      child: NotificationListener<ScrollEndNotification>(
        onNotification: (not) {
          if (not.dragDetails?.primaryVelocity == 0) {
            Future.microtask(() => _maybeCenterValue());
          }
          return true;
        },
        child: Stack(
          children: [
            if (widget.infiniteLoop)
              InfiniteListView.builder(
                scrollDirection: widget.axis,
                controller: _scrollController as InfiniteScrollController,
                itemExtent: itemExtent,
                itemBuilder: _itemBuilder,
                padding: EdgeInsets.zero,
              )
            else
              ListView.builder(
                itemCount: listItemsCount,
                scrollDirection: widget.axis,
                controller: _scrollController,
                itemExtent: itemExtent,
                itemBuilder: _itemBuilder,
                padding: EdgeInsets.zero,
              ),
            _NumberPickerSelectedItemDecoration(
              axis: widget.axis,
              itemExtent: itemExtent,
              decoration: widget.decoration,
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    // final themeData = Theme.of(context);
    // final defaultStyle = widget.textStyle ?? themeData.textTheme.bodyText2;
    // final selectedStyle = widget.selectedTextStyle ??
    //     themeData.textTheme.headline5
    //         ?.copyWith(color: themeData.colorScheme.secondary);

    final value = _intValueFromIndex(index % itemCount);
    final isExtra = !widget.infiniteLoop &&
        (index < additionalItemsOnEachSide ||
            index >= listItemsCount - additionalItemsOnEachSide);
    final itemStyle = value == widget.value
        ? /*selectedStyle*/ TextStyleConstant.blue50.copyWith(fontSize:
            35.sp)
        : TextStyleConstant.blue50.copyWith(
            fontSize: 35.sp,
            color: ColorConstant.greyAF.withOpacity(.75)) /*defaultStyle*/;

    final child = isExtra
        ? const SizedBox.shrink()
        : Column(
            children: [
              if (value == widget.value && widget.time == false)
                customDivider(
                    width: MediaQuery.of(context).size.width / 6.5,
                    context: context,
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 7.3,
                        right: MediaQuery.of(context).size.width / 18)),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    value == widget.value && widget.time == false
                        ? Image.asset(
                            'assets/play.png',
                            cacheWidth: 26,
                            cacheHeight: 30,
                            fit: BoxFit.fill,
                            color: ColorConstant.blueFE,
                          )
                        : widget.time == true
                            ? const SizedBox()
                            : const SizedBox(width: 16),
                    SizedBox(width: widget.time == true ? 0 : 10),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        value == widget.value && widget.twoDot == true
                            ? "${_getDisplayedValue(value)} :"
                            : _getDisplayedValue(value),
                        textAlign: TextAlign.end,
                        style: itemStyle,
                      ),
                    ),
                  ],
                ),
              ),
              if (value == widget.value && widget.time == false)
                customDivider(
                    //  width: MediaQuery.of(context).size.width / 6.5,
                    context: context,
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 7.3,
                        right: MediaQuery.of(context).size.width / 18)),
            ],
          );

    return Container(
      width: widget.itemWidth,
      height: widget.itemHeight,
      alignment: Alignment.center,
      child: child,
    );
  }

  String _getDisplayedValue(int value) {
    final text = widget.zeroPad
        ? value.toString().padLeft((widget.maxValue - 1).toString().length, '0')
        : value.toString();
    if (widget.textMapper != null) {
      return widget.textMapper!(text);
    } else {
      return text;
    }
  }

  int _intValueFromIndex(int index) {
    index -= additionalItemsOnEachSide;
    index %= itemCount;
    return widget.minValue + index * widget.step;
  }

  void _maybeCenterValue() {
    if (_scrollController.hasClients && !isScrolling) {
      int diff = widget.value - widget.minValue;
      int index = diff ~/ widget.step;
      if (widget.infiniteLoop) {
        final offset = _scrollController.offset + 0.5 * itemExtent;
        final cycles = (offset / (itemCount * itemExtent)).floor();
        index += cycles * itemCount;
      }
      _scrollController.animateTo(
        index * itemExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }
}

class _NumberPickerSelectedItemDecoration extends StatelessWidget {
  final Axis axis;
  final double itemExtent;
  final Decoration? decoration;

  const _NumberPickerSelectedItemDecoration({
    Key? key,
    required this.axis,
    required this.itemExtent,
    required this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IgnorePointer(
        child: Container(
          width: isVertical ? double.infinity : itemExtent,
          height: isVertical ? itemExtent : double.infinity,
          decoration: decoration,
        ),
      ),
    );
  }

  bool get isVertical => axis == Axis.vertical;
}
