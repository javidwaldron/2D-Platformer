extends Control


func _on_start_game_pressed():
	get_tree().change_scene_to_file("res://game_singleplayer.tscn")








func _on_continue_pressed() -> void:
	pass # Replace with function body.








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
