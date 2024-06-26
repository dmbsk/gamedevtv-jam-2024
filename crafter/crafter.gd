extends Node2D

class_name Crafter

@onready var cash_in_audio: AudioStreamPlayer2D = %CashInSound

func _on_interact_act() -> void:
	var weight = deposit()
	if weight:
		cash_in_audio.play()
		GlobalSignals.CrafterDeposit.emit(weight)
		GlobalPoints.total_points += weight

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
			GlobalBackpack.update_count(prefabricateResource, -needs_count, true)
			weight += needs_count * PrefabricateWeight.get_weight(mat, type)

	return weight
