extends Node

@onready var music_player: AudioStreamPlayer = $music_player
@onready var sfx_player_1: AudioStreamPlayer = $sfx_player_1
var music_volume : float
var music_slider_value : float = 100


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music_volume = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var master = AudioServer.get_bus_index("Master")
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), music_volume)
	
	if get_tree().paused:
		AudioServer.set_bus_effect_enabled(master, 0, true)
		AudioServer.set_bus_volume_db(master, -10.0)
	else:
		AudioServer.set_bus_effect_enabled(master, 0, false)
		AudioServer.set_bus_volume_db(master, 0.0)
func play_music(music, pitch):
	music_player.stream = music
	music_player.pitch_scale = pitch
	music_player.playing = true

func play_sfx(sfx, pitch : float = 1, do_random_pitch : bool = false):
	
	sfx_player_1.stream = sfx
	sfx_player_1.pitch_scale = pitch
	if do_random_pitch == true:
		sfx_player_1.pitch_scale = randf_range(0.85,1.15)
	sfx_player_1.playing = true
 
