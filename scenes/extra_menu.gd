extends CanvasLayer

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var emoji: Sprite2D = $Control/VBoxContainer/HBoxContainer/Emoji/Sprite2D
@onready var cool_button: CheckBox = $Control/VBoxContainer/CoolButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim.play("enter")
	AudioManager.play_music(preload("res://sounds/music/shop_fishing_game.mp3"), 0.9)
	cool_button.button_pressed = Global.cool_setting
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	emoji.rotate(deg_to_rad(1.5))
	
func change_to_main():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_back_button_pressed() -> void:
	anim.play("exit")


func _on_cool_button_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		Global.cool_setting = true
	else:
		Global.cool_setting = false
