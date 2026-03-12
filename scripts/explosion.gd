extends AnimatedSprite2D


# Called when the node enters 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if frame >= 15:
		queue_free()
