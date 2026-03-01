extends CharacterBody2D
class_name Player
var can_move: bool = true
const SPEED = 90
var in_fz : bool
signal entered_fz
signal exited_fz

const SHAKE_BUTTON = preload("res://scenes/shake_button.tscn")
const BOBBER = preload("res://scenes/bobber.tscn")

@onready var fishing_rod: Sprite2D = $FishingRod
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim: AnimationPlayer = $FishingRod/AnimationPlayer
var is_fishing : bool = false
@onready var rod_end: Node2D = fishing_rod.get_child(0)
@onready var line: Line2D = $FishingRod/Line2D

@onready var timer: Timer = $Timer #for fishing rod



@onready var shake_spawn_timer: Timer = %SpawnTimer

var current_shake_buttons : Array[Area2D] = []

var is_in_fish_minigame = false

var direction

var is_in_inv = false

var inv
signal caught_fish


var bobber: Node2D
var fish_mg = null

func _ready() -> void:
	fishing_rod.position = Vector2(13, -1)
	
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("fish"):
		if in_fz and sprite.flip_h == true and is_fishing == false and !is_in_fish_minigame and !is_in_inv and !DialogueManager.textbox_open:
			anim.play("fish")
			is_fishing = true
			#START FISH TIMER uehuheurhu
			timer.wait_time = 24.0
			timer.start()
			#-------------
			shake_spawn_timer.start()
			
		elif is_fishing == true and !is_in_fish_minigame:
			if not _clicked_shake_button():
				pickup_rod()
				
	if Input.is_action_just_pressed("inventory"):
		if !is_in_inv:
			can_move = false
			var instance = preload("res://scenes/inventory.tscn").instantiate()
			inv = instance
			get_parent().add_child(instance)
			
			is_in_inv = true
		else:
			can_move = true
			if is_instance_valid(inv):
				inv.queue_free()
			is_in_inv = false
func _physics_process(delta: float) -> void:
	#print(can_move)
	if !can_move:
		velocity.x = 0
		sprite.animation = "idle"
		move_and_slide()
		return
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	direction = Input.get_axis("move_left", "move_right")
	
	if direction and can_move:
		velocity.x = direction * SPEED
		
		pickup_rod()
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if direction != 0.0 and is_in_fish_minigame:
		if is_instance_valid(fish_mg):
			fish_mg.queue_free()
			is_in_fish_minigame = false
	match direction:
		-1.0:
			if can_move:
				sprite.flip_h = true
				fishing_rod.flip_h = true
				fishing_rod.position = Vector2(-13, 1)
			sprite.animation = "run"
		0.0:
			sprite.animation = "idle"
		1.0:
			if can_move:
				sprite.flip_h = false
				fishing_rod.flip_h = false
				fishing_rod.position = Vector2(13, 1)
			sprite.animation = "run"
			
	move_and_slide()
	if is_instance_valid(bobber):
		line.set_point_position(0, line.to_local(rod_end.global_position))
		line.set_point_position(1, line.to_local(bobber.global_position))



func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("fishingzone"):
		emit_signal("entered_fz")
		in_fz = true
		print("in fishing zone")

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("fishingzone"):
		emit_signal("exited_fz")
		in_fz = false
		print("NOT in fishing zone")

func cast_rod():
	bobber = BOBBER.instantiate()
	get_parent().add_child(bobber)
	bobber.global_position = rod_end.global_position
	line.points = PackedVector2Array([
		line.to_local(rod_end.global_position),
		line.to_local(bobber.global_position)
	])
	line.visible = true


func _on_timer_timeout() -> void: 
	for i in current_shake_buttons:
		if is_instance_valid(i):
			i.queue_free()
	timer.stop()
	shake_spawn_timer.stop()
	anim.play("exclamation_mark")
	is_in_fish_minigame = true


func pickup_rod():
	is_fishing = false
	fishing_rod.texture = preload("res://assets/def_fishing_rod.png")
	anim.stop(false)
	line.clear_points()
	line.visible = false
	#GET RID OF BOBBER
	if is_instance_valid(bobber): 
		bobber.queue_free()
	bobber = null
	is_in_fish_minigame = false
	if timer and shake_spawn_timer:
		timer.stop()
		shake_spawn_timer.stop()
	#GET RID OF SHAKE BUTTONS
	for i in current_shake_buttons:
		if is_instance_valid(i):
			i.queue_free()
			
			
			
func catch_fish_minigame(): #WHAT HAPPENS WHEN THE FISH PICKS UP THE BAIT
		
	var minigame_instance = preload("res://scenes/fish_minigame.tscn").instantiate()
	get_parent().add_child(minigame_instance)
	minigame_instance.global_position = Vector2(-50, 0)
	
	print("Initiating Fish Minigame Lol IYWGDyuiawgduywtagud")
	fish_mg = minigame_instance
	
	minigame_instance.connect("won", _on_fish_won)
	minigame_instance.connect("lost", _on_fish_lost)
	
func win_fish():
	print("caught fish")
	anim.play("pickup_fish")
	shake_spawn_timer.stop()
	is_in_fish_minigame = false
	
	

func get_rid_of_line():   #idk
	is_fishing = false
	line.clear_points()
	line.visible = false
	if is_instance_valid(bobber):
		bobber.queue_free()
	bobber = null
	timer.stop()
	shake_spawn_timer.stop()

func _on_spawn_timer_timeout() -> void: #spwanwadijawodjiaowiadjwioadj Shake Buttons.
	var instance = SHAKE_BUTTON.instantiate()
	$"../ShakeButtons".add_child(instance)
	instance.connect("shake_pressed", _on_shake_pressed)
	current_shake_buttons.append(instance)
	
func _on_shake_pressed(): #lowers timer time yihpee 🥀!
	var remaining = timer.time_left
	var new_time = max(remaining - 5.0, 0.1) # prevent negative
	timer.start(new_time)


func _on_fish_won(fish_weight, fish_name, current_rar, current_fish):
	win_fish()
	AudioManager.play_sfx(preload("res://sounds/sfx/catch fish sfx.mp3"), 1, true)
	var instance = preload("res://scenes/catch_fish_screen.tscn").instantiate()
	get_parent().add_child(instance)
	instance.global_position = Vector2(-50, 0)
	emit_signal("caught_fish", fish_weight, fish_name, current_rar, current_fish)

	current_fish["fish_weight"] = fish_weight
	if fish_name.to_lower() == "wyatt the wizard":
		Global.has_caught_wyatt = true
		SaveLoad.SaveFileData.has_caught_wyatt = true
		SaveLoad._save()
		if !Global.cool_setting:
			DialogueManager.start_dialogue("wyatt here")
			DialogueManager.add_next_dialogue("im wyatt :D")
			DialogueManager.add_next_dialogue("[color=red]cough cough[/color] I can help upgrade your wand so you can catch better fish.")
			DialogueManager.add_next_dialogue("[color=yellow]From now on[/color], I will reside by the shop where you sell stuff.")
		else:
			DialogueManager.start_dialogue("wyatt here i just respawned out of a bloodbath sonic wave straight into slaughterhouse my screen is still shaking")
			DialogueManager.add_next_dialogue("tartarus acheron the golden zodiac kenos firework my brain is focusing please dont orbit away")
			DialogueManager.add_next_dialogue("i think i went into an abyss of darkness and came back with some space to think, too")
			DialogueManager.add_next_dialogue("kenos zodiac acheron tartarus slaughterhouse 8o grief bloodlust bloodbath firework the golden limbo congregation")
	else:
		GlobalInvResourse.add_item(current_fish)
	print(GlobalInvResourse.inventory_items)
	SaveLoad.SaveFileData.fishes = GlobalInvResourse.inventory_items
	SaveLoad._save()
	
	match current_rar:
		"Common":
			Global.add_xp(randi_range(80, 180))
		"Uncommon":
			Global.add_xp(randi_range(200, 400))
		"Rare":
			Global.add_xp(randi_range(450, 700))
		"Epic":
			Global.add_xp(randi_range(750, 1100))
		"Legendary":
			Global.add_xp(randi_range(1200, 1800))
		"Mythical":
			Global.add_xp(randi_range(2000, 3000))
	
func _on_fish_lost():
	pickup_rod()
	
#--- LITERALLY JUST BUGFIXES ------------------------------------------------------

func _clicked_shake_button() -> bool:
	var params := PhysicsPointQueryParameters2D.new()
	params.position = get_global_mouse_position()
	params.collide_with_areas = true
	params.collide_with_bodies = false
	# Optional: limit to the collision layer your shake buttons use:
	# params.collision_mask = 1 << 3

	var results := get_world_2d().direct_space_state.intersect_point(params, 16)
	for hit in results:
		var a = hit["collider"]
		if a is Area2D and a.is_in_group("shake_button"):
			return true
	return false
