from flask import Blueprint

auth_routes = Blueprint('auth_routes', __name__)
recommendation_routes = Blueprint('recommendation_routes', __name__)
upload_routes = Blueprint('upload_routes', __name__)
weather_routes = Blueprint('weather_routes', __name__)

from . import auth_routes, recommendation_routes, upload_routes, weather_routes
