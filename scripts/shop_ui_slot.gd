extends Panel

class_name shop_ui_slot
@onready var slot_sprite: Sprite2D = $Sprite2D

@export var slot_index = -1
var fish
signal show_info()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_slot_sprite(current_fish):
	fish = current_fish
	if current_fish == null:
		slot_sprite.texture = null
		return
	slot_sprite.texture = load(current_fish["image"])
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("a")
		emit_signal("show_info", fish)
