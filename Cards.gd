extends Node
class_name Cards

enum types {BOOSTER, INGREDIENT, DISH} 
@export var card : String
@export var card_type: types
@export var image_path : String
@export var base_points : int
@export var effect : String
@export var possible_combinations: Dictionary

func _init(card: String = "", card_type: types = types.INGREDIENT, image_path: String = "", base_points: int = 0, effect: String = "", possible_combinations: Dictionary = {}):
	self.card = card
	self.card_type = card_type
	self.image_path = image_path
	self.base_points = base_points
	self.effect = effect
	self.possible_combinations = possible_combinations

func _ready():
	var image_text = load(self.image_path)
	$CardImage.texture = image_text
	
	
