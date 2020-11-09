import 'package:flutter/material.dart';

import 'package:coborg/coborg/coborg.dart';

void main() {
	runApp(MyApp());
}

class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Flutter Demo',
			home: MyHomePage(),
		);
	}
}

class MyHomePage extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.black,
			body: Center(
				child: Coborg(
					width: MediaQuery.of(context).size.width,
					height: MediaQuery.of(context).size.height,
					widgets: [
						for (var i = 0; i < 3; i++)
							Container(
								width: 100,
								height: 100,
								color: Colors.red,
								child: Center(child: Text(i.toString())),
							)
					]
				),
			),
		);
	}
}
