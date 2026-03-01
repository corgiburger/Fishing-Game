extends Node2D

@onready var anim: AnimationPlayer = $AnimationPlayer

@onready var text: RichTextLabel = $CanvasLayer/Control/VBoxContainer/RichTextLabel
@onready var rarity_text: RichTextLabel = $CanvasLayer/Control/VBoxContainer/RarityText
@onready var weight_text: RichTextLabel = $CanvasLayer/Control/VBoxContainer/WeightText
@onready var fish: TextureRect = $CanvasLayer/Control/Fish

var rarity_colours : Dictionary = {
								"Common" : Color.WHITE_SMOKE,
								"Uncommon" : Color.SEA_GREEN,
								"Rare" : Color.BLUE,
								"Epic" : Color.MEDIUM_PURPLE,
								"Legendary" : Color.GOLD
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim.play("catch_fish_screen")
	var player = get_parent().get_node("Player")
	player.connect("caught_fish", _on_fish_caught)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_fish_caught(fish_weight, fish_name, current_rar, current_fish):
	text.text = "[center][wave]You caught " + fish_name + "."
	rarity_text.text = "[center]"+current_rar
	weight_text.text = "[center]"+str(fish_weight)+"kg"
	fish.texture = load(current_fish["image"])
	if current_rar != "Mythical":
		rarity_text.modulate = rarity_colours[current_rar]
	else:
		rarity_text.text = "[rainbow][center]Mythical"
