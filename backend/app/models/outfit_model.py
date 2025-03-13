class Outfit:
    def __init__(self, user_id, outfit_items, weather_condition):
        self.user_id = user_id
        self.outfit_items = outfit_items
        self.weather_condition = weather_condition

    def to_dict(self):
        return {"user_id": self.user_id, "outfit_items": self.outfit_items, "weather_condition": self.weather_condition}
