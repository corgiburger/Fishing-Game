extends CanvasLayer

@onready var play_button: Button = $Control/VBoxContainer/PlayButton
@onready var settings_button: Button = $Control/VBoxContainer/SettingsButton
@onready var quit_button: Button = $Control/VBoxContainer/QuitButton
@onready var extra_button: Button = $Control/VBoxContainer/ExtraButton

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var logo: Sprite2D = $Control/TitleHolder/Sprite2D

var patch_notes_open : bool = false

var scene_path : String
var _t : float = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim.play("enter")
	if AudioManager.get_child(0).stream != preload("res://sounds/music/fishing_game_music.mp3"):
		AudioManager.play_music(preload("res://sounds/music/fishing_game_music.mp3"), 1)
	$Control/PatchNotes.size = Vector2(1146, 810)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Control/PatchNotes.size = Vector2(1146, 810)
	btn_hovered(play_button, 1.15)
	btn_hovered(settings_button, 1.15)
	btn_hovered(quit_button, 1.15)
	btn_hovered(extra_button, 1.15)
	btn_hovered($Control/PatchNotesButton, 1.15)
	if Global.logo_smile:
		logo.texture = load("res://assets/FISHING GAME logo.png")
	else:
		logo.texture = load("res://assets/FISHING GAME logo_normal.png")
	_t += delta
	logo.position.y = sin(_t * TAU * 0.3) * 20
	
	if Input.is_action_just_pressed("esc") and patch_notes_open:
		$Control/PatchNotesAnim.play("close")
		patch_notes_open = false
	
func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_settings_button_pressed() -> void:
	scene_path = "res://scenes/settings_menu.tscn"
	anim.play("exit")
	
func btn_hovered(button : Button, intensity : float):
	button.pivot_offset = button.size / 2
	var tween = create_tween()
	if button.is_hovered():
		tween.tween_property(button, "scale", Vector2.ONE * intensity, 0.2)
	else:
		tween.tween_property(button, "scale", Vector2.ONE, 0.2)

func change_scene():
	get_tree().change_scene_to_file(scene_path)


func _on_extra_button_pressed() -> void:
	scene_path = "res://scenes/extra_menu.tscn"
	anim.play("exit")


func _on_patch_notes_button_pressed() -> void:
	if !patch_notes_open:
		$Control/PatchNotesAnim.play("open")
		patch_notes_open = true
		print("a")
	else:
		$Control/PatchNotesAnim.play("close")
		patch_notes_open = false


func _on_back_button_patch_pressed() -> void:
	if patch_notes_open:
		$Control/PatchNotesAnim.play("close")
		patch_notes_open = false
