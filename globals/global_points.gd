extends Node

signal Update(current_points: float, last_points: float)

var total_points := 0.0:
		set(value):
			Update.emit(value, total_points)
			total_points = value

func _ready() -> void:
	GlobalSignals.RoundRestart.connect(_on_round_restart)

func _on_round_restart() -> void:
	total_points = 0.0