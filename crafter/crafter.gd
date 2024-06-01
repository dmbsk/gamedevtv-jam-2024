extends Area2D

class_name Crafter

signal Deposit()

@onready var ui: Control = $Control

var is_player_in_area := false:
	set(value):
		is_player_in_area = value
		ui.visible = value

func _on_body_entered(body: Node2D) -> void:
	is_player_in_area = false
	if body is Player:
		is_player_in_area = true

func _on_body_exited(body: Node2D) -> void:
	is_player_in_area = false

func _input(event: InputEvent) -> void:
	if !is_player_in_area:
		return

	if event.is_action_pressed("interact"):
		var weight = deposit()
		if weight:
			GlobalSignals.CrafterDeposit.emit(weight)
			GlobalSignals.PointsAdd.emit(weight)

func deposit() -> float:
	var weight := 0.0
	for mat in Prefabricate.PrefabricateMaterial.values():
		for type in Prefabricate.PrefabricateType.values():
			var needs_count = GlobalNeeds.prefabricate_counts[mat][type]
			var backpack_count = GlobalBackpack.prefabricate_counts[mat][type]
			if needs_count == 0 or backpack_count == 0:
				continue
			var prefabricateResource: PrefabricateResource = PrefabricateResource.init(mat, type)
			GlobalNeeds.update_count(prefabricateResource, -backpack_count)
			GlobalBackpack.update_count(prefabricateResource, -needs_count)
			weight += needs_count * PrefabricateWeight.get_weight(mat, type)

	return weight
