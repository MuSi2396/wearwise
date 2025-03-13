from flask import Flask
from routes.auth_routes import auth_routes
from routes.recommendation_routes import recommendation_routes
from routes.upload_routes import upload_routes
from routes.weather_routes import weather_routes

app = Flask(__name__)

# Register all routes
app.register_blueprint(auth_routes, url_prefix="/api/auth")
app.register_blueprint(recommendation_routes, url_prefix="/api/recommend")
app.register_blueprint(upload_routes, url_prefix="/api/upload")
app.register_blueprint(weather_routes, url_prefix="/api/weather")

@app.route("/")
def home():
    return {"message": "Backend is running!"}

if __name__ == "__main__":
    app.run(debug=True)
