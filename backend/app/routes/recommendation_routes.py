from flask import Blueprint, request, jsonify

recommendation_routes = Blueprint("recommendation_routes", __name__)

outfits = {
    "new@example.com": [
        {"top": "Blue Shirt", "bottom": "Black Jeans"},
        {"top": "White T-Shirt", "bottom": "Grey Shorts"}
    ]
}

@recommendation_routes.route("/", methods=["GET"])
def get_recommendation():
    email = request.args.get("email")
    if email in outfits:
        return jsonify({"outfits": outfits[email]}), 200
    return jsonify({"message": "User not found"}), 404
