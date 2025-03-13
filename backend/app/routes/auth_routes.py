from flask import Blueprint, request, jsonify

auth_routes = Blueprint("auth_routes", __name__)

users = {}  # Temporary storage instead of a database

@auth_routes.route("/signup", methods=["POST"])
def signup():
    data = request.get_json()
    email = data.get("email")
    if email in users:
        return jsonify({"message": "User already exists"}), 400
    users[email] = data
    return jsonify({"message": "User created successfully!"}), 201

@auth_routes.route("/login", methods=["POST"])
def login():
    data = request.get_json()
    email = data.get("email")
    password = data.get("password")
    if email in users and users[email]["password"] == password:
        return jsonify({"message": "Login successful!"}), 200
    return jsonify({"message": "Invalid credentials"}), 401
