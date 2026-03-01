extends Node

const save_location = "user://SaveFile.json"
var SaveFileData :SaveDataResource = SaveDataResource.new()

func _ready() -> void:
	_load()

func _save():
	var file = FileAccess.open_encrypted_with_pass(save_location, FileAccess.WRITE, "3AWE7ydqwi76y8I")
	
	var data_to_save = {
		"fishes" : SaveFileData.fishes,
		"money" : SaveFileData.money,
		"xp" : SaveFileData.xp,
		"level" : SaveFileData.level,
		"xp_needed_to_level_up" : SaveFileData.xp_needed_to_level_up,
		"has_done_quest" : SaveFileData.has_done_quest,
		"has_caught_wyatt" : SaveFileData.has_caught_wyatt,
		"luck_upgrade" : SaveFileData.luck_upgrade
		
	}
	var json_ver = JSON.stringify(data_to_save)
	
	file.store_string(json_ver)
	file.close()
	
func _load():
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open_encrypted_with_pass(save_location, FileAccess.READ, "3AWE7ydqwi76y8I")
		var data = JSON.parse_string(file.get_as_text())
		file.close()
	
		SaveFileData = SaveDataResource.new()
		SaveFileData.fishes = data.get("fishes", [])
		SaveFileData.money = data.get("money", 0.0)
		SaveFileData.xp = data.get("xp", 0.0)
		SaveFileData.level = data.get("level", 1)
		SaveFileData.xp_needed_to_level_up = data.get("xp_needed_to_level_up", 1000)
		SaveFileData.has_done_quest = data.get("has_done_quest", false)
		SaveFileData.has_caught_wyatt = data.get("has_caught_wyatt", false)
		SaveFileData.luck_upgrade = data.get("luck_upgrade", 0)

func _reset_save_data():
	SaveFileData = SaveDataResource.new()
	_save()
	_load()
