extends Node2D

@export var round_time_in_minutes: float = 5.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignals.RoundStart.emit(round_time_in_minutes * 60)
	GlobalSignals.RoundEnd.connect(handle_round_end)

func handle_round_end():
	get_tree().quit()