import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherInfoCard extends StatefulWidget {
  @override
  _WeatherInfoCardState createState() => _WeatherInfoCardState();
}

class _WeatherInfoCardState extends State<WeatherInfoCard> {
  String city = 'Jember'; // Default city
  String temperature = 'Loading...';

  TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchWeatherData(city);
    initializeDateFormatting();
  }

  Future<void> fetchWeatherData(String cityName) async {
    final response = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?q=$cityName&units=metric&appid=435f8a127a73b6d1c8b653631a472154'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        city = data['name'];
        temperature = '${data['main']['temp']}°C';
      });
    } else {
      setState(() {
        city = 'Error';
        temperature = 'Error';
      });
    }
  }

  String getCurrentDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('EEEE, d MMM', 'id_ID');
    return formatter.format(now);
  }

  String get currentTemperature => temperature;
  // Getter currentTemperature

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 204,
      height: 82,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    hintText: 'Enter city name',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isCollapsed: true, // untuk menghilangkan margin
                  ),
                  onFieldSubmitted: (value) {
                    setState(() {
                      city = value;
                      fetchWeatherData(city);
                    });
                  },
                ),
                Text(
                  getCurrentDate(),
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Text(
            temperature,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}
