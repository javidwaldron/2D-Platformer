class_name Enemy extends CharacterBody2D


enum State { WALKING, DEAD }


var pickup1 = preload("res://Items/pickup_small.tscn")
var pickup2 = preload("res://Items/pickup_medium.tscn")
var pickup3 = preload("res://Items/pickup_large.tscn")

var attackorbleft = preload("res://enemy/enemy_orbleft.tscn")
var attackorbright = preload("res://enemy/enemy_orbright.tscn")

@onready var timer = $Timer
@onready var attacktimer = $AttackTimer
@onready var fireleft
@onready var fireright
 
const WALK_SPEED = 22.0


var _state := State.WALKING

@onready var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
@onready var platform_detector := $PlatformDetector as RayCast2D
@onready var floor_detector_left := $FloorDetectorLeft as RayCast2D
@onready var floor_detector_right := $FloorDetectorRight as RayCast2D
@onready var sprite := $Sprite2D as Sprite2D
@onready var animation_player := $AnimationPlayer as AnimationPlayer

@onready var ray_cast_player_left: RayCast2D = $RayCastPlayerLeft
@onready var ray_cast_player_right: RayCast2D = $RayCastPlayerRight

func _process(delta):
	
	
	if ray_cast_player_left.is_colliding():
		fireleft = true
	elif ray_cast_player_right.is_colliding():
		fireright = true
		
	
	if fireleft == true:
		
		ray_cast_player_left.enabled = false
		attacktimer.start()
		fireleft = false
		
	if fireright == true:
		
		ray_cast_player_right.enabled = false
		attacktimer.start()
		fireright = false




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
	attacktimer.stop()
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


func _on_attack_timer_timeout():
	if ray_cast_player_left.enabled == false:
		var instance = attackorbright.instantiate()
		add_child(instance)
	
	if ray_cast_player_right.enabled == false:
		var instance = attackorbleft.instantiate()
		add_child(instance)
		
	ray_cast_player_left.enabled = true
	ray_cast_player_right.enabled = true
	
	attacktimer.stop()
	
