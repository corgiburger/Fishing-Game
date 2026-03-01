extends Panel

class_name inv_ui_slot

@onready var label: Label = $Label

@export var slot_index = -1

signal show_info()

var current_fish

@onready var item_sprite: Sprite2D = $ItemSprite

func _ready() -> void:
	get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().connect("change_slot_sprite", _on_change_sprite)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_change_sprite(sprite_to_change, idx, item):
	if slot_index == idx + 1:
		item_sprite.texture = load(sprite_to_change)
		current_fish = item

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("show_info", slot_index, current_fish)
