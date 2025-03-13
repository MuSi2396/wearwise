import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class WeatherService {
  static const String apiKey = 'a9fd2c3951787db0db37d5e7a21631fb'; // Replace with your actual API key
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  // Fetch weather data based on user's current location
  Future<Map<String, dynamic>> getWeather(Position position) async {
  final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric');

  print('Requesting: $url'); // Debugging line

  try {
    final response = await http.get(url);
    print('Response Code: ${response.statusCode}'); // Debugging line
    print('Response Body: ${response.body}'); // Debugging line


      if (response.statusCode == 200) {
        Map<String, dynamic> weatherData = json.decode(response.body);
        print('Weather API Response: $weatherData'); // Debugging Response

        if (weatherData.containsKey('main') && weatherData['main'].containsKey('temp')) {
          return weatherData;
        } else {
          throw Exception('Unexpected API response format. Missing required weather data.');
        }
      } else {
        throw Exception('HTTP Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Network error: Unable to fetch weather data. Error: $e');
    }
  }

  // Get the current location of the user
  Future<Position> getCurrentLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw Exception('Location services are disabled. Please enable them in settings.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied. Please allow access.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permission permanently denied. Enable it from app settings.');
      }

      return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      throw Exception('Error retrieving location: $e');
    }
  }
}
