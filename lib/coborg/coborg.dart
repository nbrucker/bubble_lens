import 'dart:math';

import 'package:flutter/material.dart';

class Coborg extends StatefulWidget {
	final double width;
	final double height;
	final List<Widget> widgets;

	const Coborg({
		Key key,
		@required this.width,
		@required this.height,
		@required this.widgets
	});

	@override
	CoborgState createState() => CoborgState();
}

class CoborgState extends State<Coborg> {
	int _duration = 100;
	double _maxSize = 100;
	double _padding = 13;
	double _middleX;
	double _middleY;
	int _lines;
	double _offsetX;
	double _offsetY;
	double _lastLeft = 0;
	double _lastTop = 0;
	List _steps;
	int _i = 0;
	int _x = 0;
	int _lastX;

	@override
	void initState() {
		super.initState();
		_middleX = widget.width / 2;
		_middleY = widget.height / 2;
		_lines = sqrt(widget.widgets.length).ceil();
//		_offsetX = -((_maxSize + _padding) * (_lines / 2)) + _middleX;
//		_offsetY = -(_maxSize * (_lines / 2)) + _middleY;
		_offsetX = _middleX - _maxSize / 2;
		_offsetY = _middleY - _maxSize / 2;
		_steps = [
			[-(_maxSize / 2) + -(_padding / 2), -_maxSize],
			[-_maxSize + -_padding, 0],
			[-(_maxSize / 2) + -(_padding / 2), _maxSize],
			[(_maxSize / 2) + (_padding / 2), _maxSize],
			[_maxSize + _padding, 0],
			[(_maxSize / 2) + (_padding / 2), -_maxSize],
		];
	}

	@override
	void dispose() {
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		_i = 0;
		_x = 0;
		return Container(
			width: widget.width,
			height: widget.height,
			child: GestureDetector(
				behavior: HitTestBehavior.opaque,
				onPanUpdate: (details) {
					double newOffsetX = _offsetX + details.delta.dx;
					double newOffsetY = _offsetY + details.delta.dy;
//					if ((newOffsetX != _offsetX  || newOffsetY != _offsetY)
//					&& (newOffsetX < _middleX - _maxSize / 2 && newOffsetY < _middleY - _maxSize / 2)
//					&& (newOffsetX > -((_maxSize + _padding) * _lines) + _middleX + _maxSize / 2 && newOffsetY > -(_maxSize * _lines) + _middleY + _maxSize * 1.5)) {
						setState(() {
							_offsetX += details.delta.dx;
							_offsetY += details.delta.dy;
						});
//					}
				},
				onPanEnd: (details) {
//					print('end');
//					print(details);
				},
				child: Stack(
					children: widget.widgets.map((item) {
						int index = widget.widgets.indexOf(item);
						double left;
						double top;
						if (index == 0) {
							left = _offsetX;
							top = _offsetY;
						} else if ((index - 1) == _x) {
							left = (_i + 1) * (_maxSize + _padding) + _offsetX;
							top = _offsetY;
							_lastX = _x;
							_i++;
							_x += _i * 6;
						} else {
							int n = ((index - _lastX - 2) / _i % _steps.length).floor();
							List step = _steps[n];
							left = _lastLeft + step[0];
							top = _lastTop + step[1];
						}
						_lastLeft = left;
						_lastTop = top;
//						double top = (index / _lines).floor() * _maxSize + _offsetY;
//						double left = index % _lines * (_maxSize + _padding) + ((index / _lines).floor() % 2 != 0 ? (_maxSize / 2 + _padding / 2) : 0) + _offsetX;
						double distance = sqrt(pow(_middleX - (left + _maxSize / 2), 2) + (pow(_middleY - (top + _maxSize / 2), 2)));
						double size = _maxSize / max(distance / _maxSize, 1);
						return AnimatedPositioned(
							duration: Duration(milliseconds: _duration),
							top: top,
							left: left,
							child: Container(
								alignment: Alignment.center,
								width: _maxSize,
								height: _maxSize,
								child: ClipRRect(
									borderRadius: BorderRadius.circular(999),
									child: AnimatedContainer(
										duration: Duration(milliseconds: _duration),
										width: size,
										height: size,
										child: item,
									),
								),
							)
						);
					}).toList()
				),
			),
		);
	}
}