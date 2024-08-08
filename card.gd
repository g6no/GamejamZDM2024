class_name Card

extends Control

@onready var hovered : bool = false
@onready var added : bool = false

@onready var num_text : Label = $Num
var parent
var index
signal add_card_to_list(card: Card)
signal remove_card_from_list(card: Card)
#@onready var card_list: Array = []

## Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func _on_mouse_entered():
	hovered = true
	print("Changed to True")


func _on_mouse_exited():
	hovered = false
	print("Changed to False")


func _on_gui_input(event):
	var confirm = event.is_action_pressed("left_mouse")
	
	if confirm and hovered and not parent.is_added(self):
		add_card_to_list.emit(self)
		added = true
		#var num = parent.get_num(self)
		#print(num)
		index = parent.get_num(self)
		print("The index is " + str(index))
		set_number(index)
	elif confirm and hovered and parent.is_added(self):
		remove_card_from_list.emit(self)
		set_number("")

func set_number(num):
	if num is int:
		num_text.text = str(num)
	else:
		num_text.text = ""
