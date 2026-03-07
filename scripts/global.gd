extends Node

var previous_scene_path: String
var money: float
var level: int = 1
var xp: float
var logo_smile: bool = false
var fullscreen: bool = false
var xp_needed_to_level_up: float

var xp_needed_based_on_level: Dictionary = {
	1: 900, 
	2: 1400, 
	3: 1700, 
	4: 2000, 
	5: 2700, 
	6: 3500, 
	7: 4400, 
	8: 5500, 
	9: 6800, 
	10: 8200, 
	11: 9800, 
	12: 11500, 
	13: 13500, 
	14: 15500, 
	15: 18000, 
	16: 20500, 
	17: 23500, 
	18: 26500, 
	19: 30000, 
	20: 34000, 
	21: 38000, 
	22: 42500, 
	23: 47000, 
	24: 52000, 
	25: 57500, 
	26: 63000, 
	27: 69000, 
	28: 75000, 
	29: 82000, 
	30: 89000, 
	31: 96000, 
	32: 103500, 
	33: 111000, 
	34: 119000, 
	35: 127000, 
	36: 135500, 
	37: 144000, 
	38: 153000, 
	39: 162000, 
	40: 171500, 
	41: 181000, 
	42: 191000, 
	43: 201000, 
	44: 211500, 
	45: 222000, 
	46: 233000, 
	47: 244000, 
	48: 255500, 
	49: 267000, 
	50: 279000, 
}

var has_talked_to_xibi: bool = false
var has_done_quest: bool = false

var has_caught_wyatt: bool = false

var luck_upgrade: int = 0

var catch_streak: float = 0
var xp_mult: float

var cool_setting: bool = false

var index_data: Dictionary = {}

signal level_up
signal xp_changed()

func _ready() -> void :
	SaveLoad._load()
	load_data()

func _process(delta: float) -> void :
	xp_mult = (catch_streak/50) + 1
	xp_needed_to_level_up = xp_needed_based_on_level[level]
func add_xp(xp_to_add):
	print(xp_to_add)
	xp += xp_to_add
	emit_signal("xp_changed", xp_to_add)
	while xp >= xp_needed_to_level_up:
		xp -= xp_needed_to_level_up
		level += 1
		emit_signal("level_up")
		AudioManager.play_sfx(preload("res://sounds/sfx/levelup.mp3"), 0.7)
	SaveLoad.SaveFileData.xp = xp
	SaveLoad.SaveFileData.level = level
	SaveLoad._save()

func add_money(n: float):
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
	xp_needed_to_level_up = xp_needed_based_on_level[level]
	has_caught_wyatt = SaveLoad.SaveFileData.has_caught_wyatt
	luck_upgrade = SaveLoad.SaveFileData.luck_upgrade
	GlobalInvResourse.inventory_items = SaveLoad.SaveFileData.fishes
	money = SaveLoad.SaveFileData.money
	catch_streak = SaveLoad.SaveFileData.catch_streak
	index_data = SaveLoad.SaveFileData.index_data
