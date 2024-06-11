import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherIconWidget extends StatefulWidget {
  final String cityName;

  const WeatherIconWidget({Key? key, required this.cityName}) : super(key: key);

  @override
  _WeatherIconWidgetState createState() => _WeatherIconWidgetState();
}

class _WeatherIconWidgetState extends State<WeatherIconWidget> {
  late Future<String> futureWeatherIcon;

  @override
  void initState() {
    super.initState();
    futureWeatherIcon = fetchWeatherIcon();
  }

  Future<String> fetchWeatherIcon() async {
    final response = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?q=${widget.cityName}&units=metric&appid=435f8a127a73b6d1c8b653631a472154'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final iconCode = data['weather'][0]['icon'];
      return iconCode;
    } else {
      throw Exception('Failed to load weather icon');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: futureWeatherIcon,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          String iconUrl =
              'http://openweathermap.org/img/wn/${snapshot.data!}@2x.png';
          return Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              gradient: RadialGradient(
                colors: [
                  const Color.fromARGB(198, 33, 149, 243),
                  Color.fromARGB(255, 255, 255, 255)
                ],
                center: Alignment.center,
                radius: 0.54,
                focal: Alignment.center,
                focalRadius: 0.2,
              ),
            ),
            child: Image.network(iconUrl),
          );
        } else {
          return Text('No data available');
        }
      },
    );
  }

  @override
  void didUpdateWidget(covariant WeatherIconWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cityName != oldWidget.cityName) {
      setState(() {
        futureWeatherIcon = fetchWeatherIcon();
      });
    }
  }
}
