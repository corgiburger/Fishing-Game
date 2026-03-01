extends Control

@onready var text: RichTextLabel = $RichTextLabel


func _process(delta: float) -> void:
	text.text = "$"+ str(Global.money) 
