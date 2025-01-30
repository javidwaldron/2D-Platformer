extends Control


func _on_start_game_pressed():
	get_tree().change_scene_to_file("res://game_singleplayer.tscn")








func _on_continue_pressed() -> void:
	load_game()








func _on_controls_pressed():
	$CanvasLayer/InputSettings.visible = true
	$MarginContainer.visible = false







func _on_settings_pressed():
	$CanvasLayer/SettingsUI.visible = true
	$MarginContainer.visible = false
	











func _on_delete_save_pressed() -> void:
	pass # Replace with function body.










func _on_exit_game_pressed():
	get_tree().quit()

func load_game():
	var save_path = "user://savegame.json"  
	if not FileAccess.file_exists(save_path):
		print("No save file found!")
		return
		
	var file = FileAccess.open(save_path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()

	var json = JSON.new()
	var parse_result = json.parse(content)
	
	if parse_result != OK:
		print("Failed to parse save file.")
		return
		
	var save_data = json.data
	
	var player = get_node_or_null("%Player") 
	if player and save_data.has("player_position"):
		var pos = save_data["player_position"]
		player.global_position = Vector2(pos["x"], pos["y"])
		print("Loaded player position:", player.global_position)
	else:
		print("Player node or position data missing!")
		
	var coins_node = get_node_or_null("ColorRect/CoinsCounter") 
	if coins_node and save_data.has("coins"):
		coins_node.currentcoin = save_data["coins"]
		print("Loaded coins:", coins_node.currentcoin)
	else:
		print("CoinsRemaining node or coin data missing!")
		
	if save_data.has("level"):
		var level_name = save_data["level"].get("name", "")
		var current_scene = get_tree().current_scene.name
		get_tree().change_scene_to_file("res://game_singleplayer.tscn")
	print("Game loaded successfully!")
	
