extends Control

var  fullscreen = false


func _on_confirm_pressed():
	AudioServer.set_bus_volume_db(0, linear_to_db($PanelContainer/MarginContainer/AudioControl/VBoxContainer/HSlider.value))
	if fullscreen == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif fullscreen == false:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_back_pressed():
	$"../../MarginContainer".visible = true
	$".".visible = false


func _on_check_button_toggled(button_pressed):
	if button_pressed == true:
		fullscreen = true
	else:
		fullscreen = false
