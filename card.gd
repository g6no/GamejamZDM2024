class_name Card

extends Control

@onready var hovered : bool = false
@onready var added : bool = false
@onready var num_text : Label = $Num
@onready var cur_state = State.BASE
@onready var card_image : TextureRect = $CardImage
@onready var description_cont : CenterContainer = $DescriptionContainter
@onready var border = $ColorBorder
@onready var card_template = $CardTemplate
@onready var descLabel = $DescriptionContainter/Description/DescLabel
@onready var sparkle = $Sparkle
#@onready var targets: Array[Node] = []
enum types {BOOSTER, INGREDIENT, DISH} 
@export var card : String
@export var card_type: types
@export var image_path : String
@export var base_points : int
@export var effect : String
@export var possible_combinations: Array
@export var description: String



var parent
var index
var card_area
#var cards = [
	#{"card": "Salt", "card_type": types.BOOSTER,"image_path": "", "base_points": 5, "effect": ""},
	#{"card": "Spice mix", "card_type": types.BOOSTER,"image_path": "", "base_points": 0, "effect": ""},  # No base points, effect modifies other cards
	#{"card": "Garlic", "card_type": types.BOOSTER,"image_path": "", "base_points": 5, "effect": ""},
	#{"card": "Oil", "card_type": types.BOOSTER,"image_path": "", "base_points": 10, "effect": ""},
	#{"card": "Chicken", "card_type": types.INGREDIENT,"image_path": "", "base_points": -10, "effect": ""},
	#{"card": "Meat", "card_type": types.INGREDIENT,"image_path": "", "base_points": -10, "effect": ""},
	#{"card": "Zubaidi", "card_type": types.INGREDIENT, "image_path": "", "base_points": -10, "effect": ""},
	#{"card": "Wheat grains", "card_type": types.INGREDIENT,"image_path": "", "base_points": -5, "effect": ""},
	#{"card": "Rice", "card_type": types.INGREDIENT,"image_path": "", "base_points": -5, "effect": ""},
	#{"card": "Onions", "card_type": types.INGREDIENT,"image_path": "", "base_points": -5, "effect": ""},
	#{"card": "Tomatoes", "card_type": types.INGREDIENT,"image_path": "", "base_points": -5, "effect": ""},
	#{"card": "Greens", "card_type": types.INGREDIENT,"image_path": "", "base_points": -5, "effect": ""},
	#{"card": "Machboos Meat", "card_type": types.DISH,"image_path": "", "base_points": 20, "effect": ""},
	#{"card": "Daqoos", "card_type": types.DISH,"image_path": "", "base_points": 15, "effect": ""},
	#{"card": "Machboos Chicken", "card_type": types.DISH,"image_path": "", "base_points": 20, "effect": ""},
	#{"card": "Mutabaq Zubaidi", "card_type": types.DISH,"image_path": "", "base_points": 20, "effect": ""},
	#{"card": "Yereesh", "card_type": types.DISH,"image_path": "", "base_points": 25, "effect": ""},
	#{"card": "Harees", "card_type": types.DISH,"image_path": "", "base_points": 25, "effect": ""},
	#{"card": "Salad", "card_type": types.DISH,"image_path": "", "base_points": 10, "effect": ""},
	#{"card": "Failed Food", "card_type": types.DISH,"image_path": "", "base_points": 2, "effect": ""},
	#{"card": "Dates", "card_type": types.BOOSTER,"image_path": "", "base_points": 15, "effect": ""}  # Bonus card, no base points when played
#]

var dragging: bool = false
var original_position: Vector2

var points : int = 50

var threshold_time : float = 1

var can_change: bool = false

signal add_card_to_list(card: Card)
signal remove_card_from_list(card: Card)

enum State {BASE, CLICKED, DRAGGING, RELEASED}

#@onready var card_list: Array = []
#func _init(card: String = "", card_type: types = types.INGREDIENT, image_path: String = "", base_points: int = 0, effect: String = "", possible_combinations: Dictionary = {}):
	#self.card = card
	#self.card_type = card_type
	#self.image_path = image_path
	#self.base_points = base_points
	#self.effect = effect
	#self.possible_combinations = possible_combinations


## Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	var image_text = load(image_path)
	card_image.texture = image_text
	
	$Text.text = card
	descLabel.text = description
	
	if card_type == types.BOOSTER:
		card_template.modulate = Color("#FF5733")
	elif card_type == types.INGREDIENT:
		card_template.modulate = Color("#56d333")
	enhance()
		#card_template.modulate = Color(76, 175, 80)
		
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#print(self.name + " "+ str(can_change))


func _on_mouse_entered():
	hovered = true
	description_cont.visible = true



func _on_mouse_exited():
	hovered = false
	description_cont.visible = false



func _on_gui_input(event):
	var confirm = event.is_action_pressed("left_mouse")
	if event is InputEventMouseButton:
		var  threshold_timer := get_tree().create_timer(threshold_time, false)
		threshold_timer.timeout.connect(func(): can_change = true)
		#print(len(parent.card_list))
		if confirm and hovered and not parent.is_added(self) and cur_state == State.BASE and len(parent.card_list) < 2:
			dragging = true
			original_position = position
			if get_parent() == parent:
				border.visible = true
				print(position)
				cur_state = State.CLICKED
				add_card_to_list.emit(self)
				added = true
				#var num = parent.get_num(self)
				#print(num)
				index = parent.get_num(self)
				print("The index is " + str(index))
				set_number(index)
			
		elif confirm and hovered and parent.is_added(self) and get_parent() == parent:
			border.visible = false
			cur_state = State.BASE
			print("Shitty Code")
			remove_card_from_list.emit(self)
			set_number("")
			dragging = false
		else:
			cur_state = State.BASE
			dragging = false
			if card_area and card_area.get_child_count() == 0:
				print("Unoccupied")
				self.reparent(card_area)
				position = Vector2.ZERO
				remove_card_from_list.emit(self)
				set_number("")
			else:
				self.reparent(parent)
				if not original_position:
					position = Vector2.ZERO
					index = parent.get_children().find(self, 0)
					position.x = 29 * index
				else:
					position = original_position
	elif event is InputEventMouseMotion and dragging:
		if parent.is_added(self) and can_change:
			print("Dragging")
			remove_card_from_list.emit(self)
			set_number("")
			can_change = false
		cur_state = State.DRAGGING
		position += event.relative

func set_number(num):
	
	if num is int:
		num_text.text = str(num+1)
	else:
		num_text.text = ""


func _on_area_2d_area_entered(area):
	#var hbox = area.get_node("CardArea")
	if area is CardDropArea:
		#print("Area Entered")
		card_area = area.get_node("CardArea")
	


func _on_card_area_area_exited(area):
	if area is CardDropArea:
		card_area = null
		#print("No Card Area")

func set_card_attributes(card_: String, card_type_: types, image_path_: String, base_points_: int, effect_: String, possible_combinations_: Array, description_ : String):
	card = card_
	card_type = card_type_
	image_path = image_path_
	base_points = base_points_
	effect = effect_
	possible_combinations = possible_combinations_
	description = description_

func set_dish_attributes(card_: String, card_type_: types, image_path_: String, base_points_: int, effect_: String, description_ : String):
	card = card_
	card_type = card_type_
	image_path = image_path_
	base_points = base_points_
	effect = effect_
	description = description_

func enhance():
	if "Super" in description: 
		sparkle.visible = true
