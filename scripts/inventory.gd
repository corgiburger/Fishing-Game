extends CanvasLayer

var index : int = 0

@onready var level_text: RichTextLabel = $Control/MarginContainer/HBoxContainer/VBoxContainer/LevelText

@onready var slot_1: inv_ui_slot = $Control/MarginContainer/HBoxContainer/VBoxContainer/GridContainer/slot1
@onready var slot_2: inv_ui_slot = $Control/MarginContainer/HBoxContainer/VBoxContainer/GridContainer/slot2
@onready var slot_3: inv_ui_slot = $Control/MarginContainer/HBoxContainer/VBoxContainer/GridContainer/slot3
@onready var slot_4: inv_ui_slot = $Control/MarginContainer/HBoxContainer/VBoxContainer/GridContainer/slot4
@onready var slot_5: inv_ui_slot = $Control/MarginContainer/HBoxContainer/VBoxContainer/GridContainer/slot5
@onready var slot_6: inv_ui_slot = $Control/MarginContainer/HBoxContainer/VBoxContainer/GridContainer/slot6
@onready var slot_7: inv_ui_slot = $Control/MarginContainer/HBoxContainer/VBoxContainer/GridContainer/slot7
@onready var slot_8: inv_ui_slot = $Control/MarginContainer/HBoxContainer/VBoxContainer/GridContainer/slot8
@onready var slot_9: inv_ui_slot = $Control/MarginContainer/HBoxContainer/VBoxContainer/GridContainer/slot9
@onready var slot_10: inv_ui_slot = $Control/MarginContainer/HBoxContainer/VBoxContainer/GridContainer/slot10
@onready var slot_11: inv_ui_slot = $Control/MarginContainer/HBoxContainer/VBoxContainer/GridContainer/slot11
@onready var slot_12: inv_ui_slot = $Control/MarginContainer/HBoxContainer/VBoxContainer/GridContainer/slot12
@onready var slot_13: inv_ui_slot = $Control/MarginContainer/HBoxContainer/VBoxContainer/GridContainer/slot13
@onready var slot_14: inv_ui_slot = $Control/MarginContainer/HBoxContainer/VBoxContainer/GridContainer/slot14
@onready var slot_15: inv_ui_slot = $Control/MarginContainer/HBoxContainer/VBoxContainer/GridContainer/slot15
@onready var slot_16: inv_ui_slot = $Control/MarginContainer/HBoxContainer/VBoxContainer/GridContainer/slot16
@onready var slot_17: inv_ui_slot = $Control/MarginContainer/HBoxContainer/VBoxContainer/GridContainer/slot17
@onready var slot_18: inv_ui_slot = $Control/MarginContainer/HBoxContainer/VBoxContainer/GridContainer/slot18
@onready var slot_19: inv_ui_slot = $Control/MarginContainer/HBoxContainer/VBoxContainer/GridContainer/slot19
@onready var slot_20: inv_ui_slot = $Control/MarginContainer/HBoxContainer/VBoxContainer/GridContainer/slot20
@onready var slot_21: inv_ui_slot = $Control/MarginContainer/HBoxContainer/VBoxContainer/GridContainer/slot21
@onready var slot_22: inv_ui_slot = $Control/MarginContainer/HBoxContainer/VBoxContainer/GridContainer/slot22
@onready var slot_23: inv_ui_slot = $Control/MarginContainer/HBoxContainer/VBoxContainer/GridContainer/slot23
@onready var slot_24: inv_ui_slot = $Control/MarginContainer/HBoxContainer/VBoxContainer/GridContainer/slot24

var rarity_colours : Dictionary = {
								"Common" : Color.WHITE_SMOKE,
								"Uncommon" : Color.SEA_GREEN,
								"Rare" : Color.BLUE,
								"Epic" : Color.MEDIUM_PURPLE,
								"Legendary" : Color.GOLD
}

@onready var fish_name: RichTextLabel = $Control/MarginContainer/HBoxContainer/VBoxContainer2/FishName
@onready var rarity_text: RichTextLabel = $Control/MarginContainer/HBoxContainer/VBoxContainer2/RarityText
@onready var texture_rect: TextureRect = $Control/MarginContainer/HBoxContainer/VBoxContainer2/TextureRect
@onready var flavour_text: RichTextLabel = $Control/MarginContainer/HBoxContainer/VBoxContainer2/MarginContainer/FlavourText
@onready var weight_text: RichTextLabel = $Control/MarginContainer/HBoxContainer/VBoxContainer2/WeightText

var player

signal change_slot_sprite

var slot_array : Array[inv_ui_slot] = []

func _ready() -> void:
	player = get_parent().get_node("Player")
	level_text.text = "Level: " + str(ceil(Global.level)) + "     XP: " + str(ceil(Global.xp)) + "/" + str(ceil(Global.xp_needed_to_level_up))
	slot_array =  [
	slot_1, slot_2, slot_3, slot_4, slot_5, slot_6,
	slot_7, slot_8, slot_9, slot_10, slot_11, slot_12,
	slot_13, slot_14, slot_15, slot_16, slot_17, slot_18,
	slot_19, slot_20, slot_21, slot_22, slot_23, slot_24
	]

	for i in slot_array:
		if i is inv_ui_slot and i != null:
			i.show_info.connect(_on_show_info)
	
	for idx in range(GlobalInvResourse.inventory_items.size()):
		var item = GlobalInvResourse.inventory_items[idx]
		if item == null:
			return
		
		var sprite_to_change = item["image"]
		emit_signal("change_slot_sprite", sprite_to_change, idx, item)
	
func _on_show_info(slot_index, current_fish):
	print(slot_index)
	if current_fish != null:
		fish_name.text = "[center]" + current_fish["name"][0].to_upper() + current_fish["name"].substr(1)
		flavour_text.text = "[center]"+current_fish["flavour_text"]
		texture_rect.texture = load(current_fish["image"])
		rarity_text.text = "[center]"+ current_fish["rarity"]
		weight_text.text = "[center]"+ str(current_fish["fish_weight"]) + "kg"
		if current_fish["rarity"] != "Mythical":
			rarity_text.modulate = rarity_colours[current_fish["rarity"]]
		else:
			rarity_text.text = "[rainbow][center]Mythical"
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
