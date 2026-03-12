extends Control

@onready var text: RichTextLabel = $RichTextLabel


func _process(delta: float) -> void :
	if Global.money < 0:
		text.text = "[color=red]$" + str(Global.money)
	else:
		text.text = "$" + str(Global.money)
