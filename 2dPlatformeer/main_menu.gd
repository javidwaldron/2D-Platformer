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
		print("No save file found at:", ProjectSettings.globalize_path(save_path))
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
	
	if "player" in save_data and "level" in save_data:
		var player = get_tree().get_root().find_child("Player", true, false)
		if player:
			var pos_x = save_data["player"]["position"]["x"]
			var pos_y = save_data["player"]["position"]["y"]
			player.global_position = Vector2(pos_x, pos_y)
			CoinsRemaining.currentcoin = save_data["player"]["coins"]
			print("Coins loaded:", CoinsRemaining.currentcoin)
		else:
			print("Player node not found in the scene tree!")
		#var scene_path = "res://" + save_data["level"]["name"] + ".tscn"
		var scene_path = "res://" + "game_splitscreen" + ".tscn"
		if ResourceLoader.exists(scene_path):
			get_tree().change_scene_to_file(scene_path)
			print("Scene changed to:", scene_path)
		else:
			print("Error: Scene file not found at:", scene_path)
		
		print("Game loaded successfully from:", ProjectSettings.globalize_path(save_path))
	else:
		print("Invalid save data structure.")
	
