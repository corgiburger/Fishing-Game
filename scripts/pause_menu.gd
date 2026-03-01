extends Control

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var continue_btn: Button = $VBoxContainer/ContinueBtn
@onready var settings_button: Button = $VBoxContainer/SettingsButton
@onready var return_to_menu: Button = $VBoxContainer/ReturnToMenu


var in_menu : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	test_esc()
	btn_hovered(continue_btn, 1.15)
	btn_hovered(settings_button, 1.15)
	btn_hovered(return_to_menu, 1.15)
	
	if in_menu:
		mouse_filter = Control.MouseFilter.MOUSE_FILTER_STOP
		settings_button.mouse_filter = Control.MouseFilter.MOUSE_FILTER_STOP
		continue_btn.mouse_filter = Control.MouseFilter.MOUSE_FILTER_STOP
		return_to_menu.mouse_filter = Control.MouseFilter.MOUSE_FILTER_STOP
		settings_button.disabled = false
		continue_btn.disabled = false
		return_to_menu.disabled = false
	else:
		mouse_filter = Control.MouseFilter.MOUSE_FILTER_IGNORE
		settings_button.mouse_filter = Control.MouseFilter.MOUSE_FILTER_IGNORE
		continue_btn.mouse_filter = Control.MouseFilter.MOUSE_FILTER_IGNORE
		return_to_menu.mouse_filter = Control.MouseFilter.MOUSE_FILTER_IGNORE
		settings_button.disabled = true
		continue_btn.disabled = true
		return_to_menu.disabled = true
	
func resume():
	get_tree().paused = false
	anim.play_backwards("blur")
	in_menu = false
	
	
func pause():
	get_tree().paused = true
	anim.play("blur")
	in_menu = true
	

func test_esc():
	if Input.is_action_just_pressed("esc"):
		if !get_tree().paused and !in_menu:
			pause()
		elif get_tree().paused and in_menu:
			resume()
func btn_hovered(button : Button, intensity : float):
	button.pivot_offset = button.size / 2
	var tween = create_tween()
	if button.is_hovered():
		tween.tween_property(button, "scale", Vector2.ONE * intensity, 0.2)
	else:
		tween.tween_property(button, "scale", Vector2.ONE, 0.2)

func _on_continue_btn_pressed() -> void:
	resume()
	

func _on_settings_button_pressed() -> void:
	resume()
	get_tree().change_scene_to_file("res://scenes/settings_menu.tscn")
	DialogueManager.hide_textbox()
	Global.has_talked_to_xibi = false
func _on_return_to_menu_pressed() -> void:
	resume()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	DialogueManager.hide_textbox()
	Global.has_talked_to_xibi = false
