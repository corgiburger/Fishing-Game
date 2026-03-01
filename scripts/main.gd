extends Node2D

@onready var player: Player = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("fade")
	if AudioManager.get_child(0).stream != preload("res://sounds/music/fishing_game_music.mp3"):
		AudioManager.play_music(preload("res://sounds/music/fishing_game_music.mp3"), 1)
	player.get_child(0).flip_h = true
	player.get_child(3).flip_h = true
	player.get_child(3).position = Vector2(-13, 1)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_door_body_entered(body: Player) -> void:
	if body.is_in_group("player"):
		$AnimationPlayer.play("fade_in")
		body.can_move = false
		print("Hello.")

func switch_scenes():
	Global.previous_scene_path = "res://scenes/main.tscn"
	get_tree().change_scene_to_file("res://scenes/shop_section.tscn")
