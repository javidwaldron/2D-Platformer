extends Control

# I know this makes no sense and the placement is weird , just go with me on it, just taking advantage of globals

var  currentcoin = 0
var is_pause:= false
var currentspeed:= 60

func _process(delta):
	
	if  currentcoin == null:
		currentcoin = 0
	
