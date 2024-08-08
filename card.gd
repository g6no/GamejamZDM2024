class_name Card

extends Control

@onready var hovered : bool = false
@onready var added : bool = false
@onready var num_text : Label = $Num
@onready var cur_state = State.BASE
#@onready var targets: Array[Node] = []

var parent
var index
var card_area
var dragging: bool = false
var original_position: Vector2

var points : int = 50

var threshold_time : float = 1

var can_change: bool = false

signal add_card_to_list(card: Card)
signal remove_card_from_list(card: Card)

enum State {BASE, CLICKED, DRAGGING, RELEASED}

#@onready var card_list: Array = []

## Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#print(self.name + " "+ str(can_change))


func _on_mouse_entered():
	hovered = true



func _on_mouse_exited():
	hovered = false



func _on_gui_input(event):
	var confirm = event.is_action_pressed("left_mouse")
	if event is InputEventMouseButton:
		var  threshold_timer := get_tree().create_timer(threshold_time, false)
		threshold_timer.timeout.connect(func(): can_change = true)
		if confirm and hovered and not parent.is_added(self) and cur_state == State.BASE:
			print(position)
			cur_state = State.CLICKED
			add_card_to_list.emit(self)
			added = true
			#var num = parent.get_num(self)
			#print(num)
			index = parent.get_num(self)
			print("The index is " + str(index))
			set_number(index)
			dragging = true
			original_position = position
			
		elif confirm and hovered and parent.is_added(self):
			cur_state = State.BASE
			print("Shitty Code")
			remove_card_from_list.emit(self)
			set_number("")
			dragging = false
		else:
			cur_state = State.BASE
			dragging = false
			if card_area:
				self.reparent(card_area)
				position = Vector2.ZERO
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
		num_text.text = str(num)
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
