extends Control


@onready var quest_label = $QuestLabel
@onready var progress_bar = $ProgressBar

func update_quest(quest_text: String, progress: int, required: int):
	print("update UI:", quest_text, progress, required)
	quest_label.text = quest_text
	progress_bar.value = float(progress) / required * 100
