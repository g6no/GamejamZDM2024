extends HBoxContainer
@onready var card_list: Array = []
var card_names: Array = []

const card_scene = preload("res://card.tscn")
enum types {BOOSTER, INGREDIENT, DISH} 
var ingredients = [
	{"card": "Salt", "card_type": types.BOOSTER,"image_path": "", "base_points": 5, "effect": "","possible_combinations": [], "description": "Base Points: 15"},
	{"card": "Spice mix", "card_type": types.BOOSTER,"image_path": "", "base_points": 0, "effect": "","possible_combinations": [],"description": "Base Points: 15"},  # No base points, effect modifies other cards
	{"card": "Garlic", "card_type": types.BOOSTER,"image_path": "", "base_points": 5, "effect": "","possible_combinations": [], "description": "Base Points: 15"},
	{"card": "Oil", "card_type": types.BOOSTER,"image_path": "", "base_points": 10, "effect": "","possible_combinations": [], "description": "Base Points: 15"},
	{"card": "Chicken", "card_type": types.INGREDIENT,"image_path": "", "base_points": -10, "effect": "","possible_combinations": [], "description": "Base Points: 15"},
	{"card": "Meat", "card_type": types.INGREDIENT,"image_path": "", "base_points": -10, "effect": "","possible_combinations": [], "description": "Base Points: 15"},
	{"card": "Zubaidi", "card_type": types.INGREDIENT, "image_path": "", "base_points": -10, "effect": "","possible_combinations": [], "description": "Base Points: 15"},
	{"card": "Wheat grains", "card_type": types.INGREDIENT,"image_path": "", "base_points": -5, "effect": "","possible_combinations": [], "description": "Base Points: 15"},
	{"card": "Rice", "card_type": types.INGREDIENT,"image_path": "", "base_points": -5, "effect": "","possible_combinations": [], "description": "Base Points: 15"},
	{"card": "Onions", "card_type": types.INGREDIENT,"image_path": "", "base_points": -5, "effect": "","possible_combinations": [], "description": "Base Points: 15"},
	{"card": "Tomatoes", "card_type": types.INGREDIENT,"image_path": "", "base_points": -5, "effect": "","possible_combinations": [], "description": "Base Points: 15"},
	{"card": "Greens", "card_type": types.INGREDIENT,"image_path": "", "base_points": -5, "effect": "","possible_combinations": [], "description": "Base Points: 15"},
	{"card": "Dates", "card_type": types.DISH,"image_path": "", "base_points": 15, "effect": "","possible_combinations": [], "description": "Base Points: 15"}  # Bonus card, no base points when played
]

var dishes = [
	{"card": "Machboos Meat", "card_type": types.DISH,"image_path": "", "base_points": 20, "effect": "", "description": "Base Points: 15"},
	{"card": "Daqoos", "card_type": types.DISH,"image_path": "", "base_points": 15, "effect": "", "description": "Base Points: 15"},
	{"card": "Machboos Chicken", "card_type": types.DISH,"image_path": "", "base_points": 20, "effect": "", "description": "Base Points: 15"},
	{"card": "Mutabaq Zubaidi", "card_type": types.DISH,"image_path": "", "base_points": 20, "effect": "", "description": "Base Points: 15"},
	{"card": "Yereesh", "card_type": types.DISH,"image_path": "", "base_points": 25, "effect": "", "description": "Base Points: 15"},
	{"card": "Harees", "card_type": types.DISH,"image_path": "", "base_points": 25, "effect": "", "description": "Base Points: 15"},
	{"card": "Salad", "card_type": types.DISH,"image_path": "", "base_points": 10, "effect": "", "description": "Base Points: 15"},
	{"card": "Failed Food", "card_type": types.DISH,"image_path": "", "base_points": 2, "effect": "", "description": "Base Points: 15"},
]
#@onready var number : int = 0
#static var my_variable := true
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(6):
		var ingredient = ingredients.pick_random()
		print(ingredient)
		spawn_card(i)
		await get_tree().create_timer(0.5).timeout



## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#print(get_children())
	#for child in get_children():
		#if child in card_list:
			#var index = card_list.find(child,0)
			#child.set_number(index)


func _on_card_add_card_to_list(card):
	print("Added card")
	card_list.append(card)
	card_names.append(card.card)
	print(card_names)
	print(card_list)

func get_num(card):
	if card in card_list:
		#print("Thingy")
		var index = card_list.find(card,0)
		return index

func is_added(card):
	return card in card_list

func _on_card_remove_card_from_list(card):
	card_list.erase(card)
	print("Card removed")
	check_index()

func check_combinations():
	if card_list[0].card_type == types.BOOSTER or card_list[0].card_type == types.BOOSTER and (card_list[0].card_type != card_list[1].card_type != types.BOOSTER) and not ("dates" in card_names):
		pass
		
func check_index():
	for child in get_children():
		if get_num(child) != child.index:
			child.index = get_num(child)
			child.set_number(child.index)
			
func combine_cards():
	if len(card_list) == 2:
		for card in card_list:
			card.queue_free()
		card_list.clear()
		var new_card = card_scene.instantiate()
		new_card.add_card_to_list.connect(_on_card_add_card_to_list)
		new_card.remove_card_from_list.connect(_on_card_remove_card_from_list)
		self.add_child(new_card)
	
func _on_combine_pressed():
	combine_cards()
#func set_card_attributes(card_: String, card_type_: 
	#types, image_path_: String, base_points_: int, 
	#effect_: String, possible_combinations_: Dictionary, 
	#description_ : String):
func spawn_card(i):
	var new_card = card_scene.instantiate()
	new_card.add_card_to_list.connect(_on_card_add_card_to_list)
	new_card.remove_card_from_list.connect(_on_card_remove_card_from_list)
	new_card.set_card_attributes(
		ingredients[i]["card"], 
		ingredients[i]["card_type"], 
		ingredients[i]["image_path"], 
		ingredients[i]["base_points"], 
		ingredients[i]["effect"], 
		ingredients[i]["possible_combinations"],
		ingredients[i]["description"],
	)
	self.add_child(new_card)

