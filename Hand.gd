extends HBoxContainer
@onready var card_list: Array = []
var card_names: Array = []
var rng = RandomNumberGenerator.new()

const card_scene = preload("res://card.tscn")
enum types {BOOSTER, INGREDIENT, DISH} 


var boosters = [
	{"card": "Salt", "card_type": types.BOOSTER,"image_path": "res://Assets/SALT.png", "base_points": 0, "effect": "+5","possible_combinations": [], "description": "Enhances the flavor of a dish"},
	{"card": "Spice mix", "card_type": types.BOOSTER,"image_path": "res://Assets/MIX_SALT.png", "base_points": 0, "effect": "+10","possible_combinations": [],"description": "Greatly enhances the flavor of a dish"},  # No base points, effect modifies other cards
	{"card": "Garlic", "card_type": types.BOOSTER,"image_path": "res://Assets/GARLIC.png", "base_points": 0, "effect": "+5","possible_combinations": [], "description": "Enhances the flavor of a dish"},
	{"card": "Oil", "card_type": types.BOOSTER,"image_path": "res://Assets/OIL.png", "base_points": 0, "effect": "+10","possible_combinations": [], "description": "Greatly enhances the flavor of a dish"}
]
var ingredients = [
	{"card": "Chicken", "card_type": types.INGREDIENT,"image_path": "res://Assets/CHICKEN.png", "base_points": 10, "effect": "","possible_combinations": [], "description": "Base Points: 10"},
	{"card": "Meat", "card_type": types.INGREDIENT,"image_path": "res://Assets/MEAT.png", "base_points": 10, "effect": "","possible_combinations": [], "description": "Base Points: 10"},
	{"card": "Zubaidi", "card_type": types.INGREDIENT, "image_path": "res://Assets/FISH.png", "base_points": 10, "effect": "","possible_combinations": [], "description": "Base Points: 10"},
	{"card": "Wheat grains", "card_type": types.INGREDIENT,"image_path": "res://Assets/WHEAT.png", "base_points": 5, "effect": "","possible_combinations": [], "description": "Base Points: 5"},
	{"card": "Rice", "card_type": types.INGREDIENT,"image_path": "res://Assets/RICE.png", "base_points": 5, "effect": "","possible_combinations": [], "description": "Base Points: 5"},
	{"card": "Onions", "card_type": types.INGREDIENT,"image_path": "res://Assets/ONION.png", "base_points": 5, "effect": "","possible_combinations": [], "description": "Base Points: 5"},
	{"card": "Tomatoes", "card_type": types.INGREDIENT,"image_path": "res://Assets/TOMATO.png", "base_points": 5, "effect": "","possible_combinations": [], "description": "Base Points: 5"},
	#{"card": "Greens", "card_type": types.INGREDIENT,"image_path": "res://Assets/WHEAT.png", "base_points": -5, "effect": "","possible_combinations": [], "description": "Base Points: 15"},
	{"card": "Dates", "card_type": types.DISH,"image_path": "res://Assets/DATES.png", "base_points": 15, "effect": "","possible_combinations": [], "description": "Base Points: 15"}  # Bonus card, no base points when played
]



var dishes = [
	{"card": "Machboos Meat", "card_type": types.DISH,"image_path": "res://Assets/MACHBOOS_MEAT.png", "base_points": 20, "effect": "", "description": "Base Points: 15"},
	{"card": "Daqoos", "card_type": types.DISH,"image_path": "res://Assets/Daqoos.png", "base_points": 10, "effect": "1", "description": "Base Points: 10"},
	{"card": "Machboos Chicken", "card_type": types.DISH,"image_path": "res://Assets/MACHBOOS_CHICK.png", "base_points": 20, "effect": "", "description": "Base Points: 15"},
	{"card": "Mutabaq Zubaidi", "card_type": types.DISH,"image_path": "res://Assets/MACHBOOS_FISH.png", "base_points": 20, "effect": "", "description": "Base Points: 15"},
	{"card": "Yereesh", "card_type": types.DISH,"image_path": "res://Assets/Yereesh-TalebMac.png", "base_points": 25, "effect": "", "description": "Base Points: 15"},
	{"card": "Harees", "card_type": types.DISH,"image_path": "res://Assets/Harees-TalebMac.png", "base_points": 25, "effect": "", "description": "Base Points: 15"},
	#{"card": "Salad", "card_type": types.DISH,"image_path": "res://Assets/Yereesh-TalebMac.png", "base_points": 10, "effect": "", "description": "Base Points: 15"},
	{"card": "Failed Food", "card_type": types.DISH,"image_path": "res://Assets/FAILED_FOOD.png", "base_points": 2, "effect": "", "description": "Base Points: 15"},
]
#@onready var number : int = 0
#static var my_variable := true
# Called when the node enters the scene tree for the first time.
func _ready():
	draw_cards()

func draw_cards():
	var cards_to_draw = 6 - self.get_child_count()
	for i in range(cards_to_draw):
		var rand_num = rng.randi_range(0,100)
		var target_dict = ingredients if rand_num < 75 else boosters
		target_dict.shuffle()
		var ingredient = target_dict.pick_random()
		#spawn_card(i)
		spawn_ingred(ingredient)
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
	if (card_list[0].card_type == types.BOOSTER or card_list[1].card_type == types.BOOSTER) and (card_list[0].card_type != card_list[1].card_type) and not ("dates" in card_names):
		# TODO: trigger bool for effect to show on card
		var number
		var base_points
		if card_list[0].card_type == types.BOOSTER:
			base_points = card_list[1].base_points + int(card_list[0].effect[1])
			number = 1
		else:
			base_points = card_list[0].base_points + int(card_list[1].effect[1])
			number = 0
		
		if card_list[number].card_type == types.INGREDIENT:
			spawn_ingred(
					{"card":card_list[number].card , "card_type": types.INGREDIENT,"image_path": card_list[number].image_path, "base_points": base_points, "effect": "","possible_combinations": [], "description": "Super " + card_list[number].description},
			)
		elif card_list[number].card_type == types.DISH:
			make_dish(
					{"card":card_list[number].card , "card_type": types.INGREDIENT,"image_path": card_list[number].image_path, "base_points": base_points, "effect": "", "description":  "Super " + card_list[number].description},
			)
		
		#card_list[number].queue_free()
		#_on_card_add_card_to_list(card_list[0])
		#_on_card_add_card_to_list(card_list[1])
		return null
	elif (card_list[0].card == "Meat" and card_list[1].card == "Rice") or (card_list[1].card == "Meat" and card_list[0].card == "Rice"):
		return 0
	elif (card_list[0].card == "Tomatoes" and card_list[1].card == "Onions") or (card_list[1].card == "Tomatoes" and card_list[0].card == "Onions"):
		return 1
	elif (card_list[0].card == "Chicken" and card_list[1].card == "Rice") or (card_list[1].card == "Chicken" and card_list[0].card == "Rice"):
		return 2
	elif (card_list[0].card == "Zubaidi" and card_list[1].card == "Rice") or (card_list[1].card == "Zubaidi" and card_list[0].card == "Rice"):
		return 3
	elif (card_list[0].card == "Chicken" and card_list[1].card == "Wheat grains") or (card_list[1].card == "Chicken" and card_list[0].card == "Wheat grains"):
		return 4
	elif (card_list[0].card == "Meat" and card_list[1].card == "Wheat grains") or (card_list[1].card == "Meat" and card_list[0].card == "Wheat grains"):
		return 5
	else:
		return 6
		
func check_index():
	for child in get_children():
		if get_num(child) != child.index:
			child.index = get_num(child)
			child.set_number(child.index)
			
func combine_cards():
	if len(card_list) == 2:
		var new_card_index = check_combinations()
		for card in card_list:
			card.queue_free()
		card_list.clear()
		if new_card_index == null:
			return
		spawn_dish(new_card_index)
	
func _on_combine_pressed():
	combine_cards()
#func set_card_attributes(card_: String, card_type_: 
	#types, image_path_: String, base_points_: int, 
	#effect_: String, possible_combinations_: Dictionary, 
	#description_ : String):
#func spawn_card(i):
	#var new_card = card_scene.instantiate()
	#new_card.add_card_to_list.connect(_on_card_add_card_to_list)
	#new_card.remove_card_from_list.connect(_on_card_remove_card_from_list)
	#new_card.set_card_attributes(
		#ingredients[i]["card"], 
		#ingredients[i]["card_type"], 
		#ingredients[i]["image_path"], 
		#ingredients[i]["base_points"], 
		#ingredients[i]["effect"], 
		#ingredients[i]["possible_combinations"],
		#ingredients[i]["description"],
	#)
	#self.add_child(new_card)
	#print(new_card.image_path)


func spawn_ingred(ingredient):
	var new_card = card_scene.instantiate()
	new_card.add_card_to_list.connect(_on_card_add_card_to_list)
	new_card.remove_card_from_list.connect(_on_card_remove_card_from_list)
	new_card.set_card_attributes(
		ingredient["card"], 
		ingredient["card_type"], 
		ingredient["image_path"], 
		ingredient["base_points"], 
		ingredient["effect"], 
		ingredient["possible_combinations"],
		ingredient ["description"],
	)
	self.add_child(new_card)
	print(new_card.image_path)
	
	
func make_dish(ingredient):
	var new_card = card_scene.instantiate()
	new_card.add_card_to_list.connect(_on_card_add_card_to_list)
	new_card.remove_card_from_list.connect(_on_card_remove_card_from_list)
	new_card.set_dish_attributes(
		ingredient["card"], 
		types.DISH, 
		ingredient["image_path"], 
		ingredient["base_points"], 
		ingredient["effect"], 
		ingredient ["description"],
	)
	self.add_child(new_card)
	print(new_card.image_path)

func spawn_dish(i):
	var new_card = card_scene.instantiate()
	new_card.add_card_to_list.connect(_on_card_add_card_to_list)
	new_card.remove_card_from_list.connect(_on_card_remove_card_from_list)
	new_card.set_dish_attributes(
		dishes[i]["card"], 
		dishes[i]["card_type"], 
		dishes[i]["image_path"], 
		dishes[i]["base_points"], 
		dishes[i]["effect"], 
		dishes[i]["description"],
	)
	self.add_child(new_card)
	print(new_card.image_path)

