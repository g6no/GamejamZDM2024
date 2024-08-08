extends HBoxContainer
@onready var card_list: Array = []
const card_scene = preload("res://card.tscn")
#@onready var number : int = 0
#static var my_variable := true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#for child in get_children():
		#if child in card_list:
			#var index = card_list.find(child,0)
			#child.set_number(index)


func _on_card_add_card_to_list(card):
	print("Added card")
	card_list.append(card)
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

func check_index():
	for child in get_children():
		if get_num(child) != child.index:
			child.index = get_num(child)
			child.set_number(child.index)
			
func combine_cards():
	for card in card_list:
		card.queue_free()
	card_list.clear()
	var new_card = card_scene.instantiate()
	add_child(new_card)
	
func _on_combine_pressed():
	combine_cards()
