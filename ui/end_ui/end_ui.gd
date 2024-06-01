extends Control

@onready var points_label: Label = %Value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignals.RoundEnd.connect(_on_round_end)
	pass # Replace with function body.

func _on_exit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.

func _on_restart_pressed() -> void:
	GlobalSignals.RoundRestart.emit()
	get_tree().reload_current_scene()
	pass # Replace with function body.

func _on_round_end() -> void:
	points_label.text = str(int(GlobalPoints.total_points))
	visible = true
