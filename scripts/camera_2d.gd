extends Camera2D


@onready var anim: AnimationPlayer = $AnimationPlayer
var tween : Tween
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
 

func _on_player_entered_fz() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	tween.tween_property(self, "zoom", Vector2(7, 7), 0.3)
	tween.tween_property(self, "offset", Vector2(-50, 7), 0.3)

func _on_player_exited_fz() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	tween.tween_property(self, "zoom", Vector2(6, 6), 0.5)
	tween.tween_property(self, "offset", Vector2(0, 0), 0.5)


func _on_player_caught_fish() -> void:
	anim.play("catch_fish_zoom_effect")
