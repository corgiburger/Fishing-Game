extends Node2D

@onready var anim: AnimationPlayer = $AnimationPlayer

var chicken: int = 0
var chicken_left : int
@onready var npc_sprite: Sprite2D = $Npc/Sprite2D
var is_in_zone : bool = false
const PLAYER = preload("res://scenes/player.tscn")
var scene_path : String
var player_node

func _ready() -> void:
	anim.play("enter")
	var player = PLAYER.instantiate()
	add_child(player)
	player.position = Vector2(-138, 6)
	player_node = player
	
	for i in GlobalInvResourse.inventory_items:
		if i["name"] == "a chicken burger":
			chicken += 1
			
	chicken_left = 3 - chicken
	
	if Global.has_done_quest:
		npc_sprite.flip_v = false
	else:
		npc_sprite.flip_v = true
		
func _process(delta: float) -> void:
	if is_in_zone:
		if Input.is_action_just_pressed("fish") and !DialogueManager.textbox_open and !DialogueManager.is_on_dialogue_cooldown and !player_node.is_in_inv:
			if !Global.has_done_quest:
				if !chicken >= 3:
					if !Global.has_talked_to_xibi:
						DialogueManager.start_dialogue("Yo wassup! My name is Xibi.")
						DialogueManager.add_next_dialogue("You look like JUST the person who could help me get rid of my annoying condition of being upside down.")
						DialogueManager.add_next_dialogue("See, this all happened because of my chicken burger defiecency.")
						DialogueManager.add_next_dialogue("I reckon about... hmmm...")
						DialogueManager.add_next_dialogue("About [rainbow]3[/rainbow] chicken burgers should be good for me to return to normal.")
						DialogueManager.add_next_dialogue("I'll gobble them up before you can blink, and they'll make me be able to stand upright!")
						DialogueManager.add_next_dialogue("Anyways, PLEASE HURRY UP MAN I NEED SOME CHICKEN AHHH")
						Global.has_talked_to_xibi = true
					else:
						DialogueManager.start_dialogue("PLEASE HURRY UP MAN I NEED SOME CHICKEN AHHH")
						if chicken == 2:
							DialogueManager.add_next_dialogue("Just 1 more chicken burger!")
						else:
							DialogueManager.add_next_dialogue("Just %d more chicken burgers!" % chicken_left)
				else:
					
					DialogueManager.start_dialogue("Is that [rainbow]3[/rainbow] chicken burgers I see?")
					DialogueManager.add_next_dialogue("Wow! Thank you for handing them over!")
					DialogueManager.add_next_dialogue("I finally feel back to normal again!", unupsidedown)
					DialogueManager.add_next_dialogue("And those burgers were so..")
					DialogueManager.add_next_dialogue("MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM")
					DialogueManager.add_next_dialogue("Delicious.")
					DialogueManager.add_next_dialogue("Anyways, I'd like to thank you with [color=green]$1500.[/color]")
					DialogueManager.add_next_dialogue("Be sure to get me some more chicken burgers when I turn upside down again.", Global.finish_quest)
					
			elif Global.has_done_quest:
				DialogueManager.start_dialogue("Thanks for those burgers, pal.")
				
		npc_sprite.texture = load("res://assets/xibi_focus.png")
		
	else:
		npc_sprite.texture = load("res://assets/xibi.png")
		
func _on_loading_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.previous_scene_path = 'res://scenes/room_003.tscn'
		scene_path = "res://scenes/shop_section.tscn"
		anim.play("exit")
		player_node.can_move = false
func change_scene():
	get_tree().change_scene_to_file(scene_path)


func _on_npc_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_in_zone = true

func _on_npc_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_in_zone = false

func unupsidedown():
	npc_sprite.flip_v = false
