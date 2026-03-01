extends RigidBody2D

var is_in_water: bool = false

func _ready() -> void:
	
	apply_impulse(Vector2(-80, -100))
	
func _physics_process(delta: float) -> void:
	if is_in_water:
		gravity_scale = 0
		apply_central_force(Vector2(0,-60))
		linear_velocity.y *= 0.9
		linear_velocity.x *= 0.4
	else:
		gravity_scale = 0.4


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Water"):
		is_in_water = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("Water"):
		is_in_water = false
