extends Node

var max_items := 3
var min_items := 0
var max_total_count := 6

var total_count := 0

var prefabricate_counts: Dictionary = {
	Prefabricate.PrefabricateMaterial.STEEL: {
	Prefabricate.PrefabricateType.ROD: 0,
	Prefabricate.PrefabricateType.WHEEL: 0,
	Prefabricate.PrefabricateType.PLATE: 0,
	},
	Prefabricate.PrefabricateMaterial.WOOD: {
	Prefabricate.PrefabricateType.ROD: 0,
	Prefabricate.PrefabricateType.WHEEL: 0,
	Prefabricate.PrefabricateType.PLATE: 0,
	}
}

signal CountUpdated(p: PrefabricateResource, count: int)

func _ready() -> void:
	generate_counts()

func generate_counts() -> void:
	var left_total_count = max_total_count
	for material_type in prefabricate_counts:
		for prefabricate_type in prefabricate_counts[material_type]:
			var count := randi_range(min_items, min(left_total_count, max_items))
			total_count += count
			left_total_count -= count
			update_count(PrefabricateResource.init(material_type, prefabricate_type), count)
			if left_total_count == 0:
				return

func update_count(p: PrefabricateResource, count: int) -> void:
	var currentCount = prefabricate_counts[p.prefabricate_material][p.prefabricate_type]
	var nextCount = max(currentCount + count, 0)
	
	if currentCount == nextCount:
		return

	prefabricate_counts[p.prefabricate_material][p.prefabricate_type] = nextCount
	total_count -= min(currentCount, abs(count))
	CountUpdated.emit(p, nextCount)

	print("count", count)
	print("total count", total_count)
	if total_count == 0:
		generate_counts()
		print(prefabricate_counts)