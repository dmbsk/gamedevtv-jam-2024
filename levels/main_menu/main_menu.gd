extends Node2D

@export var level: PackedScene

@onready var game_start_interact: Interact = $InteractGameStart

func _ready() -> void:
	game_start_interact.Act.connect(on_game_start_act)

func on_game_start_act() -> void:
	get_tree().change_scene_to_packed(level)
