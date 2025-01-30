class_name Enemy extends CharacterBody2D


enum State {
	WALKING,
	DEAD,
}


var pickup1 = preload("res://Items/pickup_small.tscn")
var pickup2 = preload("res://Items/pickup_medium.tscn")
var pickup3 = preload("res://Items/pickup_large.tscn")

@onready var timer = $Timer

const WALK_SPEED = 22.0

var _state := State.WALKING

@onready var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
@onready var platform_detector := $PlatformDetector as RayCast2D
@onready var floor_detector_left := $FloorDetectorLeft as RayCast2D
@onready var floor_detector_right := $FloorDetectorRight as RayCast2D
@onready var sprite := $Sprite2D as Sprite2D
@onready var animation_player := $AnimationPlayer as AnimationPlayer


func _physics_process(delta: float) -> void:
	if _state == State.WALKING and velocity.is_zero_approx():
		velocity.x = WALK_SPEED
	velocity.y += gravity * delta
	if not floor_detector_left.is_colliding():
		velocity.x = WALK_SPEED
	elif not floor_detector_right.is_colliding():
		velocity.x = -WALK_SPEED

	if is_on_wall():
		velocity.x = -velocity.x

	move_and_slide()

	if velocity.x > 0.0:
		sprite.scale.x = 0.8
	elif velocity.x < 0.0:
		sprite.scale.x = -0.8

	var animation := get_new_animation()
	if animation != animation_player.current_animation:
		animation_player.play(animation)


func destroy() -> void:
	_state = State.DEAD
	
	velocity = Vector2.ZERO
	timer.start()


func get_new_animation() -> StringName:
	var animation_new: StringName
	if _state == State.WALKING:
		if velocity.x == 0:
			animation_new = &"idle"
		else:
			animation_new = &"walk"
	else:
		animation_new = &"destroy"
	return animation_new

func itemdrop():
	invisibleforwait()
	var itemchoice = randi_range(0,2)
	
	match itemchoice:
		0:
			var instance = pickup1.instantiate()
			add_child(instance)
		1:
			var instance = pickup2.instantiate()
			add_child(instance)
		2:
			var instance = pickup3.instantiate()
			add_child(instance)
			
			

func invisibleforwait():
	$Sprite2D.visible =false
	$AnimationPlayer.active =false


func _on_timer_timeout():
	print("ding")
	queue_free()
