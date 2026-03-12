extends Node2D

@onready var rod: Area2D = $Rod
@onready var fish: Area2D = $Fish
@onready var progress_bar: ProgressBar = $CanvasLayer/Control/ProgressBar

var current_fish
var current_rar

var rod_moving_down: bool = false

@onready var anim: AnimationPlayer = $MeshInstance2D/AnimationPlayer

var rod_dir = 1
var fish_dir = -1
signal won()
signal lost
var fish_data: Array = []

var if_in_mg = true
var hasnt_hit_area_yet: bool = true
var fish_rarities_by_upgrade: Dictionary = {
	0: {"Common": 100, "Uncommon": 60, "Rare": 35, "Epic": 20, "Legendary": 10, "Mythical": 4}, 
	1: {"Common": 90, "Uncommon": 65, "Rare": 40, "Epic": 24, "Legendary": 13, "Mythical": 5}, 
	2: {"Common": 80, "Uncommon": 68, "Rare": 45, "Epic": 28, "Legendary": 16, "Mythical": 7}, 
	3: {"Common": 70, "Uncommon": 70, "Rare": 50, "Epic": 33, "Legendary": 20, "Mythical": 9}, 
	4: {"Common": 60, "Uncommon": 70, "Rare": 55, "Epic": 38, "Legendary": 25, "Mythical": 12}, 
	5: {"Common": 50, "Uncommon": 68, "Rare": 58, "Epic": 43, "Legendary": 30, "Mythical": 15}, 
	6: {"Common": 42, "Uncommon": 65, "Rare": 60, "Epic": 48, "Legendary": 35, "Mythical": 18}, 
	7: {"Common": 35, "Uncommon": 60, "Rare": 60, "Epic": 52, "Legendary": 40, "Mythical": 22}, 
	8: {"Common": 28, "Uncommon": 55, "Rare": 58, "Epic": 55, "Legendary": 45, "Mythical": 26}, 
	9: {"Common": 24, "Uncommon": 52, "Rare": 56, "Epic": 55, "Legendary": 47, "Mythical": 28}, 
	10: {"Common": 22, "Uncommon": 50, "Rare": 55, "Epic": 55, "Legendary": 50, "Mythical": 30},
	11: {"Common": 0, "Uncommon": 0, "Rare": 0, "Epic": 0, "Legendary": 50, "Mythical": 30},
}
var fish_speed: float
var stubbornness: float
var fish_weight: float
var fish_name: String

var fish_cost: float
var fish_flavour_text: String

var rod_speed = 65.0

var rng = RandomNumberGenerator.new()


func _ready() -> void :
	anim.play("fade_in")
	fish_data = FishDataManager.fish_data
	get_random_fish()

func _process(delta: float) -> void :


	if rod.position.x >= 60:
		rod_dir = -1
	if rod.position.x <= -60:
		rod_dir = 1


	if fish.position.x >= 60:
		fish_dir = -1
	if fish.position.x <= -60:
		fish_dir = 1

	rod.position.x += rod_dir * rod_speed * delta
	fish.position.x += fish_dir * fish_speed * delta


	if rod_moving_down and hasnt_hit_area_yet:
		rod.position.y += delta * 100

func _on_rod_area_entered(area: Area2D) -> void :
	if area.is_in_group("fish"):
		progress_bar.max_value = stubbornness
		progress_bar.value += 1

		if progress_bar.value == progress_bar.max_value:
			emit_signal("won", fish_weight, fish_name, current_rar, current_fish)
			anim.play("end_mg")
			fish_speed = 0
			hasnt_hit_area_yet = false
		else:
			rod.position.y = -54
			rod_speed = 65.0
			rod_moving_down = false
			hasnt_hit_area_yet = true

	if area.is_in_group("miss_block"):
		emit_signal("lost")
		hasnt_hit_area_yet = false
		fish_speed = 0
		Global.catch_streak = 0
		SaveLoad.SaveFileData.catch_streak = Global.catch_streak
		SaveLoad._save()
		anim.play("end_mg")
func _input(event: InputEvent) -> void :
	if Input.is_action_just_pressed("fish") and if_in_mg:
		rod_speed = 0
		rod_moving_down = true
func get_random_fish():
	var current_rarity = get_rarity()
	current_rar = current_rarity
	print(current_rarity)
	match current_rarity:
		"Common":
			current_fish = fish_data[0].values()[randi_range(0, fish_data[0].values().size() - 1)]
		"Uncommon":
			current_fish = fish_data[1].values()[randi_range(0, fish_data[1].values().size() - 1)]
		"Rare":
			current_fish = fish_data[2].values()[randi_range(0, fish_data[2].values().size() - 1)]
		"Epic":
			current_fish = fish_data[3].values()[randi_range(0, fish_data[3].values().size() - 1)]
		"Legendary":
			current_fish = fish_data[4].values()[randi_range(0, fish_data[4].values().size() - 1)]
		"Mythical":
			current_fish = fish_data[5].values()[randi_range(0, fish_data[5].values().size() - 1)]
		"Glitched":
			current_fish = fish_data[6].values()[0]
	
	while current_fish["name"].to_lower() == "wyatt the wizard" and Global.has_caught_wyatt:
		current_fish = fish_data[3].values()[randi_range(0, fish_data[3].values().size() - 1)]
	
	current_fish = fish_data[4].values()[3]
	
	fish_speed = current_fish["speed"]
	stubbornness = current_fish["stubbornness"]
	fish_name = current_fish["name"]
	fish_weight = randf_range(current_fish["weight_range"][0], current_fish["weight_range"][1])
	fish_weight = snapped(fish_weight, 0.01)

	fish_cost = current_fish["cost"]
	fish_flavour_text = current_fish["flavour_text"]

	print(stubbornness)
	print(fish_speed)
	print(fish_name)
	print(fish_weight)



func get_rarity():
	var upgrade = Global.luck_upgrade
	var fish_rarities: Dictionary

	fish_rarities = fish_rarities_by_upgrade[upgrade]
	rng.randomize()
	var weighted_sum: = 0
	
	var n = randi_range(1, 2000)
	if n == 5:
		return "Glitched"
		
	for i in fish_rarities:
		weighted_sum += fish_rarities[i]
	var number = rng.randi_range(0, weighted_sum)

	for i in fish_rarities:
		if number <= fish_rarities[i]:
			return i
		number -= fish_rarities[i]
	
		
