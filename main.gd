extends Node2D

@onready var card_drop1 = $CardDropArea/CardArea
@onready var card_drop2 = $CardDropArea2/CardArea
@onready var card_drop3 = $CardDropArea3/CardArea
@onready var hand = $CanvasLayer/Hand
@onready var points_text = $CanvasLayer/PointsValue
@onready var turn_value = $CanvasLayer/TurnValue
@onready var level_value = $CanvasLayer/LevelValue
@onready var score_value = $CanvasLayer/ScoreValue
@onready var level_image = $CanvasLayer/LevelImage

var path_to_mama_noura = "res://MAMA-NOURA.PNG"

var point_total = 0
var turn_count = 0
var cur_level = 1
var score_to_beat = 60
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
	
	if turn_count < 3:
		var card_area = [card_drop1, card_drop2, card_drop3]
		
		for card in card_area:
			if card.get_child_count() == 1:
				point_total += card.get_child(0).base_points
				points_text.text = str(point_total)
				hand._on_card_remove_card_from_list(card.get_child(0))
				card.get_child(0).queue_free()
				await get_tree().create_timer(0.3).timeout
		
		for card in card_area:
			print(card.get_children())
		print(point_total)
		print(len(hand.card_list))
		await get_tree().create_timer(2).timeout
		
		hand.draw_cards()
		turn_count += 1
		turn_value.text = str(turn_count+1)+"/3"
		if turn_count >= 3:
			play_turn()
		if cur_level == 2:
			score_to_beat = 100
		score_value.text = str(score_to_beat)
	else:
		if point_total > score_to_beat:
			print("You win!")
			cur_level += 1
			level_value.text = str(cur_level)
			var level_img = load(path_to_mama_noura)
			level_image.texture = level_img
			
		else:
			print("Kl Zag")
		turn_count = 0
		turn_value.text = str(turn_count+1)+"/3"
	
	#var points = 0
	#for child in hand.get_children():
		#points += child.points
	#print("Total points = " + str(points))


func spawn_card_in_hand():
	$CanvasLayer/Hand.spawn_card()
