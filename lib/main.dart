import 'package:flutter/material.dart';
import 'dart:math';

import 'package:bubble_lens/bubble_lens/bubble_lens.dart';

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
	List assets = [
		'assets/badoo.png',
		'assets/behance.png',
		'assets/deviantart.png',
		'assets/dribbble.png',
		'assets/dropbox.png',
		'assets/facebook.png',
		'assets/flickr.png',
		'assets/foursquare.png',
		'assets/google-plus.png',
		'assets/instagram.png',
		'assets/line.png',
		'assets/linkedin.png',
		'assets/myspace.png',
		'assets/path.png',
		'assets/pinterest.png',
		'assets/quora.png',
		'assets/skype.png',
		'assets/snapchat.png',
		'assets/soundcloud.png',
		'assets/spotify.png',
		'assets/swarm.png',
		'assets/telegram.png',
		'assets/tumblr.png',
		'assets/twitter.png',
		'assets/viber.png',
		'assets/vimeo.png',
		'assets/vine.png',
		'assets/whatsapp.png',
		'assets/yelp.png',
		'assets/youtube.png'
	];

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.white,
			body: Center(
				child: Container(
					color: Colors.black,
					child: BubbleLens(
						width: MediaQuery.of(context).size.width,
						height: MediaQuery.of(context).size.height,
//						width: 300,
//						height: 300,
						size: 100,
						padding: 12,
						widgets: [
							for (var i = 0; i < 70; i++)
								Container(
									width: 100,
									height: 100,
									child: Center(
										child: Image.asset(
											assets[Random().nextInt(assets.length)],
											fit: BoxFit.cover,
										)
									),
								)
						]
					),
				)
			),
		);
	}
}
