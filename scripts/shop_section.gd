extends Node2D

@onready var anim: AnimationPlayer = $AnimationPlayer

var scene_path : String
const PLAYER = preload("res://scenes/player.tscn")
var hover_oshop
var is_in_shop
@onready var shop_sprite: Sprite2D = $Shop/Sprite2D
@onready var wizard_sprite: Sprite2D = $Wizard/Sprite2D
var hover_wizard : bool = false
var is_in_upgrade_menu : bool = false


var player_node : Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !Global.has_caught_wyatt:
		$Wizard.queue_free()
	var player = PLAYER.instantiate()
	add_child(player)
	if Global.previous_scene_path == "res://scenes/main.tscn":
		player.position = Vector2(-126, 15)
	if Global.previous_scene_path == "res://scenes/room_003.tscn":
		player.position = Vector2(141, 15)
		player.get_child(0).flip_h = true
		player.get_child(3).flip_h = true
		player.get_child(3).position = Vector2(-13, 1)
			
	anim.play("fade_out")
	if AudioManager.get_child(0).stream != preload("res://sounds/music/fishing_game_music.mp3"):
		AudioManager.play_music(preload("res://sounds/music/fishing_game_music.mp3"), 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hover_oshop:
		shop_sprite.texture = load("res://assets/Shop_outlined.png")
		if Input.is_action_just_pressed("fish") and !is_in_shop and !player_node.is_in_inv:
			open_shop()
			player_node.can_move = false
	elif !hover_oshop:
		shop_sprite.texture = load("res://assets/shop_exterior.png")
	
	if Input.is_action_just_pressed("fish") and hover_wizard and !player_node.is_in_inv and !is_in_upgrade_menu:
		open_rod_upgrade_menu()
		player_node.can_move = false
func open_shop():
	var shop = preload("res://scenes/shop.tscn").instantiate()
	is_in_shop = true
	add_child(shop)
	shop.connect("player_move", _on_player_able_to_move_again)
	
func _on_player_able_to_move_again():
	player_node.can_move = true
	is_in_shop = false
	is_in_upgrade_menu = false
func open_rod_upgrade_menu():
	var menu = preload("res://scenes/rod_upgrade_menu.tscn").instantiate()
	is_in_upgrade_menu = true
	add_child(menu)
	menu.connect("player_move", _on_player_able_to_move_again)
	
func switch_scenes():
	get_tree().change_scene_to_file(scene_path)

 
func _on_shop_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		hover_oshop = true
		player_node = body


func _on_shop_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		hover_oshop = false


func _on_main_area_body_entered(body: Player) -> void:
	if body.is_in_group("player"):
		scene_path = "res://scenes/main.tscn"
		anim.play("fade_in")
		body.can_move = false


func _on_xibi_zone_area_body_entered(body: Player) -> void:
	if body.is_in_group("player"):
		scene_path = "res://scenes/room_003.tscn"
		anim.play("fade_in")
		body.can_move = false


func _on_wizard_body_entered(body: Player) -> void:
	if body.is_in_group("player"):
		wizard_sprite.texture = load("res://assets/wyattfullfocus.png")
		hover_wizard = true

func _on_wizard_body_exited(body: Player) -> void:
	if body.is_in_group("player"):
		wizard_sprite.texture = load("res://assets/wyattfull.png")
		hover_wizard = false
