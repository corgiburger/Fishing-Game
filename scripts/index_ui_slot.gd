extends Panel

class_name index_ui_slot
@onready var slot_sprite: Sprite2D = $ItemSprite

@export var slot_index = -1

var locked: bool = true
var fish
signal show_info(fish, locked)

func _ready() -> void :
	pass



func _process(delta: float) -> void :
	pass

func change_slot_sprite(current_fish):
	if current_fish == null:
		slot_sprite.texture = null
		return
	fish = current_fish
	if !Global.index_data.has(current_fish["name"].to_lower()):
		locked = true
		slot_sprite.modulate = Color.BLACK
	else:
		locked = false
	slot_sprite.texture = load(current_fish["image"])

func _on_gui_input(event: InputEvent) -> void :
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("show_info", fish, locked)
