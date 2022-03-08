import 'package:flutter/material.dart';
import 'dart:math';

/// _Children is used since [ValueListenableBuilder]
/// only accept child that is not rebuild as a single Widget.
class _Children extends Widget {
  final List<Widget> children;
  const _Children({
    required this.children,
  });

  @override
  Element createElement() {
    throw UnimplementedError();
  }
}

class BubbleLens extends StatefulWidget {
  final double width;
  final double height;
  final List<Widget> widgets;
  final double size;
  final double paddingX;
  final double paddingY;
  final Duration duration;
  final Radius radius;
  final double highRatio;
  final double lowRatio;

  const BubbleLens({
    Key? key,
    required this.width,
    required this.height,
    required this.widgets,
    this.size = 100,
    this.paddingX = 10,
    this.paddingY = 0,
    this.duration = const Duration(milliseconds: 100),
    this.radius = const Radius.circular(999),
    this.highRatio = 0,
    this.lowRatio = 0,
  }) : super(key: key);

  @override
  BubbleLensState createState() => BubbleLensState();
}

class BubbleLensState extends State<BubbleLens> {
  late final ValueNotifier<Offset> offsetNotifer;

  double _middleX = 0;
  double _middleY = 0;

  double _lastX = 0;
  double _lastY = 0;
  List _steps = [];
  int _counter = 0;
  int _total = 0;
  int _lastTotal = 0;

  double _minLeft = double.infinity;
  double _maxLeft = double.negativeInfinity;
  double _minTop = double.infinity;
  double _maxTop = double.negativeInfinity;

  @override
  void initState() {
    super.initState();
    _middleX = widget.width / 2;
    _middleY = widget.height / 2;
    offsetNotifer = ValueNotifier(Offset(_middleX - widget.size / 2, _middleY - widget.size / 2));
    _lastX = 0;
    _lastY = 0;
    _steps = [
      [-(widget.size / 2) + -(widget.paddingX / 2), -widget.size + -widget.paddingY],
      [-widget.size + -widget.paddingX, 0],
      [-(widget.size / 2) + -(widget.paddingX / 2), widget.size + widget.paddingY],
      [(widget.size / 2) + (widget.paddingX / 2), widget.size + widget.paddingY],
      [widget.size + widget.paddingX, 0],
      [(widget.size / 2) + (widget.paddingX / 2), -widget.size + -widget.paddingY],
    ];
  }

  @override
  void dispose() {
    offsetNotifer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanUpdate: (details) {
          double _offsetX = offsetNotifer.value.dx;
          double _offsetY = offsetNotifer.value.dy;
          double newOffsetX = max(_minLeft, min(_maxLeft, _offsetX + details.delta.dx));
          double newOffsetY = max(_minTop, min(_maxTop, _offsetY + details.delta.dy));
          if (newOffsetX != _offsetX || newOffsetY != _offsetY) {
            offsetNotifer.value = Offset(newOffsetX, newOffsetY);
          }
        },
        child: ValueListenableBuilder<Offset>(
          valueListenable: offsetNotifer,
          child: buildChildren(),
          builder: (context, value, child) {
            child as _Children;

            _counter = 0;
            _total = 0;

            return Stack(
              children: List.generate(child.children.length, (index) {
                Widget item = child.children[index];
                return buildChild(index, item);
              }),
            );
          },
        ),
      ),
    );
  }

  Widget buildChildren() {
    return _Children(
      children: widget.widgets.map((e) {
        return ClipRRect(
          borderRadius: BorderRadius.all(widget.radius),
          child: SizedBox(width: widget.size, height: widget.size, child: e),
        );
      }).toList(),
    );
  }

  Widget buildChild(int index, Widget child) {
    double left;
    double top;

    double _offsetX = offsetNotifer.value.dx;
    double _offsetY = offsetNotifer.value.dy;

    if (index == 0) {
      left = _offsetX;
      top = _offsetY;
    } else if (index - 1 == _total) {
      left = (_counter + 1) * (widget.size + widget.paddingX) + _offsetX;
      top = _offsetY;
      _lastTotal = _total;
      _counter++;
      _total += _counter * 6;
    } else {
      List step = _steps[((index - _lastTotal - 2) / _counter % _steps.length).floor()];
      left = _lastX + step[0];
      top = _lastY + step[1];
    }

    _minLeft = min(_minLeft, -(left - _offsetX) + _middleX - (widget.size / 2));
    _maxLeft = max(_maxLeft, left - _offsetX + _middleX - (widget.size / 2));
    _minTop = min(_minTop, -(top - _offsetY) + _middleY - (widget.size / 2));
    _maxTop = max(_maxTop, top - _offsetY + _middleY - (widget.size / 2));
    _lastX = left;
    _lastY = top;

    double distance = sqrt(pow(_middleX - (left + widget.size / 2), 2) + pow(_middleY - (top + widget.size / 2), 2));
    double size = widget.size / max(distance / widget.size, 1);
    double scale = max(0, min(1, (size / widget.size * (1 + widget.highRatio + widget.lowRatio)) - widget.lowRatio));

    return AnimatedPositioned(
      duration: widget.duration,
      top: top,
      left: left,
      child: Container(
        alignment: Alignment.center,
        width: widget.size,
        height: widget.size,
        child: Transform.scale(
          scale: scale,
          child: child,
        ),
      ),
    );
  }
}
