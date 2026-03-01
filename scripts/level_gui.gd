extends Control

@onready var level: RichTextLabel = %Level
@onready var xp: ProgressBar = %XP
@onready var plus_xp_text: RichTextLabel = $"plus xp text"

@onready var anim: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.connect("xp_changed", _on_xp_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	level.text = "Level: " + str(Global.level)
	xp.max_value = Global.xp_needed_to_level_up
	xp.value = Global.xp
	
func _on_xp_changed(xp_to_add):
	plus_xp_text.text = "+" + str(xp_to_add) + " XP"
	anim.play("show")
