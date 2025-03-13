import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
 import 'package:wearwise/services/weather_service.dart';

 // Import the WeatherService

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService weatherService = WeatherService();
  Future<Map<String, dynamic>>? weatherFuture;

  @override
  void initState() {
    super.initState();
    weatherFuture = fetchWeather();
  }

  Future<Map<String, dynamic>> fetchWeather() async {
    try {
      Position position = await weatherService.getCurrentLocation();
      return await weatherService.getWeather(position);
    } catch (e) {
      return {'error': e.toString()}; // Handle errors gracefully
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Weather App")),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: weatherFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Show loading indicator
            } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.containsKey('error')) {
              return Text(
                "Error: ${snapshot.data?['error'] ?? 'Could not fetch weather data'}",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red, fontSize: 18),
              );
            }

            // Extract weather details
            Map<String, dynamic> weatherData = snapshot.data!;
            String location = weatherData['name'];
            String temperature = "${weatherData['main']['temp']}°C";
            String description = weatherData['weather'][0]['description'];

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  location,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  temperature,
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  description,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
