import 'package:flutter/material.dart';

import 'package:bubble_lens/bubble_lens.dart';

void main() {
	runApp(MyApp());
}

class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Bubble Lens',
			home: MyHomePage(),
		);
	}
}

class MyHomePage extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.white,
			body: Container(
				color: Colors.black,
				child: BubbleLens(
					width: MediaQuery.of(context).size.width,
					height: MediaQuery.of(context).size.height,
					widgets: [
						for (var i = 0; i < 60; i++)
							Container(
								width: 100,
								height: 100,
								color: [Colors.red, Colors.green, Colors.blue][i % 3],
							)
					]
				),
			),
		);
	}
}
