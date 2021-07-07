import 'package:example/data/data.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Fake HTTP call'),
            Text(
              Data().getWeather().access(
                    (success) => 'weather: ${success.weather}\n'
                        'chance of rain: ${success.propRain}\n'
                        'temperature: ${success.tempInDegrees}',
                    (failure) => failure.map(
                      noConnection: (_) =>
                          'Make sure you\'re connected to the internet!',
                      unauthorized: (_) => 'You are not allowed to view this!',
                    ),
                  ),
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
