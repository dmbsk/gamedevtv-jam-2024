extends Area2D

class_name Interact

signal Act

@onready var ui: Control = $Control

var is_player_in_area := false:
	set(value):
		is_player_in_area = value
		ui.visible = value

func _ready() -> void:
	ui.visible = true

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		is_player_in_area = true
		pass

func _on_body_exited(body: Node2D) -> void:
	is_player_in_area = false

func _input(event: InputEvent) -> void:
	if !is_player_in_area:
		return

	if event.is_action_pressed("interact"):
		Act.emit()
