extends Node2D

@onready var hand = $CanvasLayer/Hand
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play_turn():
	var points = 0
	for child in hand.get_children():
		points += child.points
	print("Total points = " + str(points))
	
