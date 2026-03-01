extends CanvasLayer
signal player_move
@onready var upgrade_text: Label = $Control/Panel/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/UpgradeText
@onready var money_text: Label = $Control/Panel/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/MoneyText
@onready var level_text: Label = $Control/Panel/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/LevelText

var stats_based_on_upgrade : Dictionary = { #{upgrade : [money needed, level needed]
	1 : [150, 2],
	2 : [400, 4],
	3 : [800, 6],
	4 : [1500, 9],
	5 : [2500, 12],
	6 : [4000, 16],
	7 : [6500, 20],
	8 : [10000, 25],
	9 : [16000, 30],
	10: [25000, 36],
	11: [99999, 99]
	}

var next_upgrade : int = Global.luck_upgrade + 1
var money_needed : int = stats_based_on_upgrade[next_upgrade][0]
var level_needed : int = stats_based_on_upgrade[next_upgrade][1]

func _ready() -> void:
	refresh()
	open()

func _process(delta: float) -> void:
	pass


func refresh():
	next_upgrade = Global.luck_upgrade + 1
	money_needed = stats_based_on_upgrade[next_upgrade][0]
	level_needed = stats_based_on_upgrade[next_upgrade][1]
	upgrade_text.text = "Luck Upgrade " + str(next_upgrade)
	money_text.text = "$" + str(money_needed)
	level_text.text = "Must be level " + str(level_needed)
	
	if Global.money >= money_needed:
		money_text.modulate = Color.GREEN
	else:
		money_text.modulate = Color.RED
		
	if Global.level >= level_needed:
		level_text.modulate = Color.GREEN
	else:
		level_text.modulate = Color.RED
		
func _on_upgrade_button_pressed() -> void:
	refresh()
	if Global.money >= money_needed and Global.level >= level_needed:
		Global.add_money(-money_needed)
		Global.luck_upgrade += 1
		SaveLoad.SaveFileData.luck_upgrade = Global.luck_upgrade
		SaveLoad._save()
		
	elif Global.money < money_needed and Global.level >= level_needed:
		print("Not enough money")
	elif Global.money >= money_needed and Global.level < level_needed:
		print("Not enough levels")
	elif Global.money < money_needed and Global.level < level_needed:
		print("Not enough money or levels")
	
	refresh()
func close():
	emit_signal("player_move")
	$AnimationPlayer.play("close")
	
func _on_back_button_pressed() -> void:
	close()
	
func open():
	$AnimationPlayer.play("open")
