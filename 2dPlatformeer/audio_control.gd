extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/HSlider.value  = db_to_linear(AudioServer.get_bus_volume_db(0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_h_slider_mouse_exited():
	release_focus()
