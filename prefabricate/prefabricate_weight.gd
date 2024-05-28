extends Node

class_name PrefabricateWeight

static var material_weight: Dictionary = {
	Prefabricate.PrefabricateMaterial.STEEL: 2.0,
	Prefabricate.PrefabricateMaterial.WOOD: 1.0
}

static var type_weight: Dictionary = {
	Prefabricate.PrefabricateType.PLATE: 3.0,
	Prefabricate.PrefabricateType.ROD: 2.0,
	Prefabricate.PrefabricateType.WHEEL: 1.0
}

static func get_weight(mat: Prefabricate.PrefabricateMaterial, type: Prefabricate.PrefabricateType) -> float:
	return PrefabricateWeight.material_weight[mat] + PrefabricateWeight.type_weight[type]
