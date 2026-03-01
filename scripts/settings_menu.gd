extends CanvasLayer

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var volume_slider: HSlider = $Control/VBoxContainer/HBoxContainer/HSlider
@onready var check_box: CheckBox = $Control/VBoxContainer/LogoButton
@onready var fullscreen_checkbox: CheckBox = $Control/VBoxContainer/Fullscreen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim.play("enter")
	volume_slider.value = AudioManager.music_slider_value
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var value = volume_slider.value
	var volume = linear_to_db(volume_slider.value / 100)
	print(volume)
	AudioManager.music_volume = volume
	AudioManager.music_slider_value = value
	
	if Global.logo_smile:
		check_box.button_pressed = true
		
	if Global.fullscreen:
		fullscreen_checkbox.button_pressed = true
		
func change_scenes():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_back_button_pressed() -> void:
	anim.play("exit")


func _on_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Global.logo_smile = true
	if !toggled_on:
		Global.logo_smile = false


func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Global.fullscreen = true
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if !toggled_on:
		Global.fullscreen = false
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_reset_save_pressed() -> void:
	SaveLoad._reset_save_data()
	Global.load_data()
