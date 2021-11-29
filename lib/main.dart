import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<SensorData> fetchSensorData() async {
  const hostUrl = 'http://192.168.80.1:3000';

  final response = await http.get(Uri.parse(hostUrl));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return SensorData.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load SensorData');
  }
}

class SensorData {
  final int heartRate;

  SensorData({
    required this.heartRate,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      heartRate: json['heartrate'],
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<SensorData> futureSensorData;

  @override
  void initState() {
    super.initState();
    futureSensorData = fetchSensorData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Monitoring App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Heart Rate'),
        ),
        body: Center(
          child: FutureBuilder<SensorData>(
            future: futureSensorData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.heartRate.toString());
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
