extends Control

@export var zoom_scale = Vector2(0.5, 0.5)

@onready var player: CharacterBody2D = %Player
@onready var level: Node2D = %MainLevel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in level.get_children():
		child.set_process(false)

	for child in player.get_children():
		if child is Camera2D:
			child.zoom = zoom_scale
