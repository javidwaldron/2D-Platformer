extends Node

class_name QuestManager

@export var quest_ui: Node
@export var player: Node

signal quest_updated(quest_text: String, progress: int, required: int)
signal player_leveled_up(level: int)

enum QuestType { COLLECT_COINS, KILL_ENEMIES, COMPLETED}

var current_quest = QuestType.COLLECT_COINS
var quest_progress = 0
var required_amount = 15
var player_level = 1

func _ready():	
	emit_signal("quest_updated", get_quest_text(), quest_progress, required_amount)
	if quest_ui:
		connect("quest_updated", Callable(quest_ui, "update_quest"))
	for enemy in get_tree().get_nodes_in_group("enemies"):  
		enemy.connect("enemy_defeated", Callable(self, "on_enemy_defeated"))


func update_progress(amount: int):
	quest_progress += amount

	emit_signal("quest_updated", get_quest_text(), quest_progress, required_amount)

	if quest_progress >= required_amount:
		complete_quest()

func complete_quest():
	quest_progress = 0
	level_up()
	
	if current_quest == QuestType.COLLECT_COINS:
		current_quest = QuestType.KILL_ENEMIES
		required_amount = 2
	else:
		current_quest = QuestType.COMPLETED
		#print("All missions are completed!")

	emit_signal("quest_updated", get_quest_text(), quest_progress, required_amount)

func level_up():
	player_level += 1
	emit_signal("player_leveled_up", player_level)
	print("Player level %d:" % player_level)
	
	if player:
		player.health_up(20)

func get_quest_text() -> String:
	match current_quest:
		QuestType.COLLECT_COINS:
			return "Collect coins: (%d/%d)" % [quest_progress, required_amount]
		QuestType.KILL_ENEMIES:
			return "Defeat enemies: (%d/%d)" % [quest_progress, required_amount]
	return "All completed!"
	
func on_enemy_defeated():
	if current_quest == QuestType.KILL_ENEMIES:
		update_progress(1)
