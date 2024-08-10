extends Node2D

@onready var card_drop1 = $CardDropArea/CardArea
@onready var card_drop2 = $CardDropArea2/CardArea
@onready var card_drop3 = $CardDropArea3/CardArea

var point_total = 0


#@onready var hand = $CanvasLayer/Hand
#const card_scene = preload("res://card.tscn")
## Called when the node enters the scene tree for the first time.
#func _ready():
	#pass
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func play_turn():
	var card_area = [card_drop1, card_drop2, card_drop3]
	
	for card in card_area:
		if card.get_child_count() == 1:
			point_total += card.get_child(0).base_points
			# Do Effect
	print(point_total)
			
	
	#var points = 0
	#for child in hand.get_children():
		#points += child.points
	#print("Total points = " + str(points))


func spawn_card_in_hand():
	$CanvasLayer/Hand.spawn_card()
