class_name CoinsCounter extends Panel

@export var quest_manager: Node

var _coins_collected: int = 0

@onready var _coins_label := $Label as Label


func _ready() -> void:
	_coins_label.set_text(str(CoinsRemaining.currentcoin))
	($AnimatedSprite2D as AnimatedSprite2D).play()
	
	quest_manager = get_tree().get_first_node_in_group("quest_manager") 

func collect_coin() -> void:
	_coins_collected += 1
	
	if quest_manager and quest_manager.current_quest == quest_manager.QuestType.COLLECT_COINS:
		quest_manager.update_progress(1)

		
	CoinsRemaining.currentcoin = _coins_collected
	_coins_label.set_text(str(CoinsRemaining.currentcoin))
