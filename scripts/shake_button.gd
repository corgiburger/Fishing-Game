extends Area2D

signal shake_pressed
@onready var anim: AnimationPlayer = $AnimationPlayer
var speed : float

func _ready() -> void:
	var rng = randi_range(0, 1)
	match rng: 
		0:
			global_position = Vector2(-200, randi_range(0, -60))
			speed = 100
		1:
			global_position = Vector2(180, randi_range(0, -60))
			speed = -100
	add_to_group("shake_button") # identify these for hit-testing

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.x += speed * delta


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_viewport().set_input_as_handled()
		if speed > 0.0:
			speed = 5.0
		else:
			speed = -5.0
		
		AudioManager.play_sfx(preload("res://sounds/sfx/select sound effect.wav"), 1, true)
		emit_signal("shake_pressed")
		anim.play("clicked")
		
