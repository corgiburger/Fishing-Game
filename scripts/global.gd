extends Node

var previous_scene_path : String
var money : float
var level : int = 1
var xp : float
var logo_smile : bool = false
var fullscreen : bool = false
var xp_needed_to_level_up : float = 1000
var has_talked_to_xibi : bool = false
var has_done_quest : bool = false

var has_caught_wyatt : bool = false

var luck_upgrade : int = 0

var cool_setting : bool = false
signal level_up
signal xp_changed()
func _ready() -> void:
	SaveLoad._load()
	load_data()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(luck_upgrade)
func add_xp(xp_to_add):
	xp += xp_to_add
	emit_signal("xp_changed", xp_to_add)
	while xp >= xp_needed_to_level_up:
		xp -= xp_needed_to_level_up
		level += 1
		xp_needed_to_level_up *= 1.3
		emit_signal("level_up")
		AudioManager.play_sfx(preload("res://sounds/sfx/levelup.mp3"), 0.7)
	SaveLoad.SaveFileData.xp = xp
	SaveLoad.SaveFileData.level = level
	SaveLoad.SaveFileData.xp_needed_to_level_up = xp_needed_to_level_up
	SaveLoad._save()
	
func add_money(n : float):
	money += n
	SaveLoad.SaveFileData.money = money
	SaveLoad._save()

func finish_quest():
	has_done_quest = true
	SaveLoad.SaveFileData.has_done_quest = has_done_quest
	add_money(1500)
	for index in range(GlobalInvResourse.inventory_items.size() - 1, -1, -1):
		var item = GlobalInvResourse.inventory_items[index]
		if item["name"] == "a chicken burger":
			GlobalInvResourse.inventory_items.remove_at(index)

	SaveLoad._save()

func load_data():
	SaveLoad._load()
	xp = SaveLoad.SaveFileData.xp
	has_done_quest = SaveLoad.SaveFileData.has_done_quest
	level = SaveLoad.SaveFileData.level
	xp_needed_to_level_up = SaveLoad.SaveFileData.xp_needed_to_level_up
	has_caught_wyatt = SaveLoad.SaveFileData.has_caught_wyatt
	luck_upgrade = SaveLoad.SaveFileData.luck_upgrade
	GlobalInvResourse.inventory_items = SaveLoad.SaveFileData.fishes
	money = SaveLoad.SaveFileData.money
