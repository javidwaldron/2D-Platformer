extends Node2D

@onready var timer = $Timer
var speed = 100
var arewepaused
#this part may need to be reconfigured or dropped see if it works first

func _ready():
	timer.start()
	
	
func _process(delta):
	arewepaused = CoinsRemaining.is_pause
		
	if arewepaused == false:
		position.x -= speed * delta
		timer.paused = false
		
	if arewepaused == true:
		timer.paused = true

func _on_area_2d_body_entered(body):
	if body is Player:
		body.health_up(-30)
		queue_free()



func _on_timer_timeout():
	print("and boom goes the dynamite")
	queue_free()
