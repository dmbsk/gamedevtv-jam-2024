extends StaticBody2D

@export var crafting_material: PrefabricateResource

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !(body is Player):
		return

	GlobalNeeds.update_count(crafting_material)
	GlobalBackpack.update_count(crafting_material)
	animated_sprite.play("press")

func _on_area_2d_body_exited(body: Node2D) -> void:
	animated_sprite.play("release")
