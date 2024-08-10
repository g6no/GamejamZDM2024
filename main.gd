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
@onready var panel = $CanvasLayer/Panel
@onready var colorRect = $MainMenu/ColorRect
@onready var buttons = $MainMenu/VBoxContainer
@onready var win_lose = $MainMenu/WinLose

@onready var main_menu = $MainMenu

@onready var ui = $CanvasLayer
@onready var card_drop_area_1 = $CardDropArea
@onready var card_drop_area_2 = $CardDropArea2
@onready var card_drop_area_3 = $CardDropArea3
#@onready var daqoos_bonus_text = $CanvasLayer/DaqoosBonus

var path_to_mama_noura = "res://MAMA-NOURA.PNG"

var point_total = 0
var turn_count = 0
var cur_level = 1
var score_to_beat = 60
var card_names = []
#@onready var hand = $CanvasLayer/Hand
#const card_scene = preload("res://card.tscn")
## Called when the node enters the scene tree for the first time.
#func _ready():
	#hand.process_mode = 0
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func play_turn():
	var card_area = [card_drop1, card_drop2, card_drop3]
		
		
	if turn_count < 3:
		
		var rice_dishes = ["Machboos Meat", "Machboos Chicken", "Mutabaq Zubaidi"]
		
		for card in card_area:
			if card.get_child_count() == 1:
				card_names.append(card.get_child(0).card)
				point_total += card.get_child(0).base_points
				points_text.text = str(point_total)
				hand._on_card_remove_card_from_list(card.get_child(0))
				card.get_child(0).queue_free()
				await get_tree().create_timer(0.3).timeout
		var has_rice = false
		for rice in rice_dishes:
			if rice in card_names:
				has_rice = true
		if "Daqoos" in card_names and has_rice and cur_level == 2:
			point_total += 30
		#for card in card_area:
			#print(card.get_children())
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
			if cur_level == 2:
				show_win("You win!")
			else:
				panel.visible = true
			print("You win!")
			point_total = 0
			cur_level += 1
			level_value.text = "Level: " + str(cur_level)
			var level_img = load(path_to_mama_noura)
			level_image.texture = level_img
		else:
			if cur_level == 2:
				show_win("You lose :()")
		turn_count = 0
		turn_value.text = str(turn_count+1)+"/3"
	
	#var points = 0
	#for child in hand.get_children():
		#points += child.points
	#print("Total points = " + str(points))


func spawn_card_in_hand():
	$CanvasLayer/Hand.spawn_card()


func _on_start_game_pressed():
	ui.visible = true
	card_drop_area_1.visible = true
	card_drop_area_2.visible = true
	card_drop_area_3.visible = true
	#hand.process_mode = 4
	hand.draw_cards()
	hand.first_call = false
	
	main_menu.visible = false
	$BGMusic.play()
	

func hide_panel():
	panel.visible = false

func show_win(text):
	main_menu.visible = true
	buttons.visible = false
	colorRect.visible = true
	win_lose.visible = true
	win_lose.text = text
