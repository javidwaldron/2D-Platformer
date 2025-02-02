class_name PauseMenu extends Control


@export var fade_in_duration := 0.3
@export var fade_out_duration := 0.2

@onready var center_cont := $ColorRect/CenterContainer as CenterContainer
@onready var resume_button := center_cont.get_node(^"VBoxContainer/ResumeButton") as Button
@onready var coins_counter := $ColorRect/CoinsCounter as CoinsCounter
@onready var save_button := center_cont.get_node(^"VBoxContainer/SaveButton") as Button
@onready var timer = %Timer

func _ready() -> void:
	hide()


func close() -> void:
	timer.paused = false
	CoinsRemaining.is_pause = false
	var tween := create_tween()
	get_tree().paused = false
	tween.tween_property(
		self,
		^"modulate:a",
		0.0,
		fade_out_duration
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(
		center_cont,
		^"anchor_bottom",
		0.5,
		fade_out_duration
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_callback(hide)


func open() -> void:
	show()
	timer.paused = true
	resume_button.grab_focus()
	CoinsRemaining.is_pause = true
	modulate.a = 0.0
	center_cont.anchor_bottom = 0.5
	var tween := create_tween()
	tween.tween_property(
		self,
		^"modulate:a",
		1.0,
		fade_in_duration
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(
		center_cont,
		^"anchor_bottom",
		1.0,
		fade_out_duration
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	

func _on_coin_collected() -> void:
	coins_counter.collect_coin()


func _on_resume_button_pressed() -> void:
	close()
	


#func _on_singleplayer_button_pressed() -> void:
#	if visible:
#		get_tree().paused = false
#		get_tree().change_scene_to_file("res://game_singleplayer.tscn")


#func _on_splitscreen_button_pressed() -> void:
#	if visible:
#		get_tree().paused = false
#		get_tree().change_scene_to_file("res://game_splitscreen.tscn")

func _on_save_button_pressed() -> void:
	save_game()
	print("saved?")
	
func _on_quit_button_pressed() -> void:
	if visible:
		coins_counter._coins_collected =  CoinsRemaining.currentcoin
		get_tree().paused = false
		get_tree().change_scene_to_file("res://main_menu.tscn")

func save_game():
	var save_path = "user://savegame.json"
	var player = get_node_or_null("%Player") 
	var player_position = player.global_position if player else Vector2.ZERO
	var coins = CoinsRemaining.currentcoin
	var current_level = get_tree().current_scene.name
	
	var save_data = {
		"player_position": {"x": player_position.x, "y": player_position.y},
		"coins": coins,
		"level": {
			"name": current_level,
			"coins_collected": coins
},
	}
	var json_string = JSON.stringify(save_data)
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(json_string)
	file.close()
	print("Game saved successfully!")
	print("Save file path:", ProjectSettings.globalize_path(save_path))
