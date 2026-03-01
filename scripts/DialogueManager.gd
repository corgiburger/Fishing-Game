extends Node
const DIALOGUE_BOX_SCENE = preload("res://scenes/dialogue_box.tscn")

var textbox_open : bool = false
var queue : Array = []
var is_typing : bool = false
var text_node : RichTextLabel
var dialogue_box_node : CanvasLayer
var timer : Timer
var player : Player
var is_on_dialogue_cooldown : bool


func _process(delta: float) -> void:
	player = get_tree().get_first_node_in_group("player")
	if player:
		if textbox_open:
			player.can_move = false

func start_dialogue(text : String, action : Callable = Callable()):
	queue.append({
		"text" : text,
		"action" : action
	})
	dialogue_box_node = DIALOGUE_BOX_SCENE.instantiate()
	get_tree().current_scene.add_child(dialogue_box_node)
	textbox_open = true
	text_node = dialogue_box_node.texta
	timer = dialogue_box_node.type_timer
	timer.connect("timeout", _on_timer_timeout)
	show_next_line()
	
func show_next_line():
	if !queue.is_empty():
		var item = queue.pop_at(0)
		#run action
		if item["action"].is_valid():
			item["action"].call()
		#show text
		text_node.text = item["text"]
		text_node.visible_characters = 0
		is_typing = true
		timer.start()

		
func add_next_dialogue(text : String, action : Callable = Callable()):
	queue.append({
		"text" : text,
		"action" : action
	})
func _on_timer_timeout():
	if text_node.visible_characters < text_node.get_total_character_count():
		text_node.visible_characters += 1
		dialogue_box_node.audio.playing = true
	else:
		is_typing = false
		timer.stop()
		dialogue_box_node.audio.playing = false
		


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("fish") and textbox_open and !player.is_in_inv:
			
		if is_typing:
			is_typing = false
			timer.stop()
			text_node.visible_characters = -1
			dialogue_box_node.audio.playing = false
		elif queue.is_empty() and !is_typing:
			hide_textbox()
			player.can_move = true
			return
		else:
			show_next_line()

func hide_textbox():
	if is_instance_valid(dialogue_box_node):
		dialogue_box_node.queue_free()
	textbox_open = false
	queue = []
	is_on_dialogue_cooldown = true
	await get_tree().create_timer(0.1).timeout
	is_on_dialogue_cooldown = false
	
