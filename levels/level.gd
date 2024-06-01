extends Node2D

@export var round_time_in_minutes: float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignals.RoundStart.emit(round_time_in_minutes * 60)