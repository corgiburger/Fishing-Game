extends CanvasLayer

@onready var anim: AnimationPlayer = $AnimationPlayer
signal player_move

@onready var shop_ui_slot1: shop_ui_slot = $Control/Panel/MarginContainer/VBoxContainer/GridContainer/shop_ui_slot
@onready var shop_ui_slot_2: shop_ui_slot = $Control/Panel/MarginContainer/VBoxContainer/GridContainer/shop_ui_slot2
@onready var shop_ui_slot_3: shop_ui_slot = $Control/Panel/MarginContainer/VBoxContainer/GridContainer/shop_ui_slot3
@onready var shop_ui_slot_4: shop_ui_slot = $Control/Panel/MarginContainer/VBoxContainer/GridContainer/shop_ui_slot4
@onready var shop_ui_slot_5: shop_ui_slot = $Control/Panel/MarginContainer/VBoxContainer/GridContainer/shop_ui_slot5
@onready var shop_ui_slot_6: shop_ui_slot = $Control/Panel/MarginContainer/VBoxContainer/GridContainer/shop_ui_slot6
@onready var shop_ui_slot_7: shop_ui_slot = $Control/Panel/MarginContainer/VBoxContainer/GridContainer/shop_ui_slot7
@onready var shop_ui_slot_8: shop_ui_slot = $Control/Panel/MarginContainer/VBoxContainer/GridContainer/shop_ui_slot8
@onready var shop_ui_slot_9: shop_ui_slot = $Control/Panel/MarginContainer/VBoxContainer/GridContainer/shop_ui_slot9
@onready var shop_ui_slot_10: shop_ui_slot = $Control/Panel/MarginContainer/VBoxContainer/GridContainer/shop_ui_slot10
@onready var shop_ui_slot_11: shop_ui_slot = $Control/Panel/MarginContainer/VBoxContainer/GridContainer/shop_ui_slot11
@onready var shop_ui_slot_12: shop_ui_slot = $Control/Panel/MarginContainer/VBoxContainer/GridContainer/shop_ui_slot12
@onready var shop_ui_slot_13: shop_ui_slot = $Control/Panel/MarginContainer/VBoxContainer/GridContainer/shop_ui_slot13
@onready var shop_ui_slot_14: shop_ui_slot = $Control/Panel/MarginContainer/VBoxContainer/GridContainer/shop_ui_slot14
@onready var shop_ui_slot_15: shop_ui_slot = $Control/Panel/MarginContainer/VBoxContainer/GridContainer/shop_ui_slot15
@onready var shop_ui_slot_16: shop_ui_slot = $Control/Panel/MarginContainer/VBoxContainer/GridContainer/shop_ui_slot16
@onready var shop_ui_slot_17: shop_ui_slot = $Control/Panel/MarginContainer/VBoxContainer/GridContainer/shop_ui_slot17
@onready var shop_ui_slot_18: shop_ui_slot = $Control/Panel/MarginContainer/VBoxContainer/GridContainer/shop_ui_slot18
@onready var shop_ui_slot_19: shop_ui_slot = $Control/Panel/MarginContainer/VBoxContainer/GridContainer/shop_ui_slot19
@onready var shop_ui_slot_20: shop_ui_slot = $Control/Panel/MarginContainer/VBoxContainer/GridContainer/shop_ui_slot20
@onready var shop_ui_slot_21: shop_ui_slot = $Control/Panel/MarginContainer/VBoxContainer/GridContainer/shop_ui_slot21
@onready var shop_ui_slot_22: shop_ui_slot = $Control/Panel/MarginContainer/VBoxContainer/GridContainer/shop_ui_slot22
@onready var shop_ui_slot_23: shop_ui_slot = $Control/Panel/MarginContainer/VBoxContainer/GridContainer/shop_ui_slot23
@onready var shop_ui_slot_24: shop_ui_slot = $Control/Panel/MarginContainer/VBoxContainer/GridContainer/shop_ui_slot24

@onready var item_name: RichTextLabel = $Control/Panel/MarginContainer/VBoxContainer/HBoxContainer2/ItemName
@onready var item_sell_value: RichTextLabel = $Control/Panel/MarginContainer/VBoxContainer/HBoxContainer2/ItemCost
@onready var sell_button: Button = $Control/Panel/MarginContainer/VBoxContainer/HBoxContainer2/SellButton

var current_fish
var sell_value : float

var slot_array : Array[shop_ui_slot] = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sell_button.disabled = true
	sell_button.visible = false
	anim.play("open")
	slot_array = [shop_ui_slot1, shop_ui_slot_2, shop_ui_slot_3, shop_ui_slot_4, shop_ui_slot_5, shop_ui_slot_6,
	shop_ui_slot_7, shop_ui_slot_8, shop_ui_slot_9, shop_ui_slot_10, shop_ui_slot_11, shop_ui_slot_12, shop_ui_slot_13,
	shop_ui_slot_14, shop_ui_slot_15, shop_ui_slot_16, shop_ui_slot_17, shop_ui_slot_18, shop_ui_slot_19, shop_ui_slot_20,
	shop_ui_slot_21, shop_ui_slot_22, shop_ui_slot_23, shop_ui_slot_24]
	
	for n in slot_array:
		if n is shop_ui_slot and n != null:
			n.show_info.connect(_on_show_info)
	refresh_grid()
func _on_show_info(fish):
	print("AA")
	if fish != null:
		item_name.text = fish["name"][0].to_upper() + fish["name"].substr(1)
		sell_value = fish["cost"]
		item_sell_value.text = "$" + str(sell_value)
		sell_button.disabled = false
		sell_button.visible = true
		current_fish = fish
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	emit_signal("player_move")
	anim.play("close")
	
func refresh_grid() -> void:
	var inv := GlobalInvResourse.inventory_items
	for i in range(slot_array.size()):
		if i < inv.size():
			slot_array[i].change_slot_sprite(inv[i])
		else:
			slot_array[i].change_slot_sprite(null)  # clear empty slots

	# (optional) clear info panel
	item_name.text = ""
	item_sell_value.text = ""
	sell_button.disabled = true
	sell_button.visible = false
	current_fish = null


func _on_sell_button_pressed() -> void:
	Global.add_money(sell_value)
	print(Global.money)
	if GlobalInvResourse.inventory_items.has(current_fish):
		GlobalInvResourse.inventory_items.erase(current_fish)
	refresh_grid()
	AudioManager.play_sfx(preload("res://sounds/sfx/sellsfx.mp3"), 12, true)
	SaveLoad.SaveFileData.fishes = GlobalInvResourse.inventory_items
	SaveLoad._save()


func _on_sell_everything_pressed() -> void:
	AudioManager.play_sfx(preload("res://sounds/sfx/sellsfx.mp3"), 1, true)
	for fish in GlobalInvResourse.inventory_items:
		Global.add_money(fish["cost"])
	GlobalInvResourse.inventory_items.clear()
	SaveLoad.SaveFileData.money = Global.money
	SaveLoad.SaveFileData.fishes = GlobalInvResourse.inventory_items
	SaveLoad._save()
	refresh_grid()
