import 'package:flutter/material.dart';
import 'dart:math';

class BubbleLens extends StatefulWidget {
  final double width;
  final double height;
  final List<Widget> widgets;
  final double size;
  final double paddingX;
  final double paddingY;
  final Duration duration;
  final Radius radius;
  final bool fadeEdge;

  BubbleLens({
    Key? key,
    required this.width,
    required this.height,
    required this.widgets,
    this.fadeEdge = true,
    this.size = 100,
    this.paddingX = 10,
    this.paddingY = 0,
    this.duration = const Duration(milliseconds: 100),
    this.radius = const Radius.circular(999),
  }) : super(key: key);

  @override
  BubbleLensState createState() => BubbleLensState();
}

class BubbleLensState extends State<BubbleLens> {
  double _middleX = 0;
  double _middleY = 0;
  double _offsetX = 0;
  double _offsetY = 0;
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

  double get longerSide => max(widget.width, widget.height);

  @override
  void initState() {
    super.initState();

    _middleX = widget.width / 2;
    _middleY = widget.height / 2;
    _offsetX = _middleX - widget.size / 2;
    _offsetY = _middleY - widget.size / 2;
    _lastX = 0;
    _lastY = 0;
    _steps = [
      [
        -(widget.size / 2) + -(widget.paddingX / 2),
        -widget.size + -widget.paddingY
      ],
      [-widget.size + -widget.paddingX, 0],
      [
        -(widget.size / 2) + -(widget.paddingX / 2),
        widget.size + widget.paddingY
      ],
      [
        (widget.size / 2) + (widget.paddingX / 2),
        widget.size + widget.paddingY
      ],
      [widget.size + widget.paddingX, 0],
      [
        (widget.size / 2) + (widget.paddingX / 2),
        -widget.size + -widget.paddingY
      ],
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _counter = 0;
    _total = 0;
    Widget bubbles = Container(
      width: widget.width,
      height: widget.height,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanUpdate: (details) {
          double newOffsetX = max(
              _minLeft, min(_maxLeft, _offsetX + details.delta.dx));
          double newOffsetY = max(
              _minTop, min(_maxTop, _offsetY + details.delta.dy));
          if (newOffsetX != _offsetX || newOffsetY != _offsetY) {
            setState(() {
              _offsetX = newOffsetX;
              _offsetY = newOffsetY;
            });
          }
        },
        child: Stack(
            children: widget.widgets.map((item) {
              int index = widget.widgets.indexOf(item);
              double left;
              double top;
              if (index == 0) {
                left = _offsetX;
                top = _offsetY;
              } else if (index - 1 == _total) {
                left =
                    (_counter + 1) * (widget.size + widget.paddingX) + _offsetX;
                top = _offsetY;
                _lastTotal = _total;
                _counter++;
                _total += _counter * 6;
              } else {
                List step = _steps[((index - _lastTotal - 2) / _counter %
                    _steps.length).floor()];
                left = _lastX + step[0];
                top = _lastY + step[1];
              }
              _minLeft = min(
                  _minLeft, -(left - _offsetX) + _middleX - (widget.size / 2));
              _maxLeft =
                  max(_maxLeft, left - _offsetX + _middleX - (widget.size / 2));
              _minTop = min(
                  _minTop, -(top - _offsetY) + _middleY - (widget.size / 2));
              _maxTop =
                  max(_maxTop, top - _offsetY + _middleY - (widget.size / 2));
              _lastX = left;
              _lastY = top;
              double distance = sqrt(
                  pow(_middleX - (left + widget.size / 2), 2) +
                      pow(_middleY - (top + widget.size / 2), 2));
              double distPercent = distance / (longerSide / 2);

              double scale = .3 * log(distPercent * -1 + 1.2) + .93;
              scale = max(.3, min(1, (scale)));
              if (scale.toString() == double.nan.toString()) scale = .3;


              double originX = min(
                  widget.size * 1, max(widget.size * -1, left - _middleX)) / -2;
              double originY = min(
                  widget.size * 1, max(widget.size * -1, top - _middleY)) / -2;

              double fadePercent = distPercent*.9;
              double fadeValue = .9;
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
                        origin: Offset(originX, originY),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(widget.radius),
                          child: Opacity(
                            opacity: (widget.fadeEdge && fadePercent>fadeValue) ? max(0, min(1, 1-(fadePercent-fadeValue)/(1-fadeValue))) : 1,
                            child: Container(
                              width: widget.size,
                              height: widget.size,
                              child: item,
                            ),
                          ),
                        ),
                      )
                  )
              );
            }).toList()
        ),
      ),
    );

    return bubbles;
  }
}