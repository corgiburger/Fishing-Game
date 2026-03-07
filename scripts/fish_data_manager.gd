extends Node

var json_fd_path = "res://scripts/json/fish_database.json"
var fish_data: Array = []







func _ready() -> void :
	load_json_file()
	print(fish_data)

func _process(delta: float) -> void :
	pass

func load_json_file():
	var file = FileAccess.open(json_fd_path, FileAccess.READ)
	assert (FileAccess.file_exists(json_fd_path), "FILE NO EXIST!!!")

	var json = file.get_as_text()
	var json_object = JSON.new()

	json_object.parse(json)

	fish_data = json_object.data

	return fish_data
