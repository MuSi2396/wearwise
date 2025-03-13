from flask import Blueprint, request, jsonify
import requests

weather_routes = Blueprint("weather_routes", __name__)

API_KEY = "your_openweather_api_key"

@weather_routes.route("/", methods=["GET"])
def get_weather():
    location = request.args.get("location")
    if not location:
        return jsonify({"message": "Location required"}), 400

    url = f"http://api.openweathermap.org/data/2.5/weather?q={location}&appid={APIa9fd2c3951787db0db37d5e7a21631fb}&units=metric"
    response = requests.get(url)

    if response.status_code != 200:
        return jsonify({"message": "Invalid location"}), 404

    data = response.json()
    temp = data["main"]["temp"]

    outfit = "Wear a warm jacket." if temp < 15 else "Wear a T-shirt."
    return jsonify({"location": location, "temperature": f"{temp}°C", "suggested_outfit": outfit})
