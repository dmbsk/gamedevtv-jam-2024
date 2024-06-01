extends Camera2D

class_name SmoothCamera2D

@export var player: Player
@export var camera_smoothness := Vector2(17.0, 10.0)
@export var offset_smoothness := 0.5

func _process(delta: float) -> void:
	global_position.x = lerpf(global_position.x, player.global_position.x, camera_smoothness.x * delta)
	global_position.y = lerpf(global_position.y, player.global_position.y, camera_smoothness.y * delta)
